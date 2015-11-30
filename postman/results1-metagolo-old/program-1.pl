%% Clauses: 5 InvPreds:1
postman(A,B):- postman_2(A,C), postman_2(C,B).
postman_2(A,B):- postman_1(A,C), postman_2(C,B).
postman_1(A,B):- find_post(A,C), bag_post(C,B),!.
postman_2(A,B):- postman_1(A,C), go_to_start(C,B).
postman_1(A,B):- find_address(A,C), deliver_post(C,B).