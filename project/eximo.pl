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
	printTurnInfo(Player), nl, nl,
	getPieceToBeMovedSourceCoords(SrcRow, SrcCol),
	validateChosenPieceOwnership(SrcRow, SrcCol, Board, Player),

	clearConsole,
	printBoard(Board),
	printTurnInfo(Player), nl, nl,
	getPieceToBeMovedDestinyCoords(DestRow, DestCol),
	validateDifferentCoordinates(SrcRow, SrcCol, DestRow, DestCol),

	validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
	changePlayer(TempGame, ResultantGame), !,
	playGame(ResultantGame).

% game is over when one of the players have no checkers left
playGame(Game):-
	clearConsole,
	getGameBoard(Game, Board),
	printBoard(Board),

	% get the number of checkers of each player to know who has lost
	getGameNumWhitePieces(Game, NumWhitePieces),
	getGameNumBlackPieces(Game, NumBlackPieces),
	(
		(NumWhitePieces =:= 0, NumBlackPieces > 0) ->
			(write('# Game over. Black player won, congratulations!'), nl);
		(NumWhitePieces > 0, NumBlackPieces =:= 0) ->
			(write('# Game over. White player won, congratulations!'), nl);
		(write('# ERROR: unexpected game over.'), nl)
	),
	nl,
	pressEnterToContinue, !.

%===========================%
%= @@ game input functions =%
%===========================%
getPieceToBeMovedSourceCoords(SrcRow, SrcCol):-
	write('Please insert the coordinates of the piece you wish to move and press <Enter> - example: 3f.'), nl,
	inputCoords(SrcRow, SrcCol), nl.

getPieceToBeMovedDestinyCoords(DestRow, DestCol):-
	write('Please insert the DESTINY coordinates of that piece and press <Enter>.'), nl,
	inputCoords(DestRow, DestCol), nl.

inputCoords(SrcRow, SrcCol):-
	% read row
	getInt(RawSrcRow),

	% read column
	getInt(RawSrcCol),

	% discard enter
	discardInputChar,

	% process row and column
	SrcRow is RawSrcRow-1,
	SrcCol is RawSrcCol-49.

%==============================================%
%= @@ board validation/manipulation functions =%
%==============================================%
assertBothPlayersHavePiecesOnTheBoard(Game):-
	getGameNumWhitePieces(Game, NumWhitePieces),
	getGameNumBlackPieces(Game, NumBlackPieces),
	NumWhitePieces > 0,
	NumBlackPieces > 0, !.

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

% tries to validate a move according to it properties
validateMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	validateOrdinaryMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame);
	validateJumpMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame);
	validateCaptureMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame);
	invalidMove.

% ordinary move
validateOrdinaryMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),

	% check if destiny is a forward or diagonally forward adjacent empty cell
	DeltaRow is DestRow - SrcRow,
	DeltaCol is abs(DestCol - SrcCol),
	(
		Player == whitePlayer -> DeltaRow =:= 1, DeltaCol =< 1;
		Player == blackPlayer -> DeltaRow =:= -1, DeltaCol =< 1
	),

	% check if destiny cell is empty
	getMatrixElemAt(DestRow, DestCol, Board, Cell),
	Cell == emptyCell,

	% actually move the checker
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame), !.

% jump move
validateJumpMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	testJumpMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame), !,

	getGamePlayerTurn(TempGame, Player),
	getGameBoard(TempGame, TempBoard),
	DeltaRow is DestRow - SrcRow,

	% if that piece can continue to jump, then it must do so
	(
		(
			testJumpMove(DestRow, DestCol, DestRow + DeltaRow, DestCol - 2, TempGame, _);
			testJumpMove(DestRow, DestCol, DestRow + DeltaRow, DestCol, TempGame, _);
			testJumpMove(DestRow, DestCol, DestRow + DeltaRow, DestCol + 2, TempGame, _)
		)
		->
		(
			repeat,

			clearConsole,
			printBoard(TempBoard),
			printTurnInfo(Player),
			write('# If a checker can continue to jump, then it must do so.'), nl, nl,
			getPieceToBeMovedDestinyCoords(NextDestRow, NextDestCol),
			validateDifferentCoordinates(DestRow, DestCol, NextDestRow, NextDestCol),

			setGameBoard(TempBoard, TempGame, ItGame),
			(
				validateJumpMove(DestRow, DestCol, NextDestRow, NextDestCol, ItGame, ResultantGame);
				invalidMove
			), !
		);
		ResultantGame = TempGame
	), !.

% capture move
validateCaptureMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	testCaptureMove(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame), !,

	getGamePlayerTurn(TempGame, Player),
	getGameBoard(TempGame, TempBoard),
	DeltaRow is DestRow - SrcRow,

	% if that piece can continue to capture, then it must do so
	(
		(
			testCaptureMove(DestRow, DestCol, DestRow, DestCol - 2, TempGame, _);
			testCaptureMove(DestRow, DestCol, DestRow + DeltaRow, DestCol - 2, TempGame, _);
			testCaptureMove(DestRow, DestCol, DestRow + DeltaRow, DestCol, TempGame, _);
			testCaptureMove(DestRow, DestCol, DestRow + DeltaRow, DestCol + 2, TempGame, _);
			testCaptureMove(DestRow, DestCol, DestRow, DestCol + 2, TempGame, _)
		)
		->
		(
			repeat,

			clearConsole,
			printBoard(TempBoard),
			printTurnInfo(Player),
			write('# If a checker can continue to capture, then it must do so.'), nl, nl,
			getPieceToBeMovedDestinyCoords(NextDestRow, NextDestCol),
			validateDifferentCoordinates(DestRow, DestCol, NextDestRow, NextDestCol),

			setGameBoard(TempBoard, TempGame, ItGame),
			(
				validateCaptureMove(DestRow, DestCol, NextDestRow, NextDestCol, ItGame, ResultantGame);
				invalidMove
			), !
		);
		ResultantGame = TempGame
	), !.

% invalid move
invalidMove:-
	write('INVALID MOVE!'), nl,
	write('A checker can only move to a forward or a diagonally forward (north, north-east or north-west) adjacent empty cell.'), nl,
	write('A checker can jump over a friendly checker if the next cell in the same direction of the jump is empty.'), nl,
	write('Finally, a checker can capture an oponent\'s checker by jumping over them, similarly to the jumping move.'), nl,
	write('In addition to the three possible move/jumping directions, a capture can also occur to the sides (left or right).'), nl,
	pressEnterToContinue, nl,
	fail.

testJumpMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),

	% validate vertical movement
	DeltaRow is DestRow - SrcRow,
	(
		Player == whitePlayer -> DeltaRow =:= 2;
		Player == blackPlayer -> DeltaRow =:= -2
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
	getMatrixElemAt(MiddleCellRow, MiddleCellCol, Board, MiddleCell),
	(
		Player == whitePlayer -> MiddleCell == whiteCell;
		Player == blackPlayer -> MiddleCell == blackCell
	),

	% actually move the checker
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame).

testCaptureMove(SrcRow, SrcCol, DestRow, DestCol, Game, ResultantGame):-
	getGameBoard(Game, Board),
	getGamePlayerTurn(Game, Player),

	% validate vertical movement
	DeltaRow is DestRow - SrcRow,
	(
		DeltaRow =:= 0;
		Player == whitePlayer -> DeltaRow =:= 2;
		Player == blackPlayer -> DeltaRow =:= -2
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
	getMatrixElemAt(MiddleCellRow, MiddleCellCol, Board, MiddleCell),
	(
		Player == whitePlayer -> MiddleCell == blackCell;
		Player == blackPlayer -> MiddleCell == whiteCell
	),

	% actually move the checker and capture the oponent checker
	movePiece(SrcRow, SrcCol, DestRow, DestCol, Game, TempGame),
	capturePieceAt(MiddleCellRow, MiddleCellCol, TempGame, ResultantGame).

% moves a piece from source to destiny
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

% remove piece at coordinates and update player piece counter
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
		Player == whitePlayer ->
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
	write('# It is '), write(PlayerName), write(' player\'s turn to play.'), nl, !.

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
