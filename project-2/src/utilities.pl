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

pressEnterToContinue:-
	write('Press <Enter> to show the solution.'), nl,
	waitForEnter, !.
waitForEnter:-
	get_char(_).

exactly(_, [], 0).
exactly(X, [Y|L], N) :-
	X #= Y #<=> B,
	N #= M + B,
	exactly(X, L, M).
