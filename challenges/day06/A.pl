#!swipl -q
:- [input].
:- initialization input(X), time(solution(X,C)), writeln(C), halt(0).

start_line(L, I) :- nth0(I, L, ^).
start([Lh|_],point(X, 0)) :- start_line(Lh, X).
start([_|Lt],point(X, Y)) :- start(Lt, point(X, Yn)), Y is Yn + 1.

char_at(L, point(X,Y), C) :- nth0(Y, L, Row), nth0(X, Row, C).

point_in_line(point(X,Y), up, P) :- Yn is Y-1, P = point(X, Yn).
point_in_line(point(X,Y), down, P) :- Yn is Y+1, P = point(X, Yn).
point_in_line(point(X,Y), left, P) :- Xn is X-1, P = point(Xn, Y).
point_in_line(point(X,Y), right, P) :- Xn is X+1, P = point(Xn, Y).

rotate(up, right).
rotate(right, down).
rotate(down, left).
rotate(left, up).

point_exists([H|T], point(X,Y)) :- length([H|T], MaxY), length(H, MaxX), X < MaxX, Y < MaxY, X >= 0, Y >= 0.
next_point(L, CurP, D, P, D) :- point_in_line(CurP, D, P), point_exists(L, P), not(char_at(L, P, #)).
next_point(L, CurP, D, P, Dn) :- point_in_line(CurP, D, Pl), point_exists(L, Pl), rotate(D, Dn), next_point(L, CurP, Dn, P, Dn).

path(List, [Point|NPoints], Point, D) :- next_point(List, Point, D, Pn, Dn), path(List, NPoints, Pn, Dn).
path(_, [Pn], Pn, _).

solution(X, C) :- start(X,P), path(X, Path, P, up), sort(Path, Ps), length(Ps, C).

:- begin_tests(a).
test(start_line_success) :- start_line([x,x,^,x,x], 2).
test(start) :- start([[x,x,x], [x,^,x], [x,x,x]], point(1,1)).
test(point_in_line_up) :- point_in_line(point(1,1), up, point(1,0)).
test(point_in_line_down) :- point_in_line(point(1,1), down, point(1,2)).
test(point_in_line_left) :- point_in_line(point(1,1), left, point(0,1)).
test(point_in_line_right) :- point_in_line(point(1,1), right, point(2,1)).
test(next_point) :- next_point([[.,.,.], [.,^,.], [.,.,.]], point(1,1), up, point(1,0), up).
test(next_point) :- next_point([[.,#,.], [.,^,.], [.,.,.]], point(1,1), up, point(2,1), right).
test(path) :- path([[.,#,.], [.,^,.], [.,.,.]], [point(1,1), point(2,1)], point(1,1), up).
test(exit_path_up) :- path([['.']], [point(0,0)], point(0,0), up).
test(exit_path_down) :- path([['.']], [point(0,0)], point(0,0), down).
test(exit_path_left) :- path([['.']], [point(0,0)], point(0,0), left).
test(exit_path_right) :- path([['.']], [point(0,0)], point(0,0), right).
test(start_line_fail, [error(_)]) :- not(start_line([x,x,x,x,x]), _).
:- end_tests(a).
