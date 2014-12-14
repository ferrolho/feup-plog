%===============================%
%= @@ board printing functions =%
%===============================%
printBoard(Board):-
	getBoardSize(Board, N),
	printBoardTopBorder(N),
	printBoard(Board, 1, N),
	nl, !.
printResultBoard(Board, Result, S):-
	getBoardSize(Board, N),
	printBoardTopBorder(N),
	printBoard(Board, 1, N, Result, S),
	nl, !.

printBoardTopBorder(N):-
	N1 is N - 1, createSeparatorN(N1, '______', TopBorder),
	write(' '), printList(TopBorder), write('_____'), nl.

printBoard(Board, N, N):-
	printBoardRow(Board, N, N).
printBoard(Board, I, N):-
	printBoardRow(Board, I, N), !,
	I1 is I + 1,
	printBoard(Board, I1, N).
%-%-%-%-%-%-%
printBoard(Board, N, N, Result, S):-
	printBoardRow(Board, N, N, Result, S).
printBoard(Board, I, N, Result, S):-
	printBoardRow(Board, I, N, Result, S), !,
	I1 is I + 1,
	printBoard(Board, I1, N, Result, S).

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

printBoardRow(Board, N, N):-
	write('|'), printBoardRowTop(Board, N, N, 1), nl, !,
	write('|'), printBoardRowMiddle(Board, N, N, 1), nl, !,
	write('|'), printBoardLastRowBottom(Board, N, N, 1), nl, !.
printBoardRow(Board, I, N):-
	write('|'), printBoardRowTop(Board, I, N, 1), nl, !,
	write('|'), printBoardRowMiddle(Board, I, N, 1), nl, !,
	write('|'), printBoardRowBottom(Board, I, N, 1), nl, !.
%-%-%-%-%-%-%
printBoardRow(Board, N, N, Result, S):-
	write('|'), printBoardRowTop(Board, N, N, 1), nl, !,
	write('|'), printBoardRowMiddle(Board, N, N, 1, Result, S), nl, !,
	write('|'), printBoardLastRowBottom(Board, N, N, 1), nl, !.
printBoardRow(Board, I, N, Result, S):-
	write('|'), printBoardRowTop(Board, I, N, 1), nl, !,
	write('|'), printBoardRowMiddle(Board, I, N, 1, Result, S), nl, !,
	write('|'), printBoardRowBottom(Board, I, N, 1), nl, !.

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

printBoardRowTop(_, _, N, N):-
	write('     |').
printBoardRowTop(Board, I, N, Col):-
	getListElemAt(Board, I, Row),
	Col1 is Col + 1,
	element(Col, Row, V1),
	element(Col1, Row, V2),
	printCellTop(V1, V2),
	printBoardRowTop(Board, I, N, Col1).

% @@@ swap comment to toggle region display
%printBoardRowMiddle(Board, I, N, N):-
%	getListElemAt(Board, I, Row),
%	element(N, Row, V1),
%	write('  '), write(V1), write('  |').
printBoardRowMiddle(_, _, N, N):-
	write('     |').
printBoardRowMiddle(Board, I, N, Col):-
	getListElemAt(Board, I, Row),
	Col1 is Col + 1,
	element(Col, Row, V1),
	element(Col1, Row, V2),
	printValue(V1, V2),
	printBoardRowMiddle(Board, I, N, Col1).
%-%-%-%-%-%-%
printBoardRowMiddle(_, I, N, N, Result, S):-
	starExistsIn(Result, S, I, N),
	write('  *  |').
printBoardRowMiddle(_, _, N, N, _, _):-
	write('     |').
printBoardRowMiddle(Board, I, N, Col, Result, S):-
	starExistsIn(Result, S, I, Col),

	getListElemAt(Board, I, Row),
	Col1 is Col + 1,
	element(Col, Row, V1),
	element(Col1, Row, V2),
	printStar(V1, V2),
	printBoardRowMiddle(Board, I, N, Col1, Result, S).
printBoardRowMiddle(Board, I, N, Col, Result, S):-
	getListElemAt(Board, I, Row),
	Col1 is Col + 1,
	element(Col, Row, V1),
	element(Col1, Row, V2),
	printValue(V1, V2),
	printBoardRowMiddle(Board, I, N, Col1, Result, S).

printBoardRowBottom(Board, I, N, N):-
	getListElemAt(Board, I, Row),
	I1 is I + 1, getListElemAt(Board, I1, NextRow),

	element(N, Row, V1),
	element(N, NextRow, V3),

	printCellBottom(V1, V3).
printBoardRowBottom(Board, I, N, Col):-
	getListElemAt(Board, I, Row),
	I1 is I + 1, getListElemAt(Board, I1, NextRow),
	NextCol is Col + 1,

	element(Col, Row, V1),
	element(NextCol, Row, V2),
	element(Col, NextRow, V3),

	printCellBottom(V1, V2, V3),
	printBoardRowBottom(Board, I, N, NextCol).

printBoardLastRowBottom(_, _, N, N):-
	write('_____|').
printBoardLastRowBottom(Board, I, N, Col):-
	getListElemAt(Board, I, Row),
	NextCol is Col + 1,

	element(Col, Row, V1),
	element(NextCol, Row, V2),

	printLastRowCellBottom(V1, V2),
	printBoardLastRowBottom(Board, I, N, NextCol).

%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

printCellTop(V1, V1):-
	write('     .').
printCellTop(_, _):-
	write('     |').

% @@@ swap comment to toggle region display
%printValue(V, V):-
%	write('  '), write(V), write('  .').
printValue(V, V):-
	write('     .').

% @@@ swap comment to toggle region display
%printValue(V, _):-
%	write('  '), write(V), write('  |').
printValue(_, _):-
	write('     |').

printStar(V, V):-
	write('  *  .').
printStar(_, _):-
	write('  *  |').

printCellBottom(V, V, V):-
	write(' . . .').
printCellBottom(V, V, _):-
	write('_____.').
printCellBottom(V, _, V):-
	write(' . . |').
printCellBottom(_, _, _):-
	write('_____|').

printCellBottom(V, V):-
	write(' . . |').
printCellBottom(_, _):-
	write('_____|').

printLastRowCellBottom(V, V):-
	write('______').
printLastRowCellBottom(_, _):-
	write('_____|').


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

starExistsIn(Result, S, Row, StarCol):-
	StartPos is (Row - 1) * S + 1,
	EndPos is StartPos + S,
	starExistsSomewhereBetween(Result, StartPos, EndPos, StarCol).

starExistsSomewhereBetween(Result, CurrentPos, _, StarCol):-
	element(CurrentPos, Result, ScanRes),
	StarCol =:= ScanRes.
starExistsSomewhereBetween(Result, CurrentPos, EndPos, StarCol):-
	NextPos is CurrentPos + 1,
	NextPos < EndPos,
	starExistsSomewhereBetween(Result, NextPos, EndPos, StarCol).


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
