read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

input_base(File, X) :- read_file(File, Str), split_string(Str, "\n", "", Lines), maplist(atom_chars, Lines, X). 
input_test(X) :- input_base("input_test.txt", X).
input(X) :- input_base("input.txt", X).
