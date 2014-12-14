%=============================================%
%=           ..:: STAR BATTLE ::..           =%
%=                                           =%
%=        Type 'starBattle.' to start        =%
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
:- include('containers.pl').
:- include('printer.pl').
:- include('solver.pl').
:- include('starBattleTestBoards.pl').
:- include('utilities.pl').

%====================%
%= @@ game launcher =%
%====================%
starBattle:-
	clearConsole,
	write('To run the program type:'), nl,
	nl,
	write('\tstarBattle(NumBoard, NumStars).'),nl,
	nl,
	write('- NumBoard'), nl,
	write('number of the board you wish to test.'), nl,
	nl,
	write('- NumStars'), nl,
	write('number of stars you wish to place on each row, column and region.'), nl,
	nl.

starBattle(BoardNumber, NumStars):-
	clearConsole,
	write('==============='), nl,
	write('= Star Battle ='), nl,
	write('==============='), nl,
	nl,
	format('Trying to place ~d stars on board no. ~d:', [NumStars, BoardNumber]), nl,

	getBoard(BoardNumber, Board),
	printBoard(Board), !,

	solveBoard(Board, NumStars, Result), !,
	pressEnterToContinue,

	%getBoardSize(Board, BoardSize),
	%printResult(Result, BoardSize, NumStars),
	printResultBoard(Board, Result, NumStars), !.
