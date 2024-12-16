#!swipl -q

:- [input].
:- initialization input(X), time(solution(X, C)), writeln(C), halt(0).

xy_element(X, Y, L, E) :- nth0(Y, L, Row), nth0(X, Row, E).

hasMasF(L, [X, Y]) :- Dx1 is X + 1, Dy1 is Y - 1,Dx2 is X - 1, Dy2 is Y + 1, xy_element(Dx1, Dy1, L, 'M'), xy_element(X,Y,L,'A'),xy_element(Dx2, Dy2, L, 'S').
hasMasF(L, [X, Y]) :- Dx1 is X + 1, Dy1 is Y - 1,Dx2 is X - 1, Dy2 is Y + 1, xy_element(Dx1, Dy1, L, 'S'), xy_element(X,Y,L,'A'),xy_element(Dx2, Dy2, L, 'M').
hasMasB(L, [X, Y]) :- Dx1 is X - 1, Dy1 is Y - 1,Dx2 is X + 1, Dy2 is Y + 1, xy_element(Dx1, Dy1, L, 'M'), xy_element(X,Y,L,'A'),xy_element(Dx2, Dy2, L, 'S').
hasMasB(L, [X, Y]) :- Dx1 is X - 1, Dy1 is Y - 1,Dx2 is X + 1, Dy2 is Y + 1, xy_element(Dx1, Dy1, L, 'S'), xy_element(X,Y,L,'A'),xy_element(Dx2, Dy2, L, 'M').
hasXMas(L, [X,Y]) :- hasMasF(L, [X,Y]), hasMasB(L, [X,Y]).

positionY(X, 0, [[X, 0]]).
positionY(X, Y, [[X,Y] | Pt] ) :- Yn is Y-1, positionY(X, Yn, Pt).
positions(0, Y, P) :- positionY(0, Y, P).
positions(X, Y, P) :- positionY(X, Y, PY), Xn is X-1, positions(Xn, Y, PX), append(PY, PX, P).

solution([Xh|Xt], C) :- length([Xh|Xt], MaxY), length(Xh, MaxX), positions(MaxX, MaxY, P), include(hasXMas([Xh|Xt]), P, R), length(R, C).

