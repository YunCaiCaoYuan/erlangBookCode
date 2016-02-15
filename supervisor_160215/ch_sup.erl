-module(ch_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link(ch_sup, []).

init(_Args) ->

	SupFlag = {one_for_one, 1, 60},
	ChildSpecList = [{
		ch3,
		{ch3, start_link, []},
		permanent,
		brutal_kill,
		worker,
		[ch3]
	}],

	{ok, {SupFlag, ChildSpecList}}.