-module(shadows).
-compile(export_all).

%%% Numbered
numbered(N) when is_number(N) -> true;
numbered([E1,E2,E3])     ->
  is_valid_operator(E2) andalso
    numbered(E1) andalso
    numbered(E3);
numbered(_)                   -> false.

is_valid_operator(Op) ->
  lists:member(Op, [plus, times]).

%%% Value
value(N) when is_number(N) -> N;
value([_, _, _]=Aexp)      ->
  case getop(Aexp) of
    plus  -> value(first_sub(Aexp)) + value(sec_sub(Aexp));
    times -> value(first_sub(Aexp)) * value(sec_sub(Aexp))
  end.

getop([_,Op,_])          -> Op.
first_sub([First, _, _]) -> First.
sec_sub([_,_,Sec])       -> Sec.

%%% working on my abstractions...
%%% this is dumb. but was a decent exercise.
%%% maybe uber abstraction is best left for a lisp?
%%% i just suck at it, probably.
absv(OpsFun, ExpFun, ExpFun2) ->
  fun Value(N) when is_number(N) -> N;
      Value([_,_,_]=Aexp)        ->
         case OpsFun(Aexp) of
           plus   -> Value(ExpFun(Aexp)) + Value(ExpFun2(Aexp));
           times  -> Value(ExpFun(Aexp)) * Value(ExpFun2(Aexp))
         end
  end.

first()  -> fun([F,_,_]) -> F end.
middle() -> fun([_,M,_]) -> M end.
last()   -> fun([_,_,L]) -> L end.

infix_value(Aexp) ->
  (absv(middle(), first(), last()))(Aexp). %%% this doesn't look erlangy...maybe this isn't idomatic?

postfix_value(Aexp) ->
  (absv(last(), first(), middle()))(Aexp).

prefix_value(Aexp) ->
  (absv(first(), middle(), last()))(Aexp).

test() ->
  1    = value(1),
  4    = value([2, plus, 2]),
  9    = value([3, times, 3]),
  10   = value([[3, times, 3], plus, 1]),
  12   = value([[3, times, 3], plus, [3, times, 1]]),

  1    = infix_value(1),
  4    = infix_value([2, plus, 2]),
  9    = infix_value([3, times, 3]),
  10   = infix_value([[3, times, 3], plus, 1]),
  12   = infix_value([[3, times, 3], plus, [3, times, 1]]),

  1    = postfix_value(1),
  4    = postfix_value([2, 2, plus]),
  9    = postfix_value([3, 3, times]),
  10   = postfix_value([[3, 3, times], 1, plus]),
  12   = postfix_value([[3, 3, times], [3, 1, times], plus]),

  1    = prefix_value(1),
  4    = prefix_value([plus, 2, 2]),
  9    = prefix_value([times, 3, 3]),
  10   = prefix_value([plus, [times, 3, 3], 1]),
  12   = prefix_value([plus, [times, 3, 3], [times, 3, 1]]),

  true = numbered(1),
  true = numbered([1, plus, 1]),
  true = numbered([1, times, 1]),
  true = numbered([1, times, [2, plus, 3]]),
  true = numbered([[2, plus, 2], times, [3, plus, 3]]),

  false = numbered([fubar]),
  false = numbered([1, plus]),
  false = numbered([1, times, dog]),

  ok.
