metasort(A,B):- metasort1(A,C), metasort(C,B).
metasort1(A,B):- comp_adj_proxy(A,C), !,metasort1(C,B).
metasort1(A,B):- decrement_end(A,C), go_to_start(C,B).
metasort(A,B):- metasort1(A,C), go_to_start(C,B).
