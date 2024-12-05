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

middle(L, E) :- length(L, C), N is floor(C/2), nth0(N, L, E). 

solution(RuleDict, Updates, C) :- include(valid_update([], RuleDict), Updates, Result), maplist(middle, Result, M), foldl(plus, M, 0, C). 
