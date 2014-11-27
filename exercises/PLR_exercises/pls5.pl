:- use_module(library(clpfd)).

pls5:-
	length(Vars, 12),
	domain(Vars, 0, 3),

	global_cardinality(Vars, [0-4, 1-2, 2-3, 3-3]),

	element(1, Vars, Cor1),
	element(12, Vars, Cor1),

	element(2, Vars, Cor2),
	element(11, Vars, Cor2),

	element(5, Vars, 3),

	trios(Vars),

	quad(Vars, Bools),
	sum(Bools, #=, 1),

	labeling([], Vars),
	write(Vars).

trios([A, B, C | R]):-
	all_different([A, B, C]),
	trios([B, C | R]).
trios([_, _]).

quad([A, B, C, D | R], [Bool | Bools]):-
	(A #= 0 #/\ B#= 1 #/\ C #= 2 #/\ D #= 3) #<=> Bool,
	quad([B, C, D | R], Bools).
quad([_, _, _], []).
