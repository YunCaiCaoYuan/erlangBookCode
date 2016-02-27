-module(socket_examples).

-export([start_nano_server/0]).
-export([nano_client_eval/1]).

start_nano_server() ->
	{ok, Listen} = gen_tcp:listen(2345,[binary,{packet,4},{reuseaddr,true},{active,true}]),
	{ok, Socket} = gen_tcp:accept(Listen), 
	gen_tcp:close(Listen),
	loop(Socket).

loop(Socket) ->
	receive
		{tcp, Socket, Bin} ->
			io:format("Server receive binary = ~p~n",[Bin]),
			Str = binary_to_term(Bin),
			io:format("Server (unpacked) ~p~n",[Str]),
			Reply = string2Value(Str),
			io:format("Server replying = ~p~n",[Reply]),
			gen_tcp:send(Socket,term_to_binary(Reply)),
			loop(Socket);
		{tcp_closed, Socket} ->
			io:format("Server socket closed~n")
	end.
	
%% 一个客户端
nano_client_eval(Str) ->
	{ok,Socket} = gen_tcp:connect("localhost", 2345, [binary,{packet,4}]),
	ok = gen_tcp:send(Socket, term_to_binary(Str)),
	receive
		{tcp, Socket, Bin} ->
			io:format("Client received binary = ~p~n",[Bin]),
			Val = binary_to_term(Bin),
			io:format("Client result = ~p~n",[Val]),
			gen_tcp:close(Socket)
	end.

string2Value(Str) ->
    {ok, Tokens, _} = erl_scan:string(Str ++ "."),
	io:format("Tokens = ~p~n",[Tokens]),
    {ok, Exprs} = erl_parse:parse_exprs(Tokens),
    io:format("Exprs = ~p~n",[Exprs]),
    Bindings = erl_eval:new_bindings(),
    io:format("Bindings = ~p~n",[Bindings]),
    {value, Value, _} = erl_eval:exprs(Exprs, Bindings),
    Value.