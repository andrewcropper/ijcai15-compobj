comp_adj(A,B):- next_gt_current(A), !, move_right(A,B).
comp_adj(A,B):- next_lt_current(A), !, swap_adj(A,C), move_right(C,B).
%% comp_adj_proxy(A,B):- comp_adj(A,C), !, decrement_energy(C,B,1).
comp_adjacent(A,B):- comp_adj(A,C), !, increment_energy(C,B,1).

swap_adj(A,B):-
  pick_up_left(A,C),
  move_right(C,D),
  pick_up_right(D,E),
  drop_left(E,F),
  move_left(F,G),
  drop_right(G,B).

next_lt_current(A):-
  robot_pos(A,Pos1),
  Pos2 is Pos1+1,
  value_at(A,Pos1,X),
  value_at(A,Pos2,Y),
  Y @< X.

next_gt_current(A):-
  robot_pos(A,Pos1),
  Pos2 is Pos1+1,
  value_at(A,Pos1,X),
  value_at(A,Pos2,Y),
  Y @> X.