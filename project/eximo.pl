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
eximo:-
	mainMenu.

%=================%
%= @@ game menus =%
%=================%
mainMenu:-
	printMainMenu,
	getChar(Input),
	(
		Input = '1' -> playGame, mainMenu;
		Input = '2' -> helpMenu, mainMenu;
		Input = '3' -> aboutMenu, mainMenu;
		Input = '4';

		nl,
		write('Error: invalid input.'), nl,
		pressEnterToContinue, nl,
		eximo
	).

printMainMenu:-
	clearConsole,
	write('==========================='), nl,
	write('=     ..:: EXIMO ::..     ='), nl,
	write('==========================='), nl,
	write('=                         ='), nl,
	write('=   1. Play               ='), nl,
	write('=   2. How to play        ='), nl,
	write('=   3. About              ='), nl,
	write('=   4. Exit               ='), nl,
	write('=                         ='), nl,
	write('==========================='), nl,
	write('Choose an option:'), nl.

playGame:-
	clearConsole,
	initialBoard(Board),
	printBoard(Board),
	pressEnterToContinue, nl.

helpMenu:-
	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   Eximo is a member of the Checkers family.                     ='), nl,
	write('=                                                                 ='), nl,
	write('=   Objective:                                                    ='), nl,
	write('=     Capture all your opponent\'s pieces by jumping over them,    ='), nl,
	write('=     or stalemate the opponent so he has no moves.               ='), nl,
	write('=                                                                 ='), nl,
	write('=   Turn:                                                         ='), nl,
	write('=     In each turn, a player can make one of the two actions:     ='), nl,
	write('=     move or capture.                                            ='), nl,
	write('=                                                                 ='), nl,
	write('=   Move:                                                         ='), nl,
	write('=     A checker can move in 3 directions: forward or diagonally   ='), nl,
	write('=     forward (north, north-east or north-west).                  ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 1 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	pressEnterToContinue, nl,

	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   There are two types of moves:                                 ='), nl,
	write('=     ordinary move and jumping move.                             ='), nl,
	write('=                                                                 ='), nl,
	write('=   Ordinary move: a checker moves to a (forward or diagonally    ='), nl,
	write('=      forward) adjacent and empty square.                        ='), nl,
	write('=                                                                 ='), nl,
	write('=   Jumping move: a checker moves to a (forward or diagonally     ='), nl,
	write('=     forward) adjacent friendly piece if the next square in      ='), nl,
	write('=     the same direction is empty, placing the jumping checker    ='), nl,
	write('=     on the next empty square. If the same player\'s checker      ='), nl,
	write('=     can continue moving by jumping another friendly piece       ='), nl,
	write('=     then it must do so. During the jumping move that checker    ='), nl,
	write('=     cannot capture.                                             ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 2 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	pressEnterToContinue, nl,

	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   When there is more than one way to jump, the player may       ='), nl,
	write('=   choose which piece to jump with, and which jumping option     ='), nl,
	write('=   or sequence of jumps to make. The jumping sequence chosen     ='), nl,
	write('=   is not required to be the one which maximizes the number of   ='), nl,
	write('=   jumps; however, a player must make all available jumps in     ='), nl,
	write('=   the sequence chosen.                                          ='), nl,
	write('=                                                                 ='), nl,
	write('=   Capture:                                                      ='), nl,
	write('=     A checker can capture in 5 directions: forward,             ='), nl,
	write('=     diagonally forward, right or left (north, north-east,       ='), nl,
	write('=     north-west, east or west).                                  ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 3 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	pressEnterToContinue, nl,

	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   A checker jumps over a (forward, diagonally forward, right    ='), nl,
	write('=   or left) adjacent opponent\'s piece if the next square in      ='), nl,
	write('=   the same direction is empty, placing the jumping checker on   ='), nl,
	write('=   the next empty square. The opponent\'s piece is removed from   ='), nl,
	write('=   the board immediately. If the same player\'s checker can       ='), nl,
	write('=   continue capturing by jumping another opponent\'s piece then   ='), nl,
	write('=   it must do so. Capturing is mandatory, and you must keep      ='), nl,
	write('=   capturing as long as it is possible.                          ='), nl,
	write('=                                                                 ='), nl,
	write('=   As in the jumping move, the player chooses freely which       ='), nl,
	write('=   jumping sequence to take.                                     ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 4 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	pressEnterToContinue, nl,

	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   On the last row:                                              ='), nl,
	write('=   When a checker reaches the other end of the board, it is      ='), nl,
	write('=   removed from the board immediately and the player gets two    ='), nl,
	write('=   extra-moves to make instantly: dropping two new checkers in   ='), nl,
	write('=   any empty square in his own first two rows, except in the     ='), nl,
	write('=   four squares on the sides.                                    ='), nl,
	write('=   The drop zone for Black: b1, c1, d1, e1, f1, g1, b2, c2,      ='), nl,
	write('=   d2, e2, f2, g2; for White: b8, c8, d8, e8, f8, g8, b7, c7,    ='), nl,
	write('=   d7, e7, f7, g7).                                              ='), nl,
	write('=                                                                 ='), nl,
	write('=   If a checker reaches the other end of the board and there     ='), nl,
	write('=   isn\'t any empty square in the drop zone, the player loses     ='), nl,
	write('=   that piece. If there is just one empty square in the drop     ='), nl,
	write('=   zone, the player gets only one drop.                          ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 5 of 5   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	pressEnterToContinue, nl.

aboutMenu:-
	clearConsole,
	write('============================='), nl,
	write('=      ..:: About ::..      ='), nl,
	write('============================='), nl,
	write('=                           ='), nl,
	write('=   Authors:                ='), nl,
	write('=    > Henrique Ferrolho    ='), nl,
	write('=    > Joao Pereira         ='), nl,
	write('=                           ='), nl,
	write('============================='), nl,
	pressEnterToContinue, nl.

%=======================%
%= @@ cell translation =%
%=======================%
cell(empty, ' ').
cell(white, 'O').
cell(black, '#').
cell(_, '?').

%====================%
%= @@ board presets =%
%====================%
emptyBoard([
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty]]).

initialBoard([
	[empty, white, white, white, white, white, white, empty],
	[empty, white, white, white, white, white, white, empty],
	[empty, white, white, empty, empty, white, white, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, black, black, empty, empty, black, black, empty],
	[empty, black, black, black, black, black, black, empty],
	[empty, black, black, black, black, black, black, empty]]).

%==============================%
%= @@ board drawing functions =%
%==============================%
printBoard([Line | Tail]):-
	printColumnIdentifiers, nl,
	printInitialSeparator, nl,
	rowIdentifiersList(RowIdentifiers),
	printRemainingBoard([Line | Tail], RowIdentifiers), nl.

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
	cell(Head, Piece),
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

%========================%
%= @@ console utilities =%
%========================%
pressEnterToContinue:-
	write('Press <Enter> to continue:'), nl,
	waitForEnter.

waitForEnter:-
	get_char(_).

clearConsole:-
	clearConsole(40).

clearConsole(0).
clearConsole(N):-
	nl,
	N1 is N-1,
	clearConsole(N1).

getChar(Input):-
	get_char(Input),
	get_char(_).
