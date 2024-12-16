#!swipl -q
:- [input].
:- initialization input(R, U), time(solution(R, U, C)), writeln(C), halt(0).

valid_update(_, _,[]).
valid_update(ExcludedNumbers, RuleDict, [Uh|Ut]) :- 
  not(member(Uh, ExcludedNumbers)),
  rules{}.put(Uh, _) :< RuleDict,
  append(ExcludedNumbers, RuleDict.Uh, EN),
  valid_update(EN, RuleDict, Ut).
valid_update(ExcludedNumbers, RuleDict, [Uh|Ut]) :- 
  not(member(Uh, ExcludedNumbers)),
  not(rules{}.put(Uh, _) :< RuleDict),
  valid_update(ExcludedNumbers, RuleDict, Ut).

invalid_update(E, R, L) :- not(valid_update(E,R,L)).
in_order(D, >, A, B) :- _{}.put(A, _) :< D, member(B, D.A).
in_order(_, <, _, _). 
sort_by_dict(D, L, S) :- predsort(in_order(D), L, S).

middle(L, E) :- length(L, C), N is floor(C/2), nth0(N, L, E). 

solution(RuleDict, Updates, C) :- include(invalid_update([], RuleDict), Updates, Result), maplist(sort_by_dict(RuleDict), Result, Sorted), maplist(middle, Sorted, M), foldl(plus, M, 0, C). 
