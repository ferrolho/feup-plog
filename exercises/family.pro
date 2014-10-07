% how to open files: consult(filePath).
% how to debug: trace.
% how to stop debugging: notrace.

% family kb
man(antonio).
man(henrique).

% man(X). - devolve os homens um a um; para ver o proximo escrever ';'
% se envolvermos uma palavra, ate com espacos, com "'" torna-se um atomo

woman(aldinha).
woman(anaRita).

parents(antonio, aldinha, henrique).
parents(antonio, aldinha, anaRita).

dad(X, Y) :- parents(X, _, Y).
mother(X, Y) :- parents(_, X, Y).

% o '_' representa uma wildcard; o ":-" significa "se"

brother(X, Y) :- parents(F, M, X), parents(F, M, Y), man(X), X \= Y.
sister(X, Y) :- parents(F, M, X), parents(F, M, Y), woman(X), X \= Y.

% "\=" significa diferente.
% "<" compara numeros.
% "@<" compara atomos.
