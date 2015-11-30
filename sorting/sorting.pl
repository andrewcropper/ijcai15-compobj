%% %% :-[metagolo].
%% :-[metagol].
%% :-[metarules].
%% :-[prims2].
%% :-[qsort].
%% :-[bsort].

%% %% prim(comp_adj_proxy/2).
%% %% prim(decrement_end/2).
%% %% prim(go_to_start/2).
%% %% prim(pick_pivot/2).
%% prim(go_to_start/2).
%% prim(pick_up_left/2).
%% prim(combine/2).
%% prim(split/2).


%% example(N,X,Y):-
%%   numlist(1,N,L1),
%%   random_permutation(L1,L2),
%%   X = [values(L2),energy(0),intervals([1-N]),robot_pos(1),holding_left(none),holding_right(none),left_bag([]),right_bag([])],
%%   Y = [values(L1),energy(_),intervals(_),robot_pos(_),holding_left(_),holding_right(_),left_bag(_),right_bag(_)].

%% examples(M,Xs):-
%%   findall([sort,X,Y],(
%%     between(1,M,_),
%%     random_between(2,25,N),
%%     example(N,X,Y)
%%   ),Xs).

%% qsort(A,B):- qsort_2(A,C), obj_gt(A,C), qsort(C,B), obj_gt(C,B).
%% qsort(A,B):- qsort_2(A,C), qsort_2(C,B).
%% qsort_2(A,B):- qsort_1(A,C), combine(C,B).
%% qsort_1(A,B):- pick_pivot(A,C), split(C,B).

%% %% bsort(A,B):- bsort_1(A,C), bsort(C,B).
%% %% bsort(A,B):-w bsort_1(A,B).
%% %% bsort_1(A,B):- comp_adj_proxy(A,C), bsort_1(C,B).
%% %% bsort_1(A,B):- decrement_end(A,C), go_to_start(C,B).

%% l1 :-
%%   examples(20,Xs),
%%   writeln(Xs),
%%   learn(sort,Xs,[],G),
%%   pprint(G).

%% %% t1 :-
%% %%   examples(1,Xs),
%% %%   Xs = [[_,A,B]],
%% %%   qsort(A,C), writeln(C).