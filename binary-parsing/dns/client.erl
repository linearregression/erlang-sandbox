-module(client).
-compile(export_all).

%% Request
%% ID     - each request should have a unique ID (16 bits)   <ID:16>
%% QR     - query or response (1 bit)                        <0:1> - query
%% OPCODE - (4 bits)                                         <0:4> - standard
%% AA     - not meaningful for query (1 bit)                 <0:1>
%% TC     - not truncated (aka not error?) (1 bit)           <0:1> - no tc
%% RD     - recursion requested (1 bit)                      <1:1> - use rec
%% RA     - not meaningful for query (1 bit)                 <0:1>
%% Z      - "reserved for the future" - (3 bits)             <0:3>
%% RCODE  - not meaningful for query (4 bits)                <0:4>
%%
%% QDCOUNT - number of queries  ex: <1:16>, 1 question
%% ANCOUNT - num answers            <0:16>
%% NSCOUNT - num nameservers        <0:16>
%% ARCOUNT - num additional records <0:16>
%%
%% num first token in bytes : (8 bits)
%% first token
%% num second token in bytes : (8 bits)
%% second token
%% etc
%%
%% END of data <0:8>
%%
%% QTYPE  - A(16#0001) / host address (16 bits) ex: <1:16>
%% QCLASS - IN "internet" (CS, CH, H*) (16 bits) ex: <1:16>

query(Query) ->
    {ok, Socket} = gen_udp:open(0, [binary]),
    io:format("client opened socket=~p~n",[Socket]),
    ok = gen_udp:send(Socket, "192.168.1.1", 53, build_query(Query)), 
    Answers = receive_answers(Socket),
    gen_udp:close(Socket),
    process_answers(Answers).

process_answers(<<_Id:16, _Flags:16, _Q:16, An:16, 
                  _Au:16, _Ad:16, _Rest/bits>>) ->
  An.

receive_answers(Socket) ->
  io:format("socket: ~p~n", [Socket]),
  receive
    {udp, Socket, _, _, Bin} ->
      Bin
  after 2000 ->
    error
  end.

build_query(Query) ->
  <<(header())/binary, (data(Query))/binary>>.

header() ->
  <<1:16, 0:1, 0:4, 0:1, 0:1, 1:1, 0:8, 1:16, 0:16, 0:16, 0:16>>.

data(Query) ->
  QuestionData = list_to_binary(prep_query(Query)),
  <<QuestionData/bitstring, 0:8, 1:16, 1:16>>.  

prep_query(Query) ->
  [prep_token(T) || T <- string:tokens(Query, ".")].

prep_token(T) ->
  Bin = list_to_binary(T),
  <<(byte_size(Bin)):8, Bin/bitstring>>.
