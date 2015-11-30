:- dynamic energy_bound/1.

world_check(X,S) :-
  nonvar(S),
  member(X,S).

world_replace(A,B,S1,S2) :-
  nonvar(S1),
  append(Prefix,[A|Suffix],S1),
  append(Prefix,[B|Suffix],S2).

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

at_end(S1,S2):-
  world_check(pos(postman,Pos),S1),
  world_check(end_pos(Pos),S1),
  S1 = S2.

at_start(S1,S1):-
  world_check(pos(postman,Pos),S1),
  world_check(start_pos(Pos),S1).

move_all_bag([],S1,S1,_).

move_all_bag([Id/_|T],S1,S2,Pos) :-
  world_replace(pos(Id,_),pos(Id,Pos),S1,S3),
  move_all_bag(T,S3,S2,Pos).

move_right(S1,S2) :-
  world_check(pos(postman,Pos1),S1),
  world_check(end_pos(EndPos),S1),
  Pos2 is Pos1+1,
  Pos2 =< EndPos,
  world_replace(pos(postman,_),pos(postman,Pos2),S1,S3),
  world_check(postman_bag(Bag1),S1),
  move_all_bag(Bag1,S3,S4,Pos2),
  decrement_energy(S4,S2,1).

move_left(S1,S2) :-
  world_check(pos(postman,Pos1),S1),
  world_check(start_pos(StartPos),S1),
  Pos2 is Pos1-1,
  Pos2 >= StartPos,
  world_replace(pos(postman,_),pos(postman,Pos2),S1,S3),
  world_check(postman_bag(Bag1),S1),
  move_all_bag(Bag1,S3,S4,Pos2),
  decrement_energy(S4,S2,1).

go_to_start(S1,S2) :-
  world_check(pos(postman,OldPos),S1),
  world_check(start_pos(NewPos),S1),
  world_replace(pos(postman,OldPos),pos(postman,NewPos),S1,S3),
  world_check(postman_bag(Bag1),S1),
  move_all_bag(Bag1,S3,S4,NewPos),
  EnergyUsed is OldPos-NewPos,
  decrement_energy(S4,S2,EnergyUsed).

go_to_end(S1,S2) :-
  world_check(pos(postman,OldPos),S1),
  world_check(end_pos(NewPos),S1),
  world_replace(pos(postman,OldPos),pos(postman,NewPos),S1,S3),
  world_check(postman_bag(Bag1),S1),
  move_all_bag(Bag1,S3,S4,NewPos),
  EnergyUsed is NewPos-OldPos,
  decrement_energy(S4,S2,EnergyUsed).

bag_post(S1,S2):-
  world_check(pos(postman,Pos),S1),

  %% check for letter in this position
  world_check(pos(Id,Pos),S1),
  %% check that it is not already in the bag
  world_check(postman_bag(Bag1),S1),
  not(member(Id/_,Bag1)),
  %% get destination
  world_check(letter(Id,_,Destination),S1),

  %% check that it is not already delivered
  Pos \= Destination,

  append(Bag1,[Id/Destination],Bag2),

  %% trace,
  world_replace(postman_bag(Bag1),postman_bag(Bag2),S1,S3),
  decrement_energy(S3,S2,1).

deliver_post(S1,S2):-
  world_check(pos(postman,Pos),S1),
  world_check(postman_bag(Bag1),S1),
  %% for letter is in this position
  world_check(pos(Id,Pos),S1),
  %% find letter in the bag to deliver to this position
  append(Prefix,[Id/Pos|Suffix],Bag1),
  %% remove letter from bag
  append(Prefix,Suffix,Bag2),
  world_replace(postman_bag(Bag1),postman_bag(Bag2),S1,S3),

  %% updated delivered_count
  world_check(delivered_count(DeliveredCount1),S1),
  DeliveredCount2 is DeliveredCount1+1,

  %% updated delivered_count
  world_replace(delivered_count(DeliveredCount1),delivered_count(DeliveredCount2),S3,S4),
  decrement_energy(S4,S2,1).


find_post(S1,S1):- bag_post(S1,_),!.
find_post(S1,S2):- move_right(S1,S3), find_post(S3,S2).

find_address(S1,S1):- deliver_post(S1,_),!.
find_address(S1,S2):- move_right(S1,S3), find_address(S3,S2).

take_letter(A,B):-
  world_check(postman_bag([]),A),
  bag_post(A,B).