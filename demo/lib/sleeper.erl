-module(sleeper).
-export([sleep/0, sleep/1]).

sleep() -> timer:sleep(1000).
sleep(X) -> timer:sleep(X*1000).
