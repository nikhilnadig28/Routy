-module(dijkstra).
-export([entry/2, replace/4, update/4, iterate/3]).


entry(Node, Sorted) ->
% Returns the length of the shortest path to the node
Status = lists:keyfind(Node, 1, Sorted),
if
	 Status /= false -> 
	{Node,X,_} = lists:keyfind(Node, 1, Sorted),
	X;
	Status == false -> 0
end.


replace(Node, N, Gateway, Sorted) ->
lists:keysort(2,lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway})).

update(Node, N, Gateway, Sorted) ->
Len = entry(Node, Sorted),
if
	Len > N ->
	replace(Node, N, Gateway, Sorted);
	Len =< N ->
	Sorted;
	true -> []
end.


iterate(Sorted, Map, Table) ->
%if there are no entires in the sortes list, we are done and the routing table is complete.
if
	length(Sorted) == 0 ->
	Table;

%if the first entry is a dummy with an infinite path to a city we know the rest of the sorted list is also of infinite length and the routing table is complete
	element(2,hd(Sorted)) == inf -> 
	Table;

%else, take the first entry in the sorted list, find reachable nodes for this entry, update the sorted list

	true ->
		NodeOfFirst = element(1,hd(Sorted)),
		ReachableNodes = lists:flatten(map:reachable(NodeOfFirst, Map)),
		lists:append([{NodeOfFirst, hd(ReachableNodes)}, Table])


end
