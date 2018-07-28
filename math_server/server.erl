#!/usr/bin/env escript
%%! -sname math_server

main(_) ->
    io:format("math_server running on ~p~n", [node()]),
    Server = spawn(fun() -> loop() end),
    erlang:monitor(process, Server),
    global:register_name(math_server, Server),

    receive
        {'DOWN', _, process, Pid, Reason} ->
            io:format("math_server crashed pid=~p reason:~n~n  ~p~n", [Pid,Reason]),
           %Server = spawn(fun() -> loop() end),
           %erlang:monitor(process, Server),
           %global:re_register_name(math_server, Server);
            main(nil); % rebooootttt
        Other -> io:format("~p~n", [Other])
    end.

loop() ->
    receive
        {From,add,X,Y} ->
            io:format("ADD ~p ~p~n", [X,Y]),
            From ! {result,X+Y}
    end,
    loop().
