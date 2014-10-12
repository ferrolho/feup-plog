%===========================%
%=     ..:: EXIMO ::..     =%
%===========================%
%= Authors:                =%
%=  > Henrique Ferrolho    =%
%=  > Joao Pereira         =%
%===========================%
eximo:-
	mainMenu.

%==============%
%= Game menus =%
%==============%
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
		typeToContinue, nl,
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
	createMatrixSizeN(8, T),
	printBoard(T),
	typeToContinue, nl.

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
	write('=                                                   Page 1 of 3   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	typeToContinue, nl,
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
	write('=                                                   Page 2 of 3   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	typeToContinue, nl,
	clearConsole,
	write('==================================================================='), nl,
	write('=                      ..:: How to play ::..                      ='), nl,
	write('==================================================================='), nl,
	write('=                                                                 ='), nl,
	write('=   When there is more than one way to jump, the player may       ='), nl,
	write('=   choose which piece to jump with, and which jumping option     ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                                 ='), nl,
	write('=                                                   Page 3 of 3   ='), nl,
	write('=                                                                 ='), nl,
	write('==================================================================='), nl,
	typeToContinue, nl.

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
	typeToContinue, nl.

typeToContinue:-
	write('Type anything to continue:'), nl,
	getChar(_).

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

%===========%
%= bla bla =%
%===========%
piece(white, 'O').
piece(black, '#').
piece(empty, ' ').

initialaBoard([
	[empty, white, white, white, white, white, white, empty],
	[empty, white, white, white, white, white, white, empty],
	[empty, white, white, empty, empty, white, white, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, black, black, empty, empty, black, black, empty],
	[empty, black, black, black, black, black, black, empty],
	[empty, black, black, black, black, black, black, empty]]).

emptyBoard([
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty],
	[empty, empty, empty, empty, empty, empty, empty, empty]]).

%=====================================%
%= Regular list and matrix functions =%
%=====================================%
printList([]).
printList([Head | Tail]):-
	write(Head),
	printList(Tail).

printMatrix([]).
printMatrix([Line | Tail]):-
	printList(Line), nl,
	printMatrix(Tail).

%=================%
%= Board drawing =%
%=================%
createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).

printBoardRowValues([]).
printBoardRowValues([Head | Tail]):-
	write('  '), write(Head), write('  |'),
	printBoardRowValues(Tail).

printBoardRow([]).
printBoardRow(Line):-
	length(Line, Length),
	createSeparatorN(Length, '_____|', Separator),
	createSeparatorN(Length, '     |', Separator2),
	write('|'), printList(Separator2), nl,
	write('|'), printBoardRowValues(Line), nl,
	write('|'), printList(Separator), nl.

printRemainingBoard([]).
printRemainingBoard([Line | Tail]):-
	printBoardRow(Line),
	printRemainingBoard(Tail).

printBoard([Line | Tail]):-
	length(Line, Length),
	createSeparatorN(Length, '_____|', Separator),
	write('|'), printList(Separator), nl,
	printRemainingBoard([Line | Tail]).

%===============================%
%= Lists and matrices creation =%
%===============================%
createListSizeN(0, []).
createListSizeN(N, ['0' | Ls]):-
	N1 is N-1,
	createListSizeN(N1, Ls).

createMatrixSizeN(0, [[]]).
createMatrixSizeN(N, M):-
	createMatrixSizeN(N, N, M).
createMatrixSizeN(_, 0, []).
createMatrixSizeN(N, I, [Line | RT]):-
	createListSizeN(N, Line),
	I1 is I-1,
	createMatrixSizeN(N, I1, RT).
