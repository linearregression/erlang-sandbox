-module(ch12).
-compile(export_all).

start(N, M) when N > 0; M > 0 ->
  Pid = loop(N),
  Pid ! {Pid, M},
  Pid.

loop(1) ->
  spawn(
    fun F() ->
        receive
          {_, 1} ->
            io:format("Done.~n");
          {Home, M} ->
            Home ! {Home, M-1},
            F()
        end
    end
  );

loop(N) ->
  Next = loop(N-1),
  spawn(
    fun F() ->
        receive
          {Home, 1} ->
            Next ! {Home, 1};
          {Home, M}  ->
            Next ! {Home, M},
            F()
        end
    end
  ).
