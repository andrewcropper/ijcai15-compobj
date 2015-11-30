:- dynamic energy_bound/1.

world_check(X,A):-
  nonvar(A),
  member(X,A).

world_replace(X,Y,A,B):-
  nonvar(A),
  append(Prefix,[X|Suffix],A),
  append(Prefix,[Y|Suffix],B).

value_at(A,Index,Value):-
  world_check(values(L),A),
  nth1(Index,L,Value).

value_replace_at(A,B,I,X) :-
  world_check(values(L),A),
  Dummy =.. [dummy|L],
  J is I,
  setarg(J,Dummy,X),
  Dummy =..[dummy|R],
  world_replace(values(L),values(R),A,B).

increment_energy(A,B,Amount):-
  energy_bound(Bound),!,
  world_check(energy(E1),A),
  E2 is E1+Amount,
  E2 < Bound,
  world_replace(energy(E1),energy(E2),A,B).

increment_energy(A,B,Amount):-
  world_check(energy(E1),A),
  E2 is E1+Amount,
  world_replace(energy(E1),energy(E2),A,B).

decrement_energy(A,B,EnergyUsed):-
  increment_energy(A,B,EnergyUsed).

%% move_right(A,B):-
%%   world_check(robot_pos(X1),A),
%%   end_pos(A,EndPos),
%%   X2 is X1+1,
%%   X2 =< EndPos,
%%   world_replace(robot_pos(X1),robot_pos(X2),A,B).

move_right(A,B):-
  world_check(robot_pos(X1),A),
  end_pos(A,EndPos),
  X2 is X1+1,
  X2 =< EndPos,
  world_replace(robot_pos(X1),robot_pos(X2),A,B).
  %% increment_energy(C,B,0).

move_left(A,B):-
  world_check(robot_pos(X1),A),
  start_pos(A,StartPos),
  X2 is X1-1,
  X2 >= StartPos,
  world_replace(robot_pos(X1),robot_pos(X2),A,B).
  %% increment_energy(C,B,0).

go_to(A,A,Pos):-
  world_check(robot_pos(Pos),A),!.

go_to(A,B,Pos):-
  world_check(robot_pos(X1),A),
  X1 < Pos,!,
  move_right(A,C),
  go_to(C,B,Pos).

go_to(A,B,Pos):-
  world_check(robot_pos(X1),A),
  X1 > Pos,!,
  move_left(A,C),
  go_to(C,B,Pos).

go_to_start(A,B):-
  start_pos(A,X),
  go_to(A,B,X).

go_to_end(A,B):-
  end_pos(A,X),
  go_to(A,B,X).

at_end_pos(A):-
  end_pos(A,X),
  robot_pos(A,X).

at_start_pos(A):-
  start_pos(A,X),
  robot_pos(A,X).

robot_pos(A,X):-
  world_check(robot_pos(X),A).

end_pos(A,EndPos):-
  world_check(intervals([_-EndPos|_]),A).

start_pos(A,StartPos):-
  world_check(intervals([StartPos-_|_]),A).

drop_left(A,B):-
  world_check(holding_left(X),A),
  X \= none,
  robot_pos(A,Pos),
  value_at(A,Pos,none),
  value_replace_at(A,C,Pos,X),
  world_replace(holding_left(_),holding_left(none),C,B).

drop_right(A,B):-
  world_check(holding_right(X),A),
  X \= none,
  robot_pos(A,Pos),
  value_at(A,Pos,none),
  value_replace_at(A,C,Pos,X),
  world_replace(holding_right(_),holding_right(none),C,B).

pick_up_left(A,B):-
  world_check(holding_left(none),A),
  world_check(robot_pos(Pos),A),
  value_at(A,Pos,Value),
  Value \= none,
  value_replace_at(A,C,Pos,none),
  world_replace(holding_left(_),holding_left(Value),C,B).

pick_up_right(A,B):-
  world_check(holding_right(none),A),
  world_check(robot_pos(Pos),A),
  value_at(A,Pos,Value),
  Value \= none,
  value_replace_at(A,C,Pos,none),
  world_replace(holding_right(_),holding_right(Value),C,B).

increment_start(A,B):-
  world_check(intervals([StartPos1-EndPos|T]),A),
  StartPos2 is StartPos1 + 1,
  StartPos2 =< EndPos,
  world_replace(intervals([StartPos1-EndPos|T]),intervals([StartPos2-EndPos|T]),A,B).

decrement_end(A,B):-
  world_check(intervals([StartPos-EndPos1|T]),A),
  EndPos2 is EndPos1 - 1,
  EndPos2 >= StartPos,
  world_replace(intervals([StartPos-EndPos1|T]),intervals([StartPos-EndPos2|T]),A,B).

%% right_lt_left(A):-
%%   world_check(holding_left(X),A),
%%   world_check(holding_right(Y),A),
%%   X \= none,
%%   Y \= none,
%%   Y < X.

%% right_gt_left(A):-
%%   world_check(holding_left(X),A),
%%   world_check(holding_right(Y),A),
%%   X \= none,
%%   Y \= none,
%%   Y > X.

leq(S1):-
  world_check(holding_left(X),S1),
  world_check(holding_right(Y),S1),
  X \= none,
  Y \= none,
  Y =< X.

gt(S1):-
  world_check(holding_left(X),S1),
  world_check(holding_right(Y),S1),
  X \= none,
  Y \= none,
  Y > X.

finished(A):-
  world_check(intervals([]),A),!.
finished(A):-
  world_check(intervals([X-X|[]]),A).

%% finished(A,A):-
  %% world_check(intervals([]),A),!.
%% finished(A,A):-
  %% world_check(intervals([X-X|[]]),A).

pocket_left(A,B) :-
  world_check(holding_right(none),A),!,
  pick_up_right(A,C),
  pocket_left(C,B).

pocket_left(A,B) :-
  world_check(holding_right(Value),A),
  Value \= none,
  world_replace(left_bag(L),left_bag([Value|L]),A,C),
  world_replace(holding_right(Value),holding_right(none),C,B).

pocket_right(A,B) :-
  world_check(holding_right(none),A),!,
  pick_up_right(A,C),
  pocket_right(C,B).

pocket_right(A,B) :-
  world_check(holding_right(Value),A),
  Value \= none,
  world_replace(right_bag(L),right_bag([Value|L]),A,C),
  world_replace(holding_right(Value),holding_right(none),C,B).

left_bag_empty(A):-
  world_check(left_bag([]),A).

right_bag_empty(A):-
  world_check(right_bag([]),A).

unbag_left(A,A):-
  left_bag_empty(A),!.

unbag_left(A,B):-
  world_check(left_bag([H|T]),A),
  robot_pos(A,Pos),
  value_at(A,Pos,none),!,
  value_replace_at(A,C,Pos,H),
  world_replace(left_bag(_),left_bag(T),C,D),
  unbag_left(D,B).

unbag_left(A,B):-
  move_left(A,C),
  unbag_left(C,B).

unbag_right(A,A):-
  right_bag_empty(A),!.

unbag_right(A,B):-
  world_check(right_bag([H|T]),A),
  robot_pos(A,Pos),
  value_at(A,Pos,none),!,
  value_replace_at(A,C,Pos,H),
  world_replace(right_bag(_),right_bag(T),C,D),
  unbag_right(D,B).

unbag_right(A,B):-
  move_left(A,C),
  unbag_right(C,B).

lt_holding_left(A):-
  world_check(holding_left(X),A),
  robot_pos(A,Pos),
  value_at(A,Pos,Y),
  X \= none,
  Y \= none,
  Y < X.

gt_holding_left(A):-
  world_check(holding_left(X),A),
  robot_pos(A,Pos),
  value_at(A,Pos,Y),
  X \= none,
  Y \= none,
  Y > X.