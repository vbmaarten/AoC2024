read_file(File, Str) :-
    setup_call_cleanup(open(File, read, In),
       read_string(In, _, Str), 
       close(In)).

robotize([[PX, PY], [VX, VY]], robot(point(PX, PY), velocity(VX,VY))).

parse_line(Str, G) :- split_string(Str, " ", " ", Values),
   maplist([V, N]>>split_string(V, "=", "", N), Values, R),
   maplist([N, Z]>>nth0(1, N, Z), R, U),
   maplist([P, X]>>split_string(P, ",", " ", X), U, Y),
   maplist([D,E] >> maplist(atom_number, D, E), Y, A),
   robotize(A, G).

input_base(File, X) :- read_file(File, Str),
   split_string(Str, "\n", "", LinesN),
   append(Lines, [""], LinesN),
   maplist(parse_line, Lines, X). 

input_test(X) :- input_base("input_test.txt", X).
input(X) :- input_base("input.txt", X).

:- begin_tests(input).
test(parse_line) :- parse_line("p=0,4 v=3,-3", robot(point(0,4), velocity(3,-3))).
:- end_tests(input).
