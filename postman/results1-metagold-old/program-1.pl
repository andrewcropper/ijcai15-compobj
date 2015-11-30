%% Clauses: 5 InvPreds:2
postman(A,B):- postman_2(A,C), postman(C,B).
postman_2(A,B):- postman_1(A,C), go_to_start(C,B).
postman_1(A,B):- find_post(A,C), take_letter(C,B).
postman_1(A,B):- find_address(A,C), deliver_post(C,B).
postman(A,B):- postman_2(A,C), go_to_start(C,B).
