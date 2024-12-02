#!swipl -q
:- initialization [input], input(X), amount_safe(X, N), writeln(N), halt(0).

safe(L) :- safe_increasing(L).
safe(L) :- safe_decreasing(L).

safe_increasing([A,B|T]) :- B > A, S is B-A, S < 4, safe_increasing([B|T]). 
safe_increasing([_|[]]).
safe_increasing([]).

safe_decreasing([A,B|T]) :- B < A, S is A-B, S < 4, safe_decreasing([B|T]). 
safe_decreasing([_|[]]).
safe_decreasing([]).

amount_safe([H|T], N) :- safe(H), amount_safe(T, N1), N is 1+N1.
amount_safe([H|T], N) :- not(safe(H)), amount_safe(T, N).
amount_safe([], 0).
