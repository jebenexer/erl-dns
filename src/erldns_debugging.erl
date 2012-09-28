-module(erldns_debugging).

-export([start/0]).

-define(MIN_PROCESS_COUNT, 500).

start() ->
  timer:start(),
  ets:new(precrash_process_info, [set, named_table]),
  spawn(fun() -> loop() end),
  ok.

loop() ->
  loop(1).

loop(IterationNumber) ->
  lager:info("Iteration ~p (processes: ~p)", [IterationNumber, length(erlang:processes())]),
  case length(erlang:processes()) of
    N when N > ?MIN_PROCESS_COUNT -> ets:insert(precrash_process_info, {length(erlang:processes()), [lists:map(fun erlang:process_info/1, erlang:processes())]});
    _ -> ok
  end,
  timer:sleep(10000),
  loop(IterationNumber + 1).