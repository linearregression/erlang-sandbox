-module(ch13).
-compile(export_all).

% Write a function my_spawn(Mod, Func, Args) that behaves like 
% spawn(Mod, Func, Args) but with one difference. If the spawned 
% process dies, a message should be printed saying why the process 
% died and how long the process lived for before it died.
ms1(Mod, Fun, Args) ->
  {Pid, Ref} = spawn_monitor(Mod, Fun, Args),
  receive
    {'DOWN', Ref, process, Pid, Why} -> 
      io:format("I died becuz: ~p.~n", [Why])
  end.

derp(N) ->
  receive
  after 5000 ->
    1/N
  end.

% Solve the previous exercise using the on_exit function shown earlier 
% in this chapter.
% ?

% Write a function my_spawn(Mod, Func, Args, Time) that behaves 
% like spawn(Mod, Func, Args) but with one difference. If the 
% spawned process lives for more than Time seconds, it should be killed.
ms3(Mod, Fun, Args, Time) ->
  Pid = spawn(Mod, Fun, Args),
  receive
  after Time * 1000 ->
      io:format("taking too long. killing this mofo..~n"),
      exit(Pid, because),
      ok
  end.

sleep(N) ->
  receive
  after N * 1000 ->
      true
  end.

% Write a function that creates a registered process that writes 
% out "I'm still running" every five seconds. Write a function that 
% monitors this process and restarts it if it dies. Start the global 
% process and the monitor process. Kill the global process and check 
% that it has been restarted by the monitor process.
noisy() ->
  noisy(1).

noisy(N) ->
  receive
  after 5000 ->
      io:format("I am dude numero ~p.~n", [N]),
      noisy(N)
  end.

start() ->
  keep_alive(derp, fun ?MODULE:noisy/0).

on_exit(Pid, Fun) ->
  spawn(fun() ->
                 Ref = monitor(process, Pid),
                 receive
                   {'DOWN', Ref, process, Pid, Why} ->
                     Fun(Why)
                 end
    end).

kill(Name) ->
  io:format("killing that mofo...~n"),
  exit(whereis(Name), justbecause),
  ok.

keep_alive(Name, Fun) ->
  register(Name, Pid = spawn(Fun)),
  on_exit(Pid, fun(_Why) -> 
        sleep(20),
        io:format("ONE. MORE. TIME!!!~n"),
        keep_alive(Name, Fun) 
    end).

% Write a function that starts and monitors several worker processes. 
% If any of the worker processes dies abnormally, restart it.
keep_alive(Name, Module, Fun, Arg) ->
  register(Name, Pid = spawn(Module, Fun, Arg)),
  on_exit(Pid, fun(_Why) -> 
        sleep(20),
        io:format("ONE. MORE. TIME!!!~n"),
        keep_alive(Name, Module, Fun, Arg) 
    end).

ex5() ->
  [keep_alive(Name, ?MODULE, noisy, [I])
   || {I, Name} <- lists:zip(
                     lists:seq(3,1,-1), 
                     [billy, joe, bob]
                   )
  ].

% Write a function that starts and monitors several worker processes. 
% If any of the worker processes dies abnormally, kill all the worker 
% processes and restart them all.
%
% not working. :/
linked_keep_alive(Name, Module, Fun, Arg) ->
  register(Name, Pid = spawn_link(Module, Fun, Arg)),
  on_exit(Pid, fun(_Why) -> 
        sleep(20),
        io:format("ONE. MORE. TIME!!!~n"),
        linked_keep_alive(Name, Module, Fun, Arg) 
    end).

ex6() ->
  [linked_keep_alive(Name, ?MODULE, noisy, [I])
   || {I, Name} <- lists:zip(
                     lists:seq(3,1,-1), 
                     [billy, joe, bob]
                   )
  ].
