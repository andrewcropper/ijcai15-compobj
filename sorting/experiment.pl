:-['../metagol/metagolo'].
:-['../metagol/metagol'].
:-[metarules].
:-[prims].
:-[qsort].
:-[bsort].

prim(comp_adjacent/2).
prim(decrement_end/2).
prim(go_to_start/2).
prim(pick_up_left/2).
prim(split/2).
prim(combine/2).

example(N,X,Y):-
  numlist(1,N,L1),
  random_permutation(L1,L2),
  X = [values(L2),energy(0),intervals([1-N]),robot_pos(1),holding_left(none),holding_right(none),left_bag([]),right_bag([])],
  Y = [values(L1),energy(_),intervals(_),robot_pos(_),holding_left(_),holding_right(_),left_bag(_),right_bag(_)].

examples(M,Xs):- random_between(2,50,N), examples(M,N,Xs).

examples(M,N,Xs):-
  findall([metasort,X,Y],(
    between(1,M,_),
    example(N,X,Y)
  ),Xs).

learn_metagold:-
  examples(5,Xs),
  learn(metasort,Xs,[],G),!,
  pprint(G).

learn_metagolo :-
  examples(5,Xs),
  metagolo(metasort,Xs,G,_),!,
  pprint(G).

do_test(N) :-
  findall(Energy,(
    between(1,5,_),
    example(N,A,B),
    metasort(A,B),
    world_check(energy(Energy),B)),L1),
  avg(L1,Mean),
  write(Mean),nl.

avg(List,Avg2):-
  sumlist(List,Sum),
  length(List,Length),
  Avg1 is Sum/Length,
  Avg2 is ceil(Avg1).