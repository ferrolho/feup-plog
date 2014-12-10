%=============================================%
%=           ..:: STAR BATTLE ::..           =%
%=                                           =%
%=   Type 'starBattle.' to start the game    =%
%=                                           =%
%=============================================%
%=                                           =%
%=             ..:: Authors ::..             =%
%=                                           =%
%=     Henrique Ferrolho && Joao Pereira     =%
%=                FEUP - 2014                =%
%=                                           =%
%=============================================%

%===============%
%= @@ includes =%
%===============%
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(system)).

%====================%
%= @@ game launcher =%
%====================%
starBattle:-
	clearConsole,
	write('==============='), nl,
	write('= Star Battle ='), nl,
	write('==============='), nl,
	testBoard5x5(Board),
	printBoard(Board),
	solveBoard(Board, Answer),
	printAnswer(Answer), nl.

solveBoard([Head|Tail], Answer):-
	length(Head, N),

	length(Answer, N),
	domain(Answer, 1, N),

	all_different(Answer),

	getAnswerValues([Head|Tail], Answer, AnswerValues),
	all_different(AnswerValues),

	labeling([], Answer).

getAnswerValues(Board, Answer, AnswerValues):-
	getAnswerValues(Board, Answer, [], 1, AnswerValues).

getAnswerValues(_, Answer, AnswerValues, N, AnswerValues):-
	length(Answer, AnswerLength),
	AnswerLength =:= N.
getAnswerValues(Board, Answer, AnswerValuesSoFar, N, AnswerValues):-
	% get col of answer value
	element(N, Answer, Col),

	% get value at row N-1, and column Col
	Row is N - 1,
	getListElemAt(Board, Row, Line),
	element(Col, Line, Value),

	write('N: '), write(N), nl,
	(
		(
			N #<=> 1,
			write('teste1'), nl
		); (
			write('teste2: last elem id='), write(Row), nl,
			element(Row, AnswerValuesSoFar, LastPlaced),
			Dist #= abs(Value - LastPlaced),
			Dist #>= 2
		)
	),

	% push value to AnswerValuesSoFar
	listPushBack(AnswerValuesSoFar, Value, NewAnswerValuesSoFar),
	write('values so far -> '), printList(NewAnswerValuesSoFar), nl,

	% move to next element
	N1 is N + 1,
	getAnswerValues(Board, Answer, NewAnswerValuesSoFar, N1, AnswerValues).



printAnswer(Answer):-
	write('Answer: '),
	printList(Answer).
printList([]).
printList([Head|Tail]):-
	write(Head), printList(Tail).

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
	write(Head),
	printBoardRowValues(Tail).

createSeparatorN(0, _, []).
createSeparatorN(N, SS, [SS | Ls]):-
	N1 is N-1,
	createSeparatorN(N1, SS, Ls).

%==================%
%= @@ test boards =%
%==================%
% expected answer: 2413
testBoard4x4([
	[a, b, a, a],
	[a, a, a, c],
	[d, a, a, a],
	[a, a, a, a]]).

% expected answer: 14253
testBoard5x5([
	[1, 1, 2, 2, 2],
	[1, 2, 2, 3, 2],
	[1, 2, 2, 2, 2],
	[4, 2, 4, 2, 5],
	[4, 4, 4, 5, 5]]).

%================%
%= @@ utilities =%
%================%
clearConsole:-
	clearConsole(40), !.
clearConsole(0).
clearConsole(N):-
	nl,
	N1 is N-1,
	clearConsole(N1).

%=================%
%= @@ containers =%
%=================%
%%% 1. matrix; 2. element row; 3. element column; 4. query element.
getMatrixElemAt([ListAtTheHead|_], 0, ElemCol, Elem):-
	getListElemAt(ListAtTheHead, ElemCol, Elem).
getMatrixElemAt([_|RemainingLists], ElemRow, ElemCol, Elem):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	getMatrixElemAt(RemainingLists, ElemRow1, ElemCol, Elem).

%%% 1. list; 2. element position; 3. query element.
getListElemAt([ElemAtTheHead|_], 0, ElemAtTheHead).
getListElemAt([_|RemainingElems], Pos, Elem):-
	Pos > 0,
	Pos1 is Pos-1,
	getListElemAt(RemainingElems, Pos1, Elem).

listPushBack([], Elem, [Elem]).
listPushBack([Head|Tail], Elem, [Head|NewTail]):-
	listPushBack(Tail, Elem, NewTail).
