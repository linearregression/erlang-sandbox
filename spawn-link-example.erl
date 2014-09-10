-module(lesson).
-export([start/0]).

start() ->
  spawn(fun() -> parent() end).

parent() ->
  Parent = self(),
  [spawn_link(
      fun() -> child(Parent, Name, Didjob) end
   ) || {Name, Didjob} <- [{"Jim", true},
                           {"Jon", false},
                           {"Phil", false},
                           {"Nora", true}]],
  wait_for_kids().

wait_for_kids() ->
  receive
    {cleaned_room, N} ->
      io:format("You're a good kid, ~s.~n", [N]),
      wait_for_kids();
    {played_video_games, N} ->
      io:format("Dammnit, ~s!~n", [N]),
      wait_for_kids()
  after 10000 ->
      io:format("Guess that's the last of 'em.~n")
  end.

child(Parent,Name,true) ->
  receive
  after 500 ->
      Parent ! {cleaned_room, Name}
  end;
child(Parent,Name,false) ->
  receive
  after 500 ->
      Parent ! {played_video_games, Name}
  end.
