#!swipl -q

:- [input].
:- initialization input(X), time(solution(X, C)), writeln(C), halt(0).

xy_element(X, Y, L, E) :- nth0(Y, L, Row), nth0(X, Row, E).

word_in_direction([], _, _, _, _, _).
word_in_direction([Wh|Wt], X, Y, L, Dx, Dy) :- xy_element(X, Y, L, Wh), Xn is X+Dx, Yn is Y+Dy, word_in_direction(Wt, Xn, Yn, L, Dx, Dy). 


word_count_top(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, 0, -1).
word_count_top(_,_,_,_,0).
word_count_bottom(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, 0, 1).
word_count_bottom(_,_,_,_,0).
word_count_right(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, 1, 0).
word_count_right(_,_,_,_,0).
word_count_left(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, -1, 0).
word_count_left(_,_,_,_,0).
word_count_top_right(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, 1, -1).
word_count_top_right(_,_,_,_,0).
word_count_top_left(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, -1, -1).
word_count_top_left(_,_,_,_,0).
word_count_bottom_right(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, 1, 1).
word_count_bottom_right(_,_,_,_,0).
word_count_bottom_left(Word, X, Y, L, 1) :- word_in_direction(Word, X, Y, L, -1, 1).
word_count_bottom_left(_,_,_,_,0).

word_count_from_position(Word, X, Y, L, C) :- 
  word_count_top(Word, X, Y, L, C1),
  word_count_bottom(Word, X, Y, L, C2),
  word_count_right(Word, X, Y, L, C3),
  word_count_left(Word, X, Y, L, C4),
  word_count_top_right(Word, X, Y, L, C5),
  word_count_top_left(Word, X, Y, L, C6),
  word_count_bottom_right(Word, X, Y, L, C7),
  word_count_bottom_left(Word, X, Y, L, C8),
  C is C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8.

word_count_from_positions(_, [], _, 0).
word_count_from_positions(Word, [[X,Y]|T], L, C) :- word_count_from_position(Word, X, Y, L, C1), word_count_from_positions(Word, T, L, C2), C is C1 + C2.

positionY(X, 0, [[X, 0]]).
positionY(X, Y, [[X,Y] | Pt] ) :- Yn is Y-1, positionY(X, Yn, Pt).
positions(0, Y, P) :- positionY(0, Y, P).
positions(X, Y, P) :- positionY(X, Y, PY), Xn is X-1, positions(Xn, Y, PX), append(PY, PX, P).

solution([Xh|Xt], C) :- length([Xh|Xt], MaxY), length(Xh, MaxX), positions(MaxX, MaxY, P), word_count_from_positions(['X', 'M', 'A', 'S'], P, [Xh|Xt], C).

