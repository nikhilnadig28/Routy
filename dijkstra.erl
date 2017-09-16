-module(dijkstra).
-export([entry/2, replace/4]).


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
lists:usort(lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway})).