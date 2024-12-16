read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

input(X) :- read_file("./input.txt", X). 
input_test(X) :- read_file("./input_test.txt", X). 
