-module(bin).
-compile(export_all).

%% exercise 1
byte_reverse(Bytes) ->
  list_to_binary( lists:reverse([ X || <<X:8>> <= Bytes ]) ).

%% ex1 w/ accumulator
br(Bytes) -> br(Bytes, []).

  %% why is /binary needed here? isn't it redundant?
br(<<>>, Acc) -> list_to_binary(Acc);
br(<<H:1/binary, Rest/binary>>, Acc) ->
  br(Rest, [H|Acc]).

%% exercise 2 & 3
term_to_packet(Term) ->
  Bin = term_to_binary(Term),
  Size = bit_size(Bin),
  <<Size:4, Bin/binary>>.

%%% not using the header/size here...because nothing comes after,
%%% the size isn't needed. Is size even a good header anyway?
%%% when is it needed? are there better seperators via pattern matching?
packet_to_term(<<_:4, Bin/bitstring>>) ->
  binary_to_term(Bin).

%% exercise 4
bit_reverse(Bits) ->
  list_to_binary( lists:reverse([ X || <<X:1>> <= Bits ]) ).

%%% the /binary & /bistring shit was the tricky part in getting this.
hello(<<Size:16, Name:Size/bitstring>>) ->
  binary_to_term(Name).

hello1(<<Size:16, Name:Size/binary>>) ->
  Name.

hello2(<<Size:16, Name:Size>>) ->
  Name.

go(<<NameSize:16,
     Name:NameSize/bitstring,
     FunSize:64,
     Fun:FunSize/bitstring>>) ->
  { binary_to_term(Name), (binary_to_term(Fun))() }.

%%% Question? What other seperators can I use to pattern match against?
go2(<<NameSize:16,
     Name:NameSize/bitstring,
     FunSize:16,
     Fun:FunSize/bitstring,
     ArgSize:8,
     Arg:ArgSize/bitstring>>) ->
  N = binary_to_term(Name),
  F = binary_to_term(Fun),
  A = binary_to_term(Arg),
  {ok, N, F(A)}.

test() ->
  Jim     = term_to_binary(jim),
  JimSize = bit_size(Jim),
  Message = <<JimSize:16, Jim/binary>>,
  jim = hello(Message),

  %%% hello1(Message) will blow up because it doesn't match
  %%% hello2(Message) == 36983173169178989

  Fun = term_to_binary(fun() -> 42 end),
  FunSize = bit_size(Fun),

  Message2 = <<JimSize:16, Jim/binary, FunSize:64, Fun/binary>>,
  {jim, 42} = go(Message2),

  Arg = term_to_binary(3),
  ArgSize = bit_size(Arg),

  NewFun = term_to_binary(fun(Z) -> Z * 23 end),
  NewFunSize = bit_size(NewFun),

  Message3 = <<JimSize:16, Jim/binary,
               NewFunSize:16, NewFun/binary,
               ArgSize:8,  Arg/binary>>,

  <<4,3,2,1>> = byte_reverse(<<1,2,3,4>>),
  <<4,3,2,1>> = br(<<1,2,3,4>>),

  {ok, jim, 69} = go2(Message3),

  Nora = term_to_packet(nora),
  nora = packet_to_term(Nora),

  F = term_to_packet(fun(X) -> X*11 end),
  77 = (packet_to_term(F))(7),

  Bits = <<2#11110000>>,
  <<0,0,0,0,1,1,1,1>> = bit_reverse(Bits),

  ok.
