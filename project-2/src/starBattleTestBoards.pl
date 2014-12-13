%=======================================%
%= @@ function to retrieve test boards =%
%=======================================%
getBoard(N, Board):-
	(
		N =:= 1 -> testBoard4x4(Board);
		N =:= 2 -> testBoard5x5(Board);
		N =:= 3 -> testBoard8x8(Board);

		nl,
		write('Error: the specified board does not exist.'),
		fail
	).

%==================%
%= @@ test boards =%
%==================%
% expected answer:2413
testBoard4x4([
	[1, 2, 1, 1],
	[1, 1, 1, 3],
	[4, 1, 1, 1],
	[1, 1, 1, 1]]).

% expected answer: 14253
testBoard5x5([
	[1, 1, 2, 2, 2],
	[1, 2, 2, 3, 2],
	[1, 2, 2, 2, 2],
	[4, 2, 4, 2, 5],
	[4, 4, 4, 5, 5]]).

% expected answer: 2468246813571357
testBoard8x8([
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8],
	[1, 2, 3, 4, 5, 6, 7, 8]]).
