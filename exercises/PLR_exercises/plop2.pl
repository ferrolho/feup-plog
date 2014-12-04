:- use_module(library(clpfd)).

sumDist([X, Y | R], Dist):-
	Dist #= abs(X - Y) + RestDist,
	sumDist([Y | R], RestDist).
sumDist([_], 0).

plop2(N, Perc, Dist):-
	length(Perc, N),
	domain(Perc, 1, N),

	all_different(Perc),
	circuit(Perc),

	sumDist(Perc, Dist),
	labeling([maximize(Dist)], Perc),
	
	write(Perc), nl,
	write(Dist).
