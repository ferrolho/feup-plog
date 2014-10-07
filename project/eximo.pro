piece(white, 'O').
piece(black, '#').
piece(empty, ' ').

initialBoard([
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
printList([Head | Tail]) :-
	write(Head),
	printList(Tail).

printMatrix([]).
printMatrix([Line | Tail]) :-
	printList(Line), nl,
	printMatrix(Tail).

%============================%
%= Board specific functions =%
%============================%
printBoardLineList([]).
printBoardLineList([Head | Tail]) :-
	write(' '), write(Head), write(' |'),
	printBoardLineList(Tail).

printBoardLine([]).
printBoardLine(Line) :-
	length(Line, Length),
	createSeparatorN(Length, '___|', Separator),
	createSeparatorN(Length, '   |', Separator2),
	write('|'), printList(Separator2), nl,
	write('|'), printBoardLineList(Line), nl,
	write('|'), printList(Separator), nl.

printBoard([Line | Tail]) :-
	length(Line, Length),
	createSeparatorN(Length, '____', Separator),
	printList(Separator), write('_'), nl,
	printBoard2([Line | Tail]).
printBoard2([]).
printBoard2([Line | Tail]) :-
	printBoardLine(Line),
	printBoard2(Tail).

createSeparatorN(0, SS, []).
createSeparatorN(N, SS, [SS | Ls]) :-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).

createListSizeN(0, []).
createListSizeN(N, [0 | Ls]) :-
	N1 is N-1,
	createListSizeN(N1, Ls).

createMatrixSizeN(0, [[]]).
createMatrixSizeN(N, M) :-
	createMatrixSizeN(N, N, M).
createMatrixSizeN(N, 0, []).
createMatrixSizeN(N, I, [Line | RT]) :-
	createListSizeN(N, Line),
	I1 is I-1,
	createMatrixSizeN(N, I1, RT).
