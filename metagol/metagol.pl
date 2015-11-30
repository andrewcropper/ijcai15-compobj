%% Andrew Cropper
%% Metagol version 0

:- [pprint].


learn(Name,Pos,[],G):-
  add_prepost(Pos,Pos2),!,
  proveall(Name,Pos2,_,G).
  %% (functional -> func_test(Pos2,PS,G); true).

%% learn(Name,Pos,[],PS,G):-
%%   add_prepost(Pos,Pos2),!,
%%   proveall(Name,Pos2,PS,G).
  %% (functional -> func_test(Pos2,PS,G); true).

proveall(Name,Atoms,PS,G):-
  iterator(N,M),
  pred_sig(Name,M,PS),
  write('%% '), write('Clauses: '),write(N),write(' '),write('InvPreds:'),write(M),nl,
  prove(Atoms,PS,N,[],G).

prove([],_,_,G,G).

prove([Atom-PostTest|Atoms],PS,MaxN,G1,G2):-
  prim_atom(Atom),
  Goal =..Atom,!,
  Goal,
  PostTest,
  prove(Atoms,PS,MaxN,G1,G2).

prove([Atom-PostTest|Atoms],PS1,MaxN,G1,G2):-
  slice_ps(PS1,Atom,PS2),!,
  metarule(Name,MetaSub,(Atom :- Body),PS2),
  abduce(sub(Name,MetaSub),MaxN,G1,G3),
  prove(Body,PS1,MaxN,G3,G4),
  PostTest,
  prove(Atoms,PS1,MaxN,G4,G2).

prove_deduce([],_,_).

prove_deduce([Atom-PostTest|Atoms],PS,G):-
  prim_atom(Atom),
  Goal =..Atom,!,
  Goal,
  PostTest,
  prove_deduce(Atoms,PS,G).

prove_deduce([Atom-PostTest|Atoms],PS,G):-
  member(sub(Name,MetaSub),G),
  metarule(Name,MetaSub,(Atom :- Body),PS),
  prove_deduce(Body,PS,G),
  PostTest,
  prove_deduce(Atoms,PS,G).

nproveall([],_,_).
nproveall([Atom|T],PS,G):-
  (prove_deduce([Atom],PS,G) -> false; true),
  nproveall(T,PS,G).

abduce(X,_,G,G):- member(X,G),!.

abduce(X,MaxN,G1,G2) :-
  length(G1,L),
  N is L+1,
  N =< MaxN,
  tmp(X,G1),
  %% deterministic(X,G1),
  append(G1,[X],G2).

%% prevents two induction steps
tmp(X,G):-
  X = sub(pab_qac_pcb,[H|_]),
  member(sub(pab_qac_pcb,[H|_]),G),
  !,false.
tmp(_,_).


deterministic(X,_):- X = sub(pab_qac_pcb,_),!.
deterministic(X,G):-
  X = sub(_,[H|_]),
  member(sub(Rule,[H|_]),G),
  Rule \= pab_qac_pcb,
  !, false.
deterministic(_,_).

prim_atom(Atom):-
  Atom=[P|_],
  arity(Atom,A),
  prim(P/A).

arity([_|Body],N) :-
  length(Body,N).

add_prepost(A,B) :-
  findall(Atom-true,member(Atom,A),B).

inv_preds(_,0,[]) :- !.
inv_preds(Name,MaxM,PS) :-
  findall(Sk/2,(
    between(1,MaxM,M),
    atomic_concat(Name,'_',Prefix),
    atomic_concat(Prefix,M,Sk)), PS1),
  reverse(PS1,PS).

pred_sig(Name,M,PS):-
  inv_preds(Name,M,InvPreds),
  findall(X, prim(X), Prims),
  append(InvPreds,Prims,PS).

slice_ps(PS1,Atom,PS2):-
  Atom = [P|_],
  arity(Atom,A),
  append(_,[P/A|PS2],PS1),!.

slice_ps(PS,_,PS).

iterator(N,M) :-
  MaxN is 8,
  between(1,MaxN,N),
  MaxM is N-1,
  between(1,MaxM,M).


zipwithindex(A,B) :-
  findall(E/I,nth0(I,A,E),B).

func_test([],_,_).
func_test([Atom|Atoms],PS,G) :-
  do_func_test(Atom,PS,G),
  func_test(Atoms,PS,G).