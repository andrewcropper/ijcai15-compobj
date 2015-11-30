p_lit([]):-write(')').
p_lit([H|T]):-write(','),write(H),p_lit(T).
p_lit(P,[H|T]):-write(P),write('('),write(H),p_lit(T).

not_p_lit([]):-write('))').
not_p_lit([H|T]):-write(','),write(H),not_p_lit(T).
not_p_lit(P,[H|T]):-write('not('),write(P),write('('),write(H),not_p_lit(T).

arrow:-write(':- ').
comma:-write(', ').
end:-write('.'),nl.

p_rule(pxx,[P/2]):-p_lit(P,['A','A']).
p_rule(pxx_qx,[P/2,Q/1]):-p_lit(P,['A','A']),arrow,p_lit(Q,['A']).
p_rule(pxy_qxy,[P/2,Q/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B']).
p_rule(pxy_qxyz,[P/2,Q/3,Z]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',Z]).
p_rule(pxy_qyx,[P/2,Q/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['B','A']).

p_rule(pxy_qxy_ry,[P/2,Q/2,R/1]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B']),comma,p_lit(R,['B']).

p_rule(pxy_qxz_pzy,[P/2,Q/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','C']),comma,p_lit(P,['C','B']).
p_rule(pxy_qxya,[P/2,Q/3,A]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',A]).
p_rule(pxy_qxyab,[P/2,Q/4,A,B]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',A,B]).
p_rule(repeat,[P/2,Q/2,Z]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',Z]).

p_rule(pa_qax,[P/1,Q/2,X]):-p_lit(P,['A']),arrow,p_lit(Q,['A',X]).
p_rule(pab_qabx,[P/2,Q/3,X]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',X]).
p_rule(pab_qabxy,[P/2,Q/4,X,Y]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B',X,Y]).

p_rule(pab_qab,[P/2,Q/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','B']).
p_rule(pab_qa_rab,[P/2,Q/1,R/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A']),comma,p_lit(R,['A','B']).
p_rule(pab_qac_rcb,[P/2,Q/2,R/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','C']),comma,p_lit(R,['C','B']).
p_rule(pab_qac_pcb,[P/2,Q/2]):-p_lit(P,['A','B']),arrow,p_lit(Q,['A','C']),comma,p_lit(P,['C','B']).

sub_print_screen(H):-
  H=sub(Name,HOSub),
  p_rule(Name,HOSub),write('.'),nl.

print_screen([]).
print_screen([H|T]):-
  sub_print_screen(H),
  print_screen(T).

pprint_([]).
pprint_([H|T]):-
  sub_print_screen(H),
  pprint_(T).

pprint(A):-
  pprint_(A).