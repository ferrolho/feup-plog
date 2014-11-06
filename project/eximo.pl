%=======================================%
%=           ..:: EXIMO ::..           =%
%=                                     =%
%=   Type 'eximo.' to start the game   =%
%=                                     =%
%=======================================%
%=                                     =%
%=          ..:: Authors ::..          =%
%=                                     =%
%=  Henrique Ferrolho && Joao Pereira  =%
%=             FEUP - 2014             =%
%=                                     =%
%=======================================%

%===============%
%= @@ includes =%
%===============%
:- include('gameObj.pl').
:- include('menus.pl').
:- include('utilities.pl').

%====================%
%= @@ game launcher =%
%====================%
eximo:-
	mainMenu.

%===============================%
%= @@ player, pieces and cells =%
%===============================%
player(whitePlayer).
player(blackPlayer).

getPlayerName(whitePlayer, 'White').
getPlayerName(blackPlayer, 'Black').

piece(whitePiece).
piece(blackPiece).

getCellSymbol(emptyCell, ' ').
getCellSymbol(whiteCell, 'O').
getCellSymbol(blackCell, '#').
getCellSymbol(_, '?').

pieceIsOwnedBy(whiteCell, whitePlayer).
pieceIsOwnedBy(blackCell, blackPlayer).

%======================%
%= @@ main game cycle =%
%======================%
playGame(Game):-
	assertBothPlayersHavePiecesOnTheBoard(Game),
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),

	repeat,

	clearConsole,
	printBoard(Board),
	printTurnInfo(Player),
	getPieceToBeMovedSourceCoords(SrcRow, SrcCol),
	validateChosenPieceOwnership(SrcRow, SrcCol, Board, Player),

	clearConsole,
	printBoard(Board),
	printTurnInfo(Player),
	getPieceToBeMovedDestinyCoords(DestRow, DestCol),
	validateDifferentCoordinates(SrcRow, SrcCol, DestRow, DestCol),

	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
	changePlayer(TempGame, ResultantGame), !,
	playGame(ResultantGame).

playGame(Game):-
	getGameNumWhitePieces(Game, NumWhitePieces),
	getGameNumBlackPieces(Game, NumBlackPieces),
	NumWhitePieces = 0,
	NumBlackPieces > 0,
	clearConsole,
	getGameBoard(Game, Board),
	printBoard(Board),
	write('# Game over. Black player won, congratulations!'), nl,
	nl,
	pressEnterToContinue, !.

playGame(Game):-
	getGameNumWhitePieces(Game, NumWhitePieces),
	getGameNumBlackPieces(Game, NumBlackPieces),
	NumWhitePieces > 0,
	NumBlackPieces = 0,
	clearConsole,
	getGameBoard(Game, Board),
	printBoard(Board),
	write('# Game over. White player won, congratulations!'), nl,
	nl,
	pressEnterToContinue, !.

assertBothPlayersHavePiecesOnTheBoard(Game):-
	getGameNumWhitePieces(Game, NumWhitePieces),
	getGameNumBlackPieces(Game, NumBlackPieces),
	NumWhitePieces > 0,
	NumBlackPieces > 0, !.

%===========================%
%= @@ game input functions =%
%===========================%
getPieceToBeMovedSourceCoords(SrcRow, SrcCol):-
	write('Please insert the coordinates of the piece you wish to move:'), nl,
	write('Row: [1-8] '), inputBoardRow(SrcRow),
	write('Column: [a-h] '), inputBoardColumn(SrcCol),
	nl.

getPieceToBeMovedDestinyCoords(DestRow, DestCol):-
	write('Please insert the DESTINY coordinates of that piece:'), nl,
	write('Row: [1-8] '), inputBoardRow(DestRow),
	write('Column: [a-h] '), inputBoardColumn(DestCol),
	nl.

validateChosenPieceOwnership(SrcRow, SrcCol, Board, Player):-
	getMatrixElemAt(SrcRow, SrcCol, Board, Piece),
	pieceIsOwnedBy(Piece, Player), !.
validateChosenPieceOwnership(_, _, _, _):-
	write('INVALID PIECE!'), nl,
	write('A player can only move his/her own pieces.'), nl,
	pressEnterToContinue, nl,
	fail.

validateDifferentCoordinates(SrcRow, SrcCol, DestRow, DestCol):-
	SrcRow \= DestRow ; SrcCol \= DestCol, !.
validateDifferentCoordinates(_, _, _, _):-
	write('INVALID INPUT!'), nl,
	write('The source and destiny coordinates must be different.'), nl,
	pressEnterToContinue, nl,
	fail.

inputBoardRow(Row):-
	getCode(RawRow),
	Row is RawRow-1.

inputBoardColumn(Column):-
	getCode(RawCol),
	Column is RawCol-49.

%===================================%
%= @@ board manipulation functions =%
%===================================%
movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),

	getMatrixElemAt(SrcRow, SrcCol, Board, SrcElem),
	getMatrixElemAt(DestRow, DestCol, Board, DestElem),

	setMatrixElemAtWith(SrcRow, SrcCol, emptyCell, Board, TempBoard),
	setMatrixElemAtWith(DestRow, DestCol, SrcElem, TempBoard, ResultantBoard),

	(
		DestElem = whiteCell -> decNumWhitePieces(Game, TempGame);
		DestElem = blackCell -> decNumBlackPieces(Game, TempGame);
		DestElem = emptyCell -> TempGame = Game
	),

	setGameBoard(ResultantBoard, TempGame, ResultantGame).

%%% 1. current player; 2. next player.
changePlayer(Game, ResultantGame):-
	getGamePlayerTurn(Game, Player),
	(
		Player = whitePlayer ->
		NextPlayer = blackPlayer;
		NextPlayer = whitePlayer
	),
	setGamePlayerTurn(NextPlayer, Game, ResultantGame).

%===============================%
%= @@ board printing functions =%
%===============================%
%%% prints the name of the player of the current turn
printTurnInfo(Player):-
	getPlayerName(Player, PlayerName),
	write('# It is '), write(PlayerName), write(' player\'s turn to play.'), nl,
	nl.

printBoard([Line | Tail]):-
	printColumnIdentifiers, nl,
	printInitialSeparator, nl,
	rowIdentifiersList(RowIdentifiers),
	printRemainingBoard([Line | Tail], RowIdentifiers),
	nl, !.

printColumnIdentifiers:-
	write('        a     b     c     d     e     f     g     h').

printInitialSeparator:-
	write('      _______________________________________________').

rowIdentifiersList(['  1  ', '  2  ', '  3  ', '  4  ', '  5  ', '  6  ', '  7  ', '  8  ']).

printRemainingBoard([], []).
printRemainingBoard([Line | Tail], [RowIdentifiersListHead | RowIdentifiersListTail]):-
	printBoardRow(Line, RowIdentifiersListHead),
	printRemainingBoard(Tail, RowIdentifiersListTail).

printBoardRow([], []).
printBoardRow(Line, RowIdentifiersListHead):-
	length(Line, Length),
	createSeparatorN(Length, '_____|', Separator),
	createSeparatorN(Length, '     |', Separator2),
	write('     '), write('|'), printList(Separator2), nl,
	write(RowIdentifiersListHead), write('|'), printBoardRowValues(Line), nl,
	write('     '), write('|'), printList(Separator), nl.

createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).

printBoardRowValues([]).
printBoardRowValues([Head | Tail]):-
	getCellSymbol(Head, Piece),
	write('  '), write(Piece), write('  |'),
	printBoardRowValues(Tail).

%======================================%
%= @@ lists and matrices constructors =%
%======================================%
createMatrixSizeN(0, [[]]).
createMatrixSizeN(N, M):-
	createMatrixSizeN(N, N, M).

createMatrixSizeN(_, 0, []).
createMatrixSizeN(N, I, [Line | RT]):-
	createListSizeN(N, Line),
	I1 is I-1,
	createMatrixSizeN(N, I1, RT).

createListSizeN(0, []).
createListSizeN(N, ['0' | Ls]):-
	N1 is N-1,
	createListSizeN(N1, Ls).

%======================================%
%= @@ lists and matrices manipulation =%
%======================================%
%%% 1. container; 2. elem at the front.
peekFront([ElemAtTheHead|_], ElemAtTheHead).

%%% 1. element row; 2. element column; 3. matrix; 4. query element.
getMatrixElemAt(0, ElemCol, [ListAtTheHead|_], Elem):-
	getListElemAt(ElemCol, ListAtTheHead, Elem).
getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).

%%% 1. element position; 2. list; 3. query element.
getListElemAt(0, [ElemAtTheHead|_], ElemAtTheHead).
getListElemAt(Pos, [_|RemainingElems], Elem):-
	Pos > 0,
	Pos1 is Pos-1,
	getListElemAt(Pos1, RemainingElems, Elem).

%%% 1. element row; 2. element column; 3. element to use on replacement; 3. current matrix; 4. resultant matrix.
setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
	setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

%%% 1. position; 2. element to use on replacement; 3. current list; 4. resultant list.
setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
	I > 0,
	I1 is I-1,
	setListElemAtWith(I1, Elem, L, ResL).

%%% 1. element to be replaced; 2. element to use on replacements; 3. current matrix; 4. resultant matrix.
replaceMatrixElemWith(_, _, [], []).
replaceMatrixElemWith(A, B, [Line|RL], [ResLine|ResRL]):-
	replaceListElemWith(A, B, Line, ResLine),
	replaceMatrixElemWith(A, B, RL, ResRL).

%%% 1. element to be replaced; 2. element to use on replacements; 3. current list; 4. resultant list.
replaceListElemWith(_, _, [], []).
replaceListElemWith(A, B, [A|L1], [B|L2]):-
	replaceListElemWith(A, B, L1, L2).
replaceListElemWith(A, B, [C|L1], [C|L2]):-
	C \= A,
	replaceListElemWith(A, B, L1, L2).

%=========================================%
%= @@ lists and matrices print functions =%
%=========================================%
printMatrix([], _).
printMatrix([Line | Tail], Separator):-
	printList(Line, Separator), nl,
	printMatrix(Tail, Separator).

printList([], _).
printList([Head | Tail], Separator):-
	write(Head), write(Separator),
	printList(Tail, Separator).

printMatrix([]).
printMatrix([Line | Tail]):-
	printList(Line), nl,
	printMatrix(Tail).

printList([]).
printList([Head | Tail]):-
	write(Head),
	printList(Tail).
