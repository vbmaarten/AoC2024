read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

rule(Str,[Number,IllegalSuccessor]) :- split_string(Str, "|", "", [ISs, Ns]),
   number_codes(Number, Ns),
   number_codes(IllegalSuccessor, ISs).

update(Str, Update) :- split_string(Str, ",", "", UpdateStr), maplist(number_codes, Update, UpdateStr). 

merge_dict(ND, D, N, Dict) :- rules{}.put(N, _) :< D, [IS] = ND.N, Dict = D.put(N, [IS|D.N]).
merge_dict(ND, D, N, Dict) :- [IS] = ND.N,Dict = D.put(N, [IS]).
rule_dict([], rules{}).
rule_dict([[N, IS]|RulesT], Dict) :- rule_dict(RulesT, Dn),
   NRule = rules{}.put(N,[IS]),
   merge_dict(NRule, Dn, N, Dict).

input_base(File,Rules,Updates) :- read_file(File, X),
   parts(X, RuleStr, UpdateStr),
   split_string(RuleStr, "\n", "", RuleLines),
   split_string(UpdateStr, "\n", "", UpdateLines),
   maplist(rule, RuleLines, RuleEntries),
   maplist(update, UpdateLines, Updates),
   rule_dict(RuleEntries, Rules).

input_test(Rules,Updates) :- input_base("input_test.txt", Rules, Updates).
input(Rules,Updates) :- input_base("input.txt", Rules, Updates).

parts(Str, RuleStr, UpdateStr) :- sub_string(Str, B, L, A, "\n\n"),
   sub_string(Str, 0, B, _, RuleStr),
   BN is B + L ,
   AN is A - 1,
   sub_string(Str, BN, AN, _, UpdateStr).

:- begin_tests(input).

test(rule) :- rule("10|20", [20, 10]).
test(merge_dict) :- merge_dict(rules{20:[30]}, rules{20:[21,22,23]}, 20, rules{20:[30,21,22,23]}).
test(rule_dict, all(Result = rules{20:[30,21], 30:[40]})) :- rule_dict([[20,30], [30,40], [20,21]], Result).

:- end_tests(input).
