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
:- include('containers.pl').
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

	validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),

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

inputBoardRow(Row):-
	getCode(RawRow),
	Row is RawRow-1.

inputBoardColumn(Column):-
	getCode(RawCol),
	Column is RawCol-49.

validateChosenPieceOwnership(SrcRow, SrcCol, Board, Player):-
	getMatrixElemAt(SrcRow, SrcCol, Board, Piece),
	pieceIsOwnedBy(Piece, Player), !.
validateChosenPieceOwnership(_, _, _, _):-
	write('INVALID PIECE!'), nl,
	write('A player can only move his/her own pieces.'), nl,
	pressEnterToContinue, nl,
	fail.

validateDifferentCoordinates(SrcRow, SrcCol, DestRow, DestCol):-
	(SrcRow \= DestRow ; SrcCol \= DestCol), !.
validateDifferentCoordinates(_, _, _, _):-
	write('INVALID INPUT!'), nl,
	write('The source and destiny coordinates must be different.'), nl,
	pressEnterToContinue, nl,
	fail.

%===================================%
%= @@ board manipulation functions =%
%===================================%
% ordinary move
validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),
	% check if destiny is a forward or diagonally forward adjacent empty cell
	DeltaRow is DestRow - SrcRow,
	DeltaCol is abs(DestCol - SrcCol),
	(
		Player = whitePlayer -> DeltaRow =:= 1, DeltaCol =< 1;
		Player = blackPlayer -> DeltaRow =:= -1, DeltaCol =< 1
	),
	% check if destiny cell is empty
	getMatrixElemAt(DestRow, DestCol, Board, Cell),
	Cell == emptyCell,
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame), !.

% jump move
validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),
	% validate vertical movement
	DeltaRow is DestRow - SrcRow,
	(
		Player = whitePlayer -> DeltaRow =:= 2;
		Player = blackPlayer -> DeltaRow =:= -2
	),
	% validate horizontal movement
	DeltaCol is abs(DestCol - SrcCol),
	(DeltaCol =:= 0; DeltaCol =:= 2),
	% check if destiny cell is empty
	getMatrixElemAt(DestRow, DestCol, Board, Cell),
	Cell == emptyCell,
	% check if cell between source and destiny is friendly
	MiddleCellRow is SrcRow + DeltaRow // 2,
	MiddleCellCol is SrcCol + (DestCol - SrcCol) // 2,
	write(MiddleCellRow - MiddleCellCol), nl,
	getMatrixElemAt(MiddleCellRow, MiddleCellCol, Board, MiddleCell),
	(
		Player = whitePlayer -> MiddleCell == whiteCell;
		Player = blackPlayer -> MiddleCell == blackCell
	),
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame), !.

% capture move
validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),
	% validate vertical movement
	DeltaRow is DestRow - SrcRow,
	(
		DeltaRow =:= 0;
		Player = whitePlayer -> DeltaRow =:= 2;
		Player = blackPlayer -> DeltaRow =:= -2
	),
	% validate horizontal movement
	DeltaCol is abs(DestCol - SrcCol),
	(DeltaCol =:= 0; DeltaCol =:= 2),
	% check if destiny cell is empty
	getMatrixElemAt(DestRow, DestCol, Board, Cell),
	Cell == emptyCell,
	% check if cell between source and destiny is owned by the oponent
	MiddleCellRow is SrcRow + DeltaRow // 2,
	MiddleCellCol is SrcCol + (DestCol - SrcCol) // 2,
	write(MiddleCellRow - MiddleCellCol), nl,
	getMatrixElemAt(MiddleCellRow, MiddleCellCol, Board, MiddleCell),
	(
		Player = whitePlayer -> MiddleCell == blackCell;
		Player = blackPlayer -> MiddleCell == whiteCell
	),
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
	capturePieceAt(MiddleCellRow, MiddleCellCol, TempGame, ResultantGame), !.

validateMove(_, _, _, _, _, _):-
	write('INVALID MOVE!'), nl,
	write('A checker can only move to a forward or a diagonally forward (north, north-east or north-west) adjacent empty cell.'), nl,
	write('A checker can jump over a friendly checker if the next cell in the same direction of the jump is empty.'), nl,
	write('Finally, a checker can capture an oponent\'s checker by jumping over them, similarly to the jumping move.'), nl,
	write('In addition to the three possible move/jumping directions, a capture can also occur to the sides (left or right).'), nl,
	pressEnterToContinue, nl,
	fail.

movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	% get current board
	getGameBoard(Game, Board),

	% get piece to be moved
	getMatrixElemAt(SrcRow, SrcCol, Board, SrcElem),

	% empty source cell
	setMatrixElemAtWith(SrcRow, SrcCol, emptyCell, Board, TempBoard),

	% place piece on destiny cell
	setMatrixElemAtWith(DestRow, DestCol, SrcElem, TempBoard, ResultantBoard),

	% save the board
	setGameBoard(ResultantBoard, Game, ResultantGame).

capturePieceAt(Row, Col, Game, ResultantGame):-
	% get current board
	getGameBoard(Game, Board),

	% save captured piece cell
	getMatrixElemAt(Row, Col, Board, CapturedPieceCell),

	% empty captured piece cell
	setMatrixElemAtWith(Row, Col, emptyCell, Board, ResultantBoard),

	% save the board
	setGameBoard(ResultantBoard, Game, TempGame),

	% decrement player number of pieces according to the captured piece cell type
	(
		CapturedPieceCell == whiteCell -> decNumWhitePieces(TempGame, ResultantGame);
		CapturedPieceCell == blackCell -> decNumBlackPieces(TempGame, ResultantGame);
		CapturedPieceCell == emptyCell -> ResultantGame = TempGame

	), !.

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
	nl, !.

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
