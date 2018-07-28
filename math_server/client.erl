#!/usr/bin/env escript
%%! -sname math_server_client

main([X,Y]) ->
    case net_kernel:connect(math_server@delta) of
        false -> io:format("error: failed to connect to math_server~n"), erlang:halt();
        true ->
            % timeout
            spawn(fun() ->
                timer:sleep(1000),
                io:format("error: timeout 1000ms~n"),
                erlang:halt()
            end),

            global:sync(),
            global:send(math_server,
                {self(), add, list_to_integer(X), list_to_integer(Y)}
               %{self(), add, X, list_to_integer(Y)}
            ),
            receive
                {result,Result} -> io:format("result = ~p~n", [Result])
            end
    end;

main(_) -> io:fwrite("usage: client.erl <X> <Y>~n").
