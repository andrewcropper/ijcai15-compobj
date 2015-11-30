metarule(pab_qac_pcb,[P/2,Q/2],([P,A,B]:-[[Q,A,C]-QPostTest,[P,C,B]-PPostTest]),PS) :-
  member(Q/2,PS),
  QPostTest = obj_gt(A,C),
  PPostTest = obj_gt(C,B).

%% metarule(pab_qab,[P/2,Q/2],([P,A,B]:-[[Q,A,B]-true]),PS) :-
%%   member(Q/2,PS).

metarule(pab_qac_rcb,[P/2,Q/2,R/2],([P,X,Y]:-[[Q,X,Z]-true,[R,Z,Y]-true]),PS) :-
  member(Q/2,PS),
  member(R/2,PS).




sum_intervals([],Acc,Acc).
sum_intervals([X-Y|T],Acc1,Total):-
  integer(X),
  integer(Y),
  Dif is Y-X,
  Acc2 is Acc1 + Dif,
  sum_intervals(T,Acc2,Total).

obj_gt(A,B):-
  world_check(intervals(Xs),A),
  world_check(intervals(Zs),B),
  sum_intervals(Xs,0,SumXs),
  sum_intervals(Zs,0,SumZs),
  SumXs > SumZs,!, true.


obj_gt(A,B):-
  world_check(robot_pos(APos),A),
  world_check(robot_pos(BPos),B),
  APos < BPos, !, true.