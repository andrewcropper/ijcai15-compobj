metasort(A,B):- metasort1(A,C), metasort(C,B).
metasort1(A,B):- pick_pivot(A,C), split(C,B).
metasort1(A,B):- combine(A,C), go_to_start(C,B).
metasort(A,B):- split(A,C), combine(C,B).