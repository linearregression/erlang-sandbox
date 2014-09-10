-module(ch5s).
-compile(export_all).

%%% occurn
occur(Markers,List)     -> occur(Markers,List,0).

occur([],_,Acc)         -> Acc;
occur([H|T], List, Acc) -> occur(T, List, Acc + numtimes(H,List)).

numtimes(_,[])    -> 0;
numtimes(A,[A|T]) -> 1 + numtimes(A,T);
numtimes(A,[_|T]) -> numtimes(A,T).

%%% do with fold / comprehensions.
ol(Markers,List) ->
  lists:foldl(
    fun(E,Sum) -> Sum + nt(E,List) end,
    0,
    Markers). 

nt(Needle,List) ->
  length([X || X <- List, X =:= Needle]).

%% multiup.
mu([])      -> [];
mu([[]|R])  -> mu(R);
mu([[H]|R]) -> [H|mu(R)];
mu([H|R])   -> [H|mu(R)]. %% an atom or a [n, ..] makes no diff. :)

test() ->
  0 = occur([jim], []),
  0 = occur([], [jim]),
  3 = occur([jim, nora], [jim, mae, nora, nora, itan]),

  0 = ol([jim], []),
  0 = ol([], [jim]),
  3 = ol([jim, nora], [jim, mae, nora, nora, itan]),

  [] = mu([]),
  S = [jim, [], [], [nora], [mae], [aras, [chea]], nora],
  [jim, nora, mae, [aras, [chea]], nora] = mu(S),

  ok.
