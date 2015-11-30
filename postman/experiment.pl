:-['../metagol/metagolo'].
:-['../metagol/metagol'].
:-[metarules].
:-[prims].

prim(go_to_bottom/2).
prim(go_to_top/2).
prim(find_next_sender/2).
prim(find_next_recipient/2).
prim(take_letter/2).
prim(bag_letter/2).
prim(give_letter/2).

%% predicate mapping because of renaming of predicates in the paper
go_to_bottom(A,B):- go_to_start(A,B).
go_to_top(A,B):- go_to_end(A,B).
find_next_sender(A,B):- find_post(A,B).
find_next_recipient(A,B):- find_address(A,B).
bag_letter(A,B):- bag_post(A,B).
give_letter(A,B):- deliver_post(A,B).

pos_pair(SpaceSize,StartPos,EndPos):-
  numlist(1,SpaceSize,A),
  random_permutation(A,B),
  random_select(StartPos,B,C),
  random_select(EndPos,C,_).

letters(NumLetters,MaxSpace,Letters):-
  findall(letter(I,StartPos,EndPos),(between(1,NumLetters,I),pos_pair(MaxSpace,StartPos,EndPos)),Letters).

letters_start_pos(Letters,LettersStartPositions):-
  findall(pos(I,StartPos), member(letter(I,StartPos,_),Letters),LettersStartPositions).

letters_end_pos(Letters,LettersEndPositions):-
  findall(pos(I,EndPos), member(letter(I,_,EndPos),Letters),LettersEndPositions).

example(SpaceSize,NumLetters,A,B):-
  letters(NumLetters,SpaceSize,Letters),
  letters_start_pos(Letters,LettersStartPositions),
  letters_end_pos(Letters,LettersEndPositions),
  append(LettersStartPositions,Letters,T1),
  append(LettersEndPositions,Letters,T2),
  A = [pos(postman,0),energy(0),postman_bag([]),start_pos(0),end_pos(SpaceSize),delivered_count(0)|T1],
  B = [pos(postman,_),energy(_),postman_bag([]),start_pos(0),end_pos(SpaceSize),delivered_count(NumLetters)|T2].

example(SpaceSize,A,B):-
  random_select(NumLetters,[2,3,4,5],_),!,
  example(SpaceSize,NumLetters,A,B).

examples(NumExamples,SpaceSize,Xs):-
  findall([postman,A,B], (between(1,NumExamples,_),example(SpaceSize,A,B)),Xs).

learn_metagold:-
  NumExamples = 5,
  SpaceSize = 50,
  examples(NumExamples,SpaceSize,Xs),
  learn(postman,Xs,[],G),!,
  pprint(G).

learn_metagolo :-
  NumExamples = 5,
  SpaceSize = 50,
  examples(NumExamples,SpaceSize,Xs),
  metagolo(postman,Xs,G,_),!,
  pprint(G).

do_test(NumLetters) :-
  SpaceSize = 50,
  findall(Energy,(
    between(1,10,_),
    example(SpaceSize,NumLetters,A,B),
    postman(A,B),
    world_check(energy(Energy),B)),L1),
  avg(L1,Mean),
  write(Mean),nl.

avg(List,Avg2):-
  sumlist(List,Sum),
  length(List,Length),
  Avg1 is Sum/Length,
  Avg2 is ceil(Avg1).