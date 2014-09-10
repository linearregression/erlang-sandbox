-module(sock1).
-compile(export_all).

% connect
% send
% accept
% listen

dget() -> dget("www.google.com").

dget(Domain) -> 
  {ok, Socket} = gen_tcp:connect(Domain, 80, [binary, {packet, 0}]),
  gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
  rec(Socket, []).

rec(Sock, Acc) ->
  receive
    {tcp, Sock, Bin} ->
      rec(Sock, [Bin|Acc]);
    {tcp_closed, Sock} ->
      list_to_binary(lists:reverse(Acc))
  end.

start_nano_server() ->
      {ok, Listen} = gen_tcp:listen(2345, [binary, {packet, 4},  %% (6)
                                                     {reuseaddr, true},
                                                     {active, true}]),
      {ok, Socket} = gen_tcp:accept(Listen),  %% (7)
      gen_tcp:close(Listen),  %% (8)
      loop(Socket).
loop(Socket) ->
      receive
      {tcp, Socket, Bin} ->
            io:format("Server received binary = ~p~n",[Bin]),
            Str = binary_to_term(Bin),  %% (9)
            io:format("Server (unpacked)  ~p~n",[Str]),
            gen_tcp:send(Socket, term_to_binary(ok)),  %% (11)
            loop(Socket);
      {tcp_closed, Socket} ->
            io:format("Server socket closed~n")
          end.
