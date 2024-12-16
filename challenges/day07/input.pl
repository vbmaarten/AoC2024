read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

%equation(test_value, value_list)
parse_equation(Str, equation(TV, VL)) :- split_string(Str, ":", " ", [TVs, VLs]),
   atom_number(TVs, TV),
   split_string(VLs, " ", " ", VLL),
   maplist(atom_number, VLL, VL).

input_base(File, X) :- read_file(File, Str), split_string(Str, "\n", "", LinesN), append(Lines, [""], LinesN), maplist(parse_equation, Lines, X). 
input_test(X) :- input_base("input_test.txt", X).
input(X) :- input_base("input.txt", X).

:- begin_tests(input).
test(parse_line) :- parse_equation("190: 10 19", equation(190, [10, 19])).
:- end_tests(input).
