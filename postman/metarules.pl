metarule(pab_qac_pcb,[P/2,Q/2],([P,A,B]:-[[Q,A,C]-QPostTest,[P,C,B]-PPostTest]),PS) :-
  member(Q/2,PS),
  QPostTest = obj_gt(A,C),
  PPostTest = obj_gt(C,B).

metarule(pab_qac_rcb,[P/2,Q/2,R/2],([P,X,Y]:-[[Q,X,Z]-true,[R,Z,Y]-true]),PS) :-
  member(Q/2,PS),
  member(R/2,PS).

obj_gt(A,B):-
  world_check(delivered_count(Ca),A),
  world_check(delivered_count(Cb),B),
  Cb > Ca,!.

obj_gt(A,B):-
  world_check(postman_bag(BagA),A),
  world_check(postman_bag(BagB),B),
  length(BagA,La),
  length(BagB,Lb),
  Lb > La,!.