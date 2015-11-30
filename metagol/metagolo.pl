%% Andrew Cropper
%% MetagolO version 1

get_bound(Xs,G,Bound):-
  foreach(member(X,G), assert_clause(X)),
  findall(E,(
      member(X,Xs),
      X = [_,_,B],
      Goal =..X,Goal,
      member(energy(E),B))
    ,Es),
  foreach(member(X,G), retract_clause(X)),
  max_list(Es,Bound).

assert_bound(Bound):-
  retract(energy_bound(_)),!,
  assert(energy_bound(Bound)).

assert_bound(Bound):-
  assert(energy_bound(Bound)).

metagolo(Name,Xs,G2,Energy):-
  learn(Name,Xs,[],G1),!,
  get_bound(Xs,G1,Bound),
  write('%% energy: '), write(Bound), nl,
  metagolo(Name,Xs,G1,G2,Bound,Energy).

metagolo(Name,Xs,_,G2,Bound,Energy):-
  assert_bound(Bound),
  learn(Name,Xs,[],G1),!,
  get_bound(Xs,G1,NewBound),
  writeln(''),
  write('%% energy: '), write(NewBound), nl,
  pprint(G1),
  metagolo(Name,Xs,G1,G2,NewBound,Energy).

metagolo(_,_,G,G,Energy,Energy).

assert_clause(sub(pab_qac_rcb,[P/2,Q/2,R/2])):-
  Head =..[P,A,B],
  Body1 =..[Q,A,C],
  Body2 =..[R,C,B],
  assertz((Head :- Body1,Body2)).

assert_clause(sub(pab_qac_pcb,[P/2,Q/2])):-
  Head =..[P,A,B],
  Body1 =..[Q,A,C],
  Body1_test =..[obj_gt,A,C],
  Body2 =..[P,C,B],
  Body2_test =..[obj_gt,C,B],
  assertz((Head :- Body1,Body1_test,Body2,Body2_test)).

retract_clause(sub(_,[P/2|_])):-
  Head =..[P,_,_],
  retractall((Head)).