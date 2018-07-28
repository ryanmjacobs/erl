#!/usr/bin/env escript
%%! -sname logger

main(_) ->
    erlang:set_cookie(node(), '123'),

    io:fwrite("starting logger (~p)~n", [node()]),
    Me = self(),
    global:register_name(logger, spawn(fun() -> loop(Me, 0) end)),

    receive
        {exit, Reason} ->
            io:format("exiting because of reason: ~p~n", [Reason])
    end.

loop(Owner, Count) ->
    receive
       %{msg, Msg} -> io:format("received message: ~p~n", [Msg]);
       %{msg, Msg} -> io:format("~p~n", [Msg]);
        {msg, Msg} -> ok;
        {count} -> io:format("count: ~p~n", [Count]);
        {exit, Reason} -> Owner ! {exit, Reason}
    end,
    loop(Owner, Count+1).
