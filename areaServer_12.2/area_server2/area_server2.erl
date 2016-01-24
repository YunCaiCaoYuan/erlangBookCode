-module(area_server2).
-export([loop/0, rpc/2]).

rpc(Pid, Request) ->
	% io:format("self() = ~p~n", [self()]),

	Pid ! {self(), Request},
	receive
		{Pid, Response} ->
			Response
	end.

loop() ->
	receive
		{From, {rectangle, Width, Ht}} ->
			% io:format("self() = ~p~n", [self()]),
			% io:format("From = ~p~n", [From]),

			From ! {self(), Width * Ht},
			loop();
		{From, {circle, R}} ->
			% io:format("self() = ~p~n", [self()]),
			% io:format("From = ~p~n", [From]),
			
			From ! {self(), 3.14159 * R * R},
			loop();
		{From, Other} ->
			% io:format("self() = ~p~n", [self()]),
			% io:format("From = ~p~n", [From]),

			From ! {self(), {error, Other}},
			loop()
	end.