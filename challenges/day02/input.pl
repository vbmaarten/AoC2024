file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).
    
lines(Lines) :- file_lines("./input.txt", Lines).
report_line(Line, Report) :- split_string(Line, " ", "", StringReport), to_number(StringReport, Report).
reports([""|[]], []).
reports([H|T], [RH|S]) :- report_line(H, RH), reports(T, S).
reports([],[]).
to_number([H|T], [HN|TN]) :- number_string(HN, H), to_number(T, TN).
to_number([], []).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

input(X) :- lines(Lines), reports(Lines, X). 
