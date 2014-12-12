%================================%
%= @@ result printing functions =%
%================================%
printResult(Result, N, S):-
	write('Result:'), nl,
	printResultRow(Result, N, S, 1).


printResultRow(Result, N, S, N):-
	write('\t'), printResultRowValues(Result, N, S, N, 1).

printResultRow(Result, N, S, Row):-
	write('\t'), printResultRowValues(Result, N, S, Row, 1),

	Row1 is Row + 1,
	printResultRow(Result, N, S, Row1).


printResultRowValues(Result, _, S, Row, S):-
	Pos is (Row - 1) * S + S,
	getListElemAt(Result, Pos, Elem),
	write(Elem), nl.

printResultRowValues(Result, N, S, Row, Column):-
	Pos is (Row - 1) * S + Column,
	getListElemAt(Result, Pos, Elem),
	write(Elem), write(', '),

	Column1 is Column + 1,
	printResultRowValues(Result, N, S, Row, Column1).


%===============================%
%= @@ board printing functions =%
%===============================%
printBoard([Line | Tail]):-
	printBoardRow(Line),
	printRemainingBoard(Tail),
	nl, !.

printRemainingBoard([]).
printRemainingBoard([Line | Tail]):-
	printBoardRow(Line),
	printRemainingBoard(Tail).

printBoardRow([], []).
printBoardRow(Line):-
	printBoardRowValues(Line), nl.

printBoardRowValues([]).
printBoardRowValues([Head | Tail]):-
	write(Head), write(' '),
	printBoardRowValues(Tail).

createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).
