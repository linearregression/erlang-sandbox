-module(ch4).
-compile(export_all).

tup2list(T) -> 
  tup2list(T, tuple_size(T), []). 

tup2list(T, N, C) when N > 0 ->
  tup2list(T, N-1, [element(N,T)|C]);

tup2list(_, 0, C) -> C.

%% this is nice.
zup(T) ->
  [element(N,T) || N <- lists:seq(1, tuple_size(T))].

% another v
t2l(Tuple) -> t2l(Tuple, 1, tuple_size(Tuple)).

t2l(Tuple, Pos, Size) when Pos =< Size ->  
      [element(Pos,Tuple) | t2l(Tuple, Pos+1, Size)];
t2l(_Tuple,_Pos,_Size) -> [].

lz([])    -> 0;
lz([_|T]) -> 1 + lz(T).

even(X) -> X rem 2 =:= 0.
odd(X)  -> abs(X rem 2) == 1.

filter(F,L) ->
  [X || X <- L, F(X)].

%% with filter (aka list comprehensions)
split(L) ->
  {
    filter(fun(N) -> even(N) end, L),
    filter(fun(N) -> odd(N) end, L)
  }.

%% with accumulators
splt(L) ->
  splt(L, [], []).

splt([H|T], Evens, Odds) ->
  case even(H) of
    true  -> splt(T, [H|Evens], Odds);
    false -> splt(T, Evens, [H|Odds])
  end;

splt([], Evens, Odds) ->
  [Evens, Odds].

%% body recursive?
%% this doesn't work...but is the idea possible?
spt([H|T]) ->
  case even(H) of
    true  -> [H|spt(T)];
    false -> [H|spt(T)]
  end;

spt([]) ->
  [[],[]].

test()->
  L = lists:seq(1,10),
  F = fun(X) -> even(X) end,
  [2,4,6,8,10] = filter(F, L),

  [] = tup2list({}),
  [a,b,c] = tup2list({a,b,c}),
  [a, {name, "jimbo"}, c] = tup2list({a, {name, "jimbo"}, c}),

  [] = zup({}),
  [a,b,c] = zup({a,b,c}),
  [a, {name, "jimbo"}, c] = zup({a, {name, "jimbo"}, c}),

  [] = t2l({}),
  [a,b,c] = t2l({a,b,c}),
  [a, {name, "jimbo"}, c] = t2l({a, {name, "jimbo"}, c}),

  ok.
