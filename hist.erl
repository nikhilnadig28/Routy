-module(hist).
-export([new/1, update/3]).

%Return new history, where messages from Name will always be seen as old.
new(Name) ->

%Check if N is from Node is old or new. If old, return old. Else, return {new, Updated} where Updated is the updated history.
update(Node, N, History) ->
