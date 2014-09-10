-module(fold).
-export([fold/3]).

fold([], Acc, _)      -> Acc;
fold([H|T], Acc, Fun) -> fold(T, Fun(H,Acc), Fun).
