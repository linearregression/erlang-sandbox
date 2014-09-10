-module(spawn_link_example).
-compile(export_all).

%% hmm. this isn't working for me. i want to get a group of processes
%% where if one dies, they all go down. can't do it. why?
%%
%% as well, changing things to -export([]) causes some visibility problems
%% internally. if i care about a module, i should probably start that
%% way (and maybe with specs) instead of with the lazy export_all.
%%
%% UPDATE: added the lines `receive after infinity -> true` to main
%% and it works now. Perhaps the process that calls spawn_link has to
%% stick around for this behavior to work. If it exits 'normally' does
%% this whole link thing fall on it's head?
%%
%% is_process_alive(M) is a good helper for determining what you've got.

start() ->
  spawn(?MODULE, main, [workers()]).

main(Fs) ->
  [register(N, spawn_link(F)) || [N, F] <- Fs],
  receive 
  after infinity -> 
      true
  end.

worker(N,T) ->
  receive
  after T*1000 ->
      io:format("~p.~n", [N]),
      worker(N,T)
  end.

workers() ->
  [
    [N, fun() -> worker(N,T) end] 
    ||
    {T,N} <- [ {3,billy},{2,joe},{4,jim} ]
  ].

kill(N) ->
  exit(whereis(N), because).
