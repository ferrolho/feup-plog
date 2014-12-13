solveBoard(Board, S, Result):-
	getBoardSize(Board, N),
	S #=< (N - 1) // 2 + 1,

	ResultLength #= N * S,

	length(Result, ResultLength),
	length(ResultRegions, ResultLength),

	domain(Result, 1, N),
	domain(ResultRegions, 1, N),

	% 1st restriction
	validateNumOfOccurrencesForEachElem(Result, S, N),

	% 2nd restriction
	fetchResultRegions(Board, Result, N, S, ResultRegions),
	validateNumOfOccurrencesForEachElem(ResultRegions, S, N),

	% 3rd restriction
	noAdjacentStars(Result, S, N),

	statistics(walltime, _),
	labeling([], Result),
	statistics(walltime, [_, ElapsedTime | _]),
	format('ElapsedTime: ~3d seconds', ElapsedTime), nl,
	nl.


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

getBoardSize([Head|_], N):-
	length(Head, N).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

noAdjacentStars(Result, S, N):-
	noAdjacentStars(Result, S, N, 1).

noAdjacentStars(Result, S, N, 1):-
	noAdjacentStarsOnRow(Result, S, 1),
	noAdjacentStars(Result, S, N, 2).
noAdjacentStars(_, _, N, Row):-
	Row #= N + 1.
noAdjacentStars(Result, S, N, Row):-
	Row #> 1,
	noAdjacentStarsOnRow(Result, S, Row),
	noAdjacentStarsWithPreviousRow(Result, S, Row),
	Row1 #= Row + 1,
	noAdjacentStars(Result, S, N, Row1).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

noAdjacentStarsOnRow(Result, S, Row):-
	StartPos #= (Row - 1) * S + 1,
	EndPos #= StartPos + S,
	validateStarsFromStartToEnd(Result, StartPos, EndPos).

validateStarsFromStartToEnd(Result, Start, End):-
	Next #= Start + 1,
	validateStarsFromStartToEnd(Result, Start, Next, End).

validateStarsFromStartToEnd(_, Start, _, End):-
	Start #= End - 1.
validateStarsFromStartToEnd(Result, Start, End, End):-
	Start1 #= Start + 1,
	Next #= Start1 + 1,
	validateStarsFromStartToEnd(Result, Start1, Next, End).
validateStarsFromStartToEnd(Result, Start, Next, End):-
	validateHorizontalDistanceBetweenStars(Result, Start, Next),
	Next1 #= Next + 1,
	validateStarsFromStartToEnd(Result, Start, Next1, End).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

noAdjacentStarsWithPreviousRow(Result, S, Row):-
	StartPos #= (Row - 1) * S + 1,
	EndPos #= StartPos + S,
	noAdjacentStarsWithPreviousRow(Result, S, Row, StartPos, EndPos).

noAdjacentStarsWithPreviousRow(_, _, _, EndPos, EndPos).
noAdjacentStarsWithPreviousRow(Result, S, Row, CurrentPos, EndPos):-
	% for each star of the row being validated,
	% validate horizontal distance to each star of the previous row
	PrevRow #= Row - 1,
	starIsNotAdjacentWithAnyOfThePreviousRow(Result, S, CurrentPos, PrevRow),
	% procceed to next row
	CurrentPos1 #= CurrentPos + 1,
	noAdjacentStarsWithPreviousRow(Result, S, Row, CurrentPos1, EndPos).

starIsNotAdjacentWithAnyOfThePreviousRow(Result, S, PivotStar, PrevRow):-
	FirstStarPos #= (PrevRow - 1) * S + 1,
	LastStarPos #= FirstStarPos + S,
	starIsNotAdjacentToAnyOtherStarFromFirstToLastPos(Result, PivotStar, FirstStarPos, LastStarPos).

starIsNotAdjacentToAnyOtherStarFromFirstToLastPos(_, _, LastStarPos, LastStarPos).
starIsNotAdjacentToAnyOtherStarFromFirstToLastPos(Result, PivotStar, CurrentStarPos, LastStarPos):-
	validateHorizontalDistanceBetweenStars(Result, PivotStar, CurrentStarPos),
	NextStarPos #= CurrentStarPos + 1,
	starIsNotAdjacentToAnyOtherStarFromFirstToLastPos(Result, PivotStar, NextStarPos, LastStarPos).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

validateHorizontalDistanceBetweenStars(Result, Pos1, Pos2):-
	element(Pos1, Result, Col1),
	element(Pos2, Result, Col2),
	Dist #= abs(Col2 - Col1),
	Dist #> 1.


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

validateNumOfOccurrencesForEachElem(Elements, NumOfOccurrences, N):-
	validateNumOfOccurrencesForEachElem(Elements, NumOfOccurrences, N, 1).

validateNumOfOccurrencesForEachElem(Result, S, N, N):-
	exactly(N, Result, S).
validateNumOfOccurrencesForEachElem(Result, S, N, I):-
	exactly(I, Result, S),
	I1 #= I + 1,
	validateNumOfOccurrencesForEachElem(Result, S, N, I1).


%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%-%

fetchResultRegions(Board, Result, ResRows, ResCols, ResultRegions):-
	fetchResultRegions(Board, Result, ResRows, ResCols, [], 1, ResultRegions).

fetchResultRegions(_, _, ResRows, ResCols, ResultRegions, Pos, ResultRegions):-
	Pos #= ResRows * ResCols + 1.
fetchResultRegions(Board, Result, ResRows, ResCols, ResultRegionsSoFar, Pos, ResultRegions):-
	% calculating row and col of result to access
	Row #= (Pos - 1) // ResCols + 1,
	Col #= ((Pos - 1) mod ResCols) + 1,

	% get the value of result[Row][Col], which is the column where a star is placed
	getMatrixOfListElemAt(Result, ResRows, ResCols, Row, Col, StarCol),

	% get line Row of the board
	getListElemAt(Board, Row, Line),

	% get the region of that position - board[Row][StarCol]
	element(StarCol, Line, Region),

	% push value to ResultRegionsSoFar
	listPushBack(ResultRegionsSoFar, Region, NewResultRegionsSoFar),

	% fetch next element
	Pos1 #= Pos + 1,
	fetchResultRegions(Board, Result, ResRows, ResCols, NewResultRegionsSoFar, Pos1, ResultRegions).
