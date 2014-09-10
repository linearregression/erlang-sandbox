-module(ch3).
-compile(export_all).

mS(_, _, []) -> [];
mS(New, Old, [H|T]) ->
  case Old == H of
    true  -> [New| mS(New,Old,T)];
    false -> [H | mS(New, Old, T)]
  end.

mStr(N,O,L) -> mStr(N,O,L,[]).
mStr(_,_,[],Acc) -> lists:reverse(Acc);
mStr(N,O,[H|T],Acc) ->
  case H==O of
    true -> mStr(N,O,T, [N|Acc]);
    false -> mStr(N,O,T, [H|Acc])
  end.

mL(_New, _Old, []) -> [];
mL(New, Old, [H|T]) ->
  case H == Old of
    true  ->  [New | [Old|mL(New, Old, T)]];
    false ->  [H | mL(New, Old, T)]
  end. 

mLtr(New, Old, Lat) -> mLtr(New, Old, Lat, []).
mLtr(_, _, [], Acc) -> lists:reverse(Acc);
mLtr(New, Old, [Head|Tail], Acc) ->
  case Head == Old of
    true -> mLtr(New, Old, Tail, [Old| [New|Acc]]);
    false -> mLtr(New, Old, Tail, [Head|Acc])
  end.

mserR(_, _, []) -> [];
mserR(N, O, [H|T]) ->
  case H == O of
    true -> [O | [N | mserR(N, O, T)]];
    false -> [H | mserR(N, O, T)]
  end.

%% bonus: tail recursive version
%% if you are going to reverse everything at the end (for TR, for example)
%% then everything else you do within the collection needs to be rev'd as
%% well. this should be intuitive. 
%% rule: put m after a in jaes: james.
%%       now reverse james:  semaj.
%%       is a after me now? no.
%%       you put a reverse at the end. all internal shit needs to be
%%       reconciled with it.
mserRtr(N, O, L) -> mserRtr(N, O, L, []).
mserRtr(_, _, [], Acc) -> lists:reverse(Acc);
mserRtr(N, O, [Head|Tail], Acc) ->
  case O == Head of
    true -> mserRtr(N, O, Tail, [ N | [O|Acc] ]);
    false -> mserRtr(N, O, Tail, [Head|Acc])
  end.
% mserRtr(2, 1, [9,1], [])
% mserRtr(2, 1, [1], [9])
% mserRtr(2, 1, [], [1,2,9])
% [9,2,1]
%
mR(_, []) -> [];
mR(E, [Head|Tail]) ->
  case E == Head of
    true -> mR(E, Tail);
    false -> [Head|mR(E, Tail)]
  end.

%% bonus: tail recursive version
mRtr(E, L) -> mRtr(E, L, []).
mRtr(_, [], Acc) -> lists:reverse(Acc);
mRtr(E, [H|T], Acc) ->
  case E == H of
    true -> mRtr(E, T, Acc);
    false -> mRtr(E, T, [H|Acc])
  end.

is_lat([]) -> true;
is_lat([H|T]) ->
  case is_atom(H) of
    true -> is_lat(T);
    false -> false
  end.

is_member(_, []) -> false;
is_member(N, [H|T]) ->
  case H == N of
    true -> true;
    false -> is_member(N, T)
  end.

firsts([]) -> [];
firsts([ [FE|_FR] | T]) ->
  [FE|firsts(T)].

%%% bonus: tail recursive version
ftr(L) -> ftr(L, []).
ftr([], Acc) -> lists:reverse(Acc);
ftr([ [FE|_FR] | R], Acc) ->
  ftr(R, [FE|Acc]).

test() ->
  true = is_lat([]),
  true = is_lat([foo, bar, baz]),
  false = is_lat([foo, [bar], baz]),

  false = is_member(a, []),
  true = is_member(a, [b, a, c]),
  false = is_member(a, [d, d, d]), 

  [a,b,c] = firsts([ [a, 1, 2], [b, 1, 2], [c, 1, 2] ]),
  [a,b,c] = ftr([ [a, 1, 2], [b, 1, 2], [c, 1, 2] ]),

  [a,b,c] = mR(1,[a,1,b,1,c,1]),
  [a,b,c] = mRtr(1,[a,1,b,1,c,1]),

  [i, love, you, love, you] = mserR(you, love, [i, love, love]),
  [i, love, you, love, you] = mserRtr(you, love, [i, love, love]),

  [i, you, love, you, love] = mL(you, love, [i, love, love]),
  [i, you, love, you, love] = mLtr(you, love, [i, love, love]),

  [i, love, you, love, you] = mS(love, like, [i, like, you, like, you]),
  [i, love, you, love, you] = mStr(love, like, [i, like, you, like, you]),
  ok.
