%===============================%
%= @@ board printing functions =%
%===============================%
printBoard([Line | Tail]):-
	length(Line, N),
	printBoardTopBorder(N),
	printBoardRow(Line),
	printRemainingBoard(Tail),
	nl, !.

printBoardTopBorder(N):-
	N1 is N - 1, createSeparatorN(N1, '______', TopBorder),
	write(' '), printList(TopBorder), write('_____'), nl.

printRemainingBoard([]).
printRemainingBoard([Last]):-
	printLastBoardRow(Last).
printRemainingBoard([Line | Tail]):-
	printBoardRow(Line),
	printRemainingBoard(Tail).

printBoardRow(Line):-
	write('|'), printBoardRowTop(Line), nl,
	write('|'), printBoardRowValues(Line), nl,
	write('|'), printBoardRowBottom(Line), nl.
printLastBoardRow(Line):-
	write('|'), printBoardRowTop(Line), nl,
	write('|'), printBoardRowValues(Line), nl,
	write('|'), printLastBoardRowBottom(Line), nl.

printBoardRowTop([]).
printBoardRowTop([_]):-
	write('     |').
printBoardRowTop([_|Tail]):-
	write('     .'), printBoardRowTop(Tail).

printBoardRowValues([]).
printBoardRowValues([Last]):-
	write('  '), write(Last), write('  |').
printBoardRowValues([Head | Tail]):-
	write('  '), write(Head), write('  .'),
	printBoardRowValues(Tail).

printBoardRowBottom([]).
printBoardRowBottom([_]):-
	write(' . . |').
printBoardRowBottom([_|Tail]):-
	write(' . . .'), printBoardRowBottom(Tail).

printLastBoardRowBottom([]).
printLastBoardRowBottom([_]):-
	write('_____|').
printLastBoardRowBottom([_|Tail]):-
	write('______'), printLastBoardRowBottom(Tail).

createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).

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
