-module(map).
-export([new/0, update/3, reachable/2, all_nodes/1]).
% , reachable/2, all_nodes/1
new() ->
[].

update(Node, Links, Map) ->
if
	Map -> [{Node, [Links]}];
true -> [{Node, Links}] end.

reachable(Node, Map) ->
[ X || {_, X} <- [lists:keyfind(Node, 1, Map)]]. %Checks if the Node passed is a key-value pair in Map, if yes, returns the value part of the pair.

all_nodes(Map) ->
% lists:flatten(lists:foldl(fun(X, Y) -> [X]++[Y] end,[], Map)). %HOW TO REMOVE EXCESS BRACKETS?
{List1, List2} = lists:unzip(Map),
Append = lists:append(List2),
Merge = lists:umerge(List1, Append),
% Set = sets:from_list(Merge),
lists:usort(Merge).
