#!swipl -q
:- [input].
:- initialization input(X), solution(X, S), writeln(S), halt(0).

valid_equation(equation(A,[A])).
valid_equation(equation(TV, [A,B|VLR])) :- C is A*B, C =< TV, valid_equation(equation(TV, [C|VLR])).
valid_equation(equation(TV, [A,B|VLR])) :- C is A+B,C =< TV,  valid_equation(equation(TV, [C|VLR])).
valid_equation(equation(TV, [A,B|VLR])) :- atom_concat(A,B,Cx), atom_number(Cx, C), C =< TV,  valid_equation(equation(TV, [C|VLR])).
sum_equation(equation(A, _), B ,C) :- C is A+B.

solution(X, S) :- include(valid_equation, X, R), foldl(sum_equation, R, 0, S). 
