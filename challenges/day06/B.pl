#!swipl -q
:- [input].
:- initialization input(X), time(solution(X,C)), writeln(C).
solution(X, C) :- start(X,P), path(X, Path, P, up, []), include(rotated_loop(X), Path, Result), length(Result, C).

%same_next(point(Ax,Ay,Ad), point(Bx,By,Bd)) :- point_in_line(point(Ax,Ay,Ad), Ad, An), point_in_line(point(Bx,By,Bd), Bd, Bn), An=Bn.

start_line(L, I) :- nth0(I, L, ^).
start([Lh|_],point(X, 0, up)) :- start_line(Lh, X).
start([_|Lt],point(X, Y, up)) :- start(Lt, point(X, Yn, up)), Y is Yn + 1.

char_at(L, point(X,Y,_), C) :- nth0(Y, L, Row), nth0(X, Row, C).

point_in_line(point(X,Y,_), up, P) :- Yn is Y-1, P = point(X, Yn, up).
point_in_line(point(X,Y,_), down, P) :- Yn is Y+1, P = point(X, Yn, down).
point_in_line(point(X,Y,_), left, P) :- Xn is X-1, P = point(Xn, Y, left).
point_in_line(point(X,Y,_), right, P) :- Xn is X+1, P = point(Xn, Y, right).

rotate(up, right).
rotate(right, down).
rotate(down, left).
rotate(left, up).

point_exists([H|T], point(X,Y,_)) :- length([H|T], MaxY), length(H, MaxX), X < MaxX, Y < MaxY, X >= 0, Y >= 0.
next_point(L, CurP, D, P, D) :- point_in_line(CurP, D, P), point_exists(L, P), not(char_at(L, P, #)).
next_point(L, CurP, D, P, Dn) :- point_in_line(CurP, D, Pl), point_exists(L, Pl), char_at(L, Pl, #), rotate(D, Dn), next_point(L, CurP, Dn, P, Dn).


replace([], _, _, _) :- fail.
replace([_|T], 0, Z, [Z|T]).
replace([H|T], I, Z, [H|Tn]) :- In is I-1, replace(T, In, Z, Tn).

path(List, [Point|NPoints], Point, D, Pv) :- next_point(List, Point, D, Pn, Dn), not(nth0(_, Pv, Pn)), path(List, NPoints, Pn, Dn, [Pn|Pv]).
path(L, [], P, D, _) :- not(next_point(L, P, D, _, _)).

list_block(L, point(Plx, Ply, _), Ln) :- 
  nth0(Ply, L, Row),
  replace(Row, Plx, #, Rown),
  replace(L, Ply, Rown, Ln).

rotated_loop(List, point(X,Y,D)) :- 
  point_in_line(point(X,Y,D), D, Pl),
  point_exists(List, Pl),
  not(char_at(List, Pl, #)),
  rotate(D, Dr),
  point_in_line(point(X,Y,D), Dr, Pn),
  point_exists(List, Pn),
  list_block(List, Pl, Ln),
  not(path(Ln, _, point(X,Y,D), D, [])).

reverse([], []).
reverse([H|T],R) :- reverse(T, Rn), append(Rn, [H], R).



:- begin_tests(a).
test(start_line_success) :- start_line([x,x,^,x,x], 2).
test(start) :- start([[x,x,x], [x,^,x], [x,x,x]], point(1,1,up)).
test(point_in_line_up) :- point_in_line(point(1,1,up), up, point(1,0,up)).
test(point_in_line_down) :- point_in_line(point(1,1,up), down, point(1,2, down)).
test(point_in_line_left) :- point_in_line(point(1,1,up), left, point(0,1, left)).
test(point_in_line_right) :- point_in_line(point(1,1,up), right, point(2,1, right)).
test(next_point) :- next_point([[.,.,.], [.,^,.], [.,.,.]], point(1,1,up), up, point(1,0,up), up).
test(next_point) :- next_point([[.,#,.], [.,^,.], [.,.,.]], point(1,1,up), up, point(2,1,right), right).
test(path) :- path([[.,#,.], [.,^,.], [.,.,.]], [point(1,1,up), point(2,1,right)], point(1,1,up), up, []).
test(exit_path_up) :- path([['.']], [point(0,0,up)], point(0,0,up), up, []).
test(exit_path_down) :- path([['.']], [point(0,0,up)], point(0,0,up), down, []).
test(exit_path_left) :- path([['.']], [point(0,0,up)], point(0,0,up), left, []).
test(exit_path_right) :- path([['.']], [point(0,0,up)], point(0,0,up), right, []).
test(list_block) :- list_block([[a,a,a], [a,a,a], [a,a,a]], point(1,1,up), [[a,a,a], [a,#,a], [a,a,a]]).
test(start_line_fail, [error(_)]) :- not(start_line([x,x,x,x,x]), _).
:- end_tests(a).
