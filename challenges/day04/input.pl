read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

split(A,B,C,D) :- split_string(B,C,A,D).

input_test(X) :- read_file("./input_test.txt", Y), split_string(Y, "\n", "", Lines), maplist(atom_chars, Lines, Xn), subtract(Xn, [[]], X).
input(X) :- read_file("./input.txt", Y), split_string(Y, "\n", "", Lines), maplist(atom_chars, Lines, Xn), subtract(Xn, [[]], X).
