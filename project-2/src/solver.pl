solveBoard(Board, S, Result):-
	getBoardSize(Board, N),
	ResultLength #= N * S,
	write('result length: '), write(ResultLength), nl,

	length(Result, ResultLength),
	length(ResultRegions, ResultLength),

	domain(Result, 1, N),
	domain(ResultRegions, 1, N),

	validateNumOfOccurrencesForEachElem(Result, S, N),
	write('test 1: passed'), nl,

	fetchResultRegions(Board, Result, N, S, ResultRegions),
	write('test 2: passed'), nl,
	validateNumOfOccurrencesForEachElem(ResultRegions, S, N),
	write('test 3: passed'), nl,

	%assertNoAdjacentStars(Result, S, N),

	statistics(walltime, _),
	labeling([], Result),
	statistics(walltime, [_, ElapsedTime | _]),
	format('ElapsedTime: ~3d seconds', ElapsedTime), nl,
	nl.

getBoardSize([Head|_], N):-
	length(Head, N).

assertNoAdjacentStars(Result, S, N):-
	validateRowOfStars(Result, S, N, 2).

validateRowOfStars(_, _, N, Row):-
	Row #= N + 1.
validateRowOfStars(Result, S, N, Row):-
	

	Row1 is Row + 1,
	validateRowOfStars(Result, S, N, Row1).


validateNumOfOccurrencesForEachElem(Elements, NumOfOccurrences, N):-
	validateNumOfOccurrencesForEachElem(Elements, NumOfOccurrences, N, 1).

validateNumOfOccurrencesForEachElem(Result, S, N, N):-
	exactly(N, Result, S).
validateNumOfOccurrencesForEachElem(Result, S, N, I):-
	exactly(I, Result, S),
	I1 is I + 1,
	validateNumOfOccurrencesForEachElem(Result, S, N, I1).

fetchResultRegions(Board, Result, ResRows, ResCols, ResultRegions):-
	fetchResultRegions(Board, Result, ResRows, ResCols, [], 1, ResultRegions).

fetchResultRegions(_, _, ResRows, ResCols, ResultRegions, Pos, ResultRegions):-
	Pos #= ResRows * ResCols + 1.
fetchResultRegions(Board, Result, ResRows, ResCols, ResultRegionsSoFar, Pos, ResultRegions):-
	% calculating row and col of result to access
	Row is (Pos - 1) // ResCols + 1,
	Col is ((Pos - 1) mod ResCols) + 1,

	% get the value of result[Row][Col], which is the column where a star is placed
	getMatrixOfListElemAt(Result, ResRows, ResCols, Row, Col, StarCol),

	% get line Row of the board
	getListElemAt(Board, Row, Line),

	% get the region of that position - board[Row][StarCol]
	element(StarCol, Line, Region),

	% push value to ResultRegionsSoFar
	listPushBack(ResultRegionsSoFar, Region, NewResultRegionsSoFar),

	% fetch next element
	Pos1 is Pos + 1,
	fetchResultRegions(Board, Result, ResRows, ResCols, NewResultRegionsSoFar, Pos1, ResultRegions).
