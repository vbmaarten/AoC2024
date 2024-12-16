#!swipl -q
:- [input].
:- initialization input(X), time(solution(X,V)), writeln(V), halt(0).

even_items([], []).
even_items([_|[]], []).
even_items([_,B|T], [B | R]) :- even_items(T, R). 

multiply(Str, V) :- re_matchsub("mul\\((?<left>\\d+),(?<right>\\d+)\\)",Str,re_match{0:_, left: Lstr, right: Rstr}),
  number_codes(L, Lstr),
  number_codes(R, Rstr),
  V is L*R.

mul_list(Str, L) :- re_split("mul\\([0-9]{1,3},[0-9]{1,3}\\)", Str, Sub), even_items(Sub, L).

concat_all([], "").
concat_all([H|T], S) :- concat_all(T, Tc), string_concat(H, Tc, S).
relevant_sections(Str, S) :- string_concat("do()", Str, DoStr), string_concat(DoStr, "don't()", FStr), re_split("do\\(\\)[\\s\\S]*don't\\(\\)", FStr, Sub, [multiline(true), greedy(false)]), even_items(Sub, L), concat_all(L, S).

resolve_mul_list([],[]).
resolve_mul_list([H|T], [Hr|Tr]) :- multiply(H, Hr), resolve_mul_list(T, Tr).

sum([], 0).
sum([H|T], V) :- sum(T, V1), V is H+V1.

solution(X, V) :- relevant_sections(X, S), mul_list(S,Y), resolve_mul_list(Y, L), sum(L, V).
