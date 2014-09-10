-compile(export_all).
-module(ch5).

remstar(_, []) -> [];
remstar(A, [A|Tail]) ->
  remstar(A, Tail);
remstar(A, [H|Tail]) ->
  case is_list(H) of
    true  -> [remstar(A,H)|remstar(A,Tail)];
    false -> [H|remstar(A,Tail)]
  end.

iR(_, _, []) -> [];
iR(New, Old, [Old|Cdr]) ->
  [Old| [New| iR(New, Old, Cdr)]];
iR(New, Old, [Car|Cdr]) ->
  case is_list(Car) of
    true  -> [iR(New, Old, Car)|iR(New, Old, Cdr)];
    false -> [Car | iR(New, Old, Cdr)]
  end.

occur(_, []) -> 0;
occur(N, [N|Cdr]) ->
  1 + occur(N, Cdr);
occur(N, [Car|Cdr]) ->
  case is_list(Car) of
    true  -> occur(N, Car) + occur(N, Cdr);
    false -> occur(N, Cdr)
  end.

subs(_,_,[]) -> [];
subs(N,O, [O|Cdr]) ->
  [N|subs(N,O,Cdr)];
subs(N,O, [Car|Cdr]) ->
  case is_list(Car) of
      true  -> [subs(N,O,Car)|subs(N,O,Cdr)];
      false -> [Car|subs(N,O,Cdr)]
  end.

mem(_, []) -> false;
mem(N, [N|_]) -> true;
mem(N, [Car|Cdr]) ->
  case is_list(Car) of
    true  -> mem(N, Car) or mem(N, Cdr);
    false -> mem(N, Cdr)
  end.

lm([Car|_]) ->
  case is_list(Car) of
    true  -> lm(Car);
    false -> Car
  end.

lms([ [Car|_] | _ ]) -> lms(Car);
lms([Car|_])         -> Car.

eqlist(L, L) -> true;
eqlist(_, _) -> false.

test() ->
  [[dig, dig], run, dig, [[dig], [dag], [dug, [dig]]]] =
    remstar(
      car, 
      [[dig, car, dig], 
       run, car, dig, 
       [[dig], [dag], [dug, [car, dig]]]]),

  [a, b,[c, a, b], [], [[[a,b]]]] =
                    iR(b, a, [a, [c, a], [], [[[a]]]]),

  3 = occur(jim, [[a, [b, jim], jim, [[]], [jim]]]),

  [i, [[[love]]], nora] =
     subs(love, like, [i, [[[like]]], nora]),

  false = mem(jim, [[], [[[]]], []]),
  true = mem(jim, [[], [[[]], jim], []]),

  ok.
