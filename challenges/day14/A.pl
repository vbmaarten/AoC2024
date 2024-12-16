#!swipl -q
:- [input].
:- initialization input(X), solution(X, board(101,103), S), writeln(S), halt(0).

point_in_quadrant( board(W, H),robot(point(X,Y), _), [1, 0, 0, 0]) :- 
  Wh is floor(W/2),
  Hh is floor(H/2),
  X < Wh,
  Y < Hh.

point_in_quadrant( board(W, H),robot(point(X,Y), _), [0, 1, 0, 0]) :- 
  Wh is floor(W/2),
  Hh is floor(H/2) ,
  X > Wh,
  Y < Hh.

point_in_quadrant(board(W, H),robot(point(X,Y), _), [0, 0, 1, 0]) :- 
  Wh is floor(W/2),
  Hh is floor(H/2) ,
  X < Wh,
  Y > Hh.

point_in_quadrant( board(W, H),robot(point(X,Y), _), [0, 0, 0, 1]) :- 
  Wh is floor(W/2),
  Hh is floor(H/2) ,
  X > Wh,
  Y > Hh.

point_in_quadrant(_,_,[0,0,0,0]).

sumq([A1,B1,C1,D1],[A2,B2,C2,D2], [A,B,C,D]) :- A is A1+A2, B is B1+B2, C is C1+C2, D is D1+D2.

step_robot(board(W, H), robot(point(X,Y), velocity(Dx,Dy)), robot(point(Xn, Yn), velocity(Dx,Dy))) :- Xn is (X+Dx) mod W, Yn is (Y+Dy) mod H.
step_list(L, 0, _, L).
step_list(L, C, B, Lf) :- C \= 0, Cn is C-1, maplist(step_robot(B),L,Ln), step_list(Ln,Cn, B,Lf).

times(A,B,C) :- C is A*B.

solution(X,B,C) :- step_list(X, 100, B, Lf),
  maplist(point_in_quadrant(B), Lf, R),
  foldl(sumq, R, [0,0,0,0], T),
  foldl(times,T,1,C).
