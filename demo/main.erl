#!/usr/bin/env escript

main(_) ->
    true = code:add_path("lib"),

    X = 2,
    Y = 5,
    Pid1 = spawn(fun() -> sleeper:sleep() end),
    Pid2 = spawn(fun() -> sleeper:sleep() end),
    Pid3 = spawn(fun() -> sleeper:sleep() end),

    Me = self(),
    Pid4 = spawn(fun() -> sleeper:sleep(), Me ! done end),

    Me ! done,

    io:format("~p + ~p = ~p~n", [X,Y,mather:add(X,Y)]),
    io:format("pids: ~p~n", [[Pid1,Pid2,Pid3,Pid4]]),

    Recv = spawn(fun() ->
        receive
            Z -> io:format("recv: ~p~n", [Z])
        end
    end),

    io:format("~p~n", [Recv]),
    Recv ! done,
    sleeper:sleep(),
    ok.
