#!swipl -q
:-initialization [input], input(X), amount_safe(X, N), writeln(N), halt(0).

remove_last([_], []).
remove_last([H|T], [H|R]) :- remove_last(T, R). 

safe(L) :- safe_increasing(L, F), F < 2.
safe([_|T]) :- safe_increasing(T, F), F < 1.
safe(L) :- remove_last(L, R), safe_increasing(R, F), F < 1.

safe(L) :- safe_decreasing(L, F), F < 2.
safe([_|T]) :- safe_decreasing(T, F), F < 1.
safe(L) :- remove_last(L, R), safe_decreasing(R, F), F < 1.

safe_increasing([A,B|T], F) :- B > A, S is B-A, S < 4, safe_increasing([B|T], F). 
safe_increasing([A,_|T], F) :- safe_increasing([A|T], F1), F is F1+1, F < 2. 
safe_increasing([_|[]], 0).
safe_increasing([], 0).

safe_decreasing([A,B|T], F) :- B < A, S is A-B, S < 4, safe_decreasing([B|T], F). 
safe_decreasing([A,_|T], F) :- safe_decreasing([A|T], F1), F is F1+1, F < 2. 
safe_decreasing([_|[]], 0).
safe_decreasing([], 0).

amount_safe([H|T], N) :- safe(H), amount_safe(T, N1), N is 1+N1.
amount_safe([H|T], N) :- not(safe(H)), amount_safe(T, N).
amount_safe([], 0).
