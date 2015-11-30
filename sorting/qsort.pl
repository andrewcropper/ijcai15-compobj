add_intervals(A,B):-
  world_check(intervals(Intervals1),A),
  Intervals1 = [StartPos-EndPos|_],
  world_check(left_bag(LeftBag),A),
  world_check(right_bag(RightBag),A),
  length(LeftBag,LeftLen),
  length(RightBag,RightLen),

  LeftStartPos is StartPos,
  LeftEndPos is LeftStartPos+LeftLen-1,
  RightStartPos is LeftEndPos+2,
  RightEndPos is EndPos,

  (
    (
      LeftLen > 0,
      LeftStartPos \= LeftEndPos
    )
    ->
    (
      append(Intervals1,[LeftStartPos-LeftEndPos], Intervals2),
      world_replace(intervals(_),intervals(Intervals2),A,C)
    );
      world_replace(intervals(Intervals1),intervals(Intervals1),A,C)
  ),

  (
    (
      RightLen > 0,
      RightStartPos \= RightEndPos
    )
    ->
    (
      world_check(intervals(Intervals3),C),
      append(Intervals3,[RightStartPos-RightEndPos],Intervals4),
      world_replace(intervals(_),intervals(Intervals4),C,B)
    )
    ;
      world_replace(intervals(Tmp1),intervals(Tmp1),C,B)
  )
  .

%% intervals(Len,Start,End,Xs,Ys):-
%%   Len > 0,
%%   Start \= End,!,
%%   append(Xs,[Start-End],Ys).

%% intervals(Len,Start,End,Xs,Xs).

%% %% left_interval(LeftLen,LeftStartPos,LeftEndPos,Xs,Ys):-
%% %%   LeftLen > 0,
%% %%   LeftStartPos \= LeftEndPos,!,

%% %% left_interval(_,_,_,Xs,Xs).

%% %% left_interval(LeftLen,LeftStartPos,LeftEndPos,Xs,Ys):-
%% %%   RightLen > 0,
%% %%   RightEndPos \= LeftEndPos,!,
%% %%   append(Xs,[RightStartPos-RightEndPos],Ys).
%% %% left_interval(_,_,_,Xs,Xs).


%% add_intervals(A,B):-
%%   writeln(A),
%%   world_check(intervals(Ints1),A),
%%   Ints1 = [StartPos-EndPos|_],
%%   world_check(left_bag(LeftBag),A),
%%   world_check(right_bag(RightBag),A),
%%   length(LeftBag,LeftLen),
%%   length(RightBag,RightLen),

%%   LeftStartPos is StartPos,
%%   LeftEndPos is LeftStartPos+LeftLen-1,
%%   RightStartPos is LeftEndPos+2,
%%   RightEndPos is EndPos,

%%   trace,

%%   intervals(LeftLen,LeftStartPos,LeftEndPos,Ints1,Ints2),
%%   intervals(RightLen,RightStartPos,RightEndPos,Ints2,Ints3),

%%   world_replace(intervals(_),intervals(Ints3),A,B).

remove_this_interval(A,B):-
  world_replace(intervals([_|T]),intervals(T),A,B).

%% compare_proxy(A,B):- compare(A,C), !, decrement_energy(C,B,1).
compare_proxy(A,B):- compare(A,C), !, increment_energy(C,B,1).

compare(A,B):-
  leq(A),!,
  pocket_left(A,B).

compare(A,B):-
  gt(A),!,
  pocket_right(A,B).

split(A,B):-
  at_end_pos(A),!,
  add_intervals(A,B).

split(A,B):-
  move_right(A,C),
  pick_up_right(C,D),
  compare_proxy(D,E),
  split(E,B).

%% pick_pivot(A,B):-
%%   go_to_start(A,C),
%%   pick_up_left(C,B).

drop_pivot(A,B):-drop_left(A,B),!.
drop_pivot(A,B):-move_left(A,C),drop_pivot(C,B).

%% partition(A,B):-
%%   pick_pivot(A,C),
%%   split(C,D).

combine(A,B):-
  unbag_right(A,C),
  drop_pivot(C,D),
  unbag_left(D,E),
  remove_this_interval(E,B).

