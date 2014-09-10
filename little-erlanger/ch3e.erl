-module(ch3e).
-compile(export_all).

rember(_, [])    -> [];
rember(A, [A|T]) -> [A|remh(A,T)];
rember(A, [H|T]) -> [H|rember(A,T)].

remh(_, [])       -> [];
remh(A, [A|T])    -> T;
remh(A, [H|T])    -> [H|remh(A,T)].

%% chapter 4 exercises
index(N, L) -> index(N, L, 1).

index(_, [], _)    -> false;
index(A, [A|_], N) -> N;
index(A, [_|T], N) -> index(A, T, N+1).

product([], []) -> [];
product(V1, []) -> V1;
product([], V2) -> V2;
product([H1|T1], [H2|T2]) ->
  [H1*H2|product(T1,T2)].

dotproduct(V1, V2) ->
  dotproduct(V1, V2, 0).

dotproduct(_, [], N)            -> N;
dotproduct([H1|T1], [H2|T2], N) ->
  dotproduct(
    T1,
    T2,
    N + (H1 * H2)
  ).
