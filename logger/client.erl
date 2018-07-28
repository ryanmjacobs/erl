#!/usr/bin/env escript
%%! -sname client

main([Msg]) ->
    erlang:set_cookie(node(), '123'),

    % connect to logger server
    case net_kernel:connect(logger@ucla) of
        false ->
            io:format("error: failed to connect to logger@ucla~n"),
            erlang:halt();
        true -> global:sync()
    end,

    % die after 10 seconds
    spawn(fun() ->
        timer:sleep(10 * 1000),
        global:send(logger, {count}),
        erlang:halt()
    end),

    % print count once a second
    spawn(fun() -> print_count() end),
    loop(Msg);

main(_) ->
    io:format("usage: client.erl <message>~n"),
    ok.

loop(Msg) ->
    % send message
    %io:format("Sending message: ~p~n", [Msg]),
    global:send(logger, {msg, Msg}),
    loop([Msg]).

print_count() ->
    global:send(logger, {count}),
    timer:sleep(500),
    print_count().
