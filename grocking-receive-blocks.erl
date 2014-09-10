-module(mrb).
-compile(export_all).

%% receive block priority in a single process:
%% C, B1, B2, (would be A, but B2 isn't calling back,
%% so we end up waiting in a's receive block.
%%
%% The larger lesson here is that this an example of where a function
%% has a receive block, but it's not immediately clear how the caller
%% knows its pid to reach it. 
%%
%% The secret is that self() gets called somewhere else on the callstack,
%% (i.e another function), but self() is global. messages sent to S=self()
%% will find their way back to the receive block. If there are multiple
%% blocks then that can work too - they just need to be relayed.

a() ->
  b(),
  receive
    M ->
      io:format("A: ~p~n", [M])
  after 3000 ->
      io:format("B needs to call me. Dag.~n")
  end.

b() ->
  c(),
  receive
    M ->
      io:format("B1: ~p~n", [M]),
      self() ! ok
  end,
  receive
    M1 ->
      io:format("B2: ~p~n", [M1])
  end.

c() ->
  S = self(),
  spawn(fun() -> d(S) end),
  receive
    M ->
      io:format("C: ~p~n", [M]),
      self() ! ok
  end.

d(P) ->
  P ! ok.
