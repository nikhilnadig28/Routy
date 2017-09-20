-module(dijkstra).
-export([entry/2, replace/4, update/4, iterate/3, table/2, route/2]).


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
    case Sorted of
        [] -> Table ;
        [{_,inf,_}|_] -> Table ;
        [{Node,Dist,Gateway}|T] ->
            Sorted_ = lists:foldl(
                fun(N, S)->update(N, Dist+1, Gateway, S) end, 
                T,
                map:reachable(Node, Map)
            ),
            iterate(Sorted_,Map,[{Node,Gateway}|Table])

    end.

table(Gateways, Map) ->
	Non_gateway_nodes = lists:map(
       fun(N) -> {N,inf,unknown} end,
       lists:filter(
        	fun(N) -> not lists:member(N,Gateways) end,
            map:all_nodes(Map)
        )
    ),
    Gateway_nodes = lists:map(
        fun(N) -> {N,0,N} end,
        Gateways
    ),
    iterate(Gateway_nodes ++ Non_gateway_nodes, Map, []).
    
initSortedList(List,NewList,Gateways)->
	case List of
		[]->
			lists:keysort(2, NewList);
		[H|T] ->
			case lists:member(H,Gateways) of 
				true ->
					initSortedList(T,[{H,0,H}] ++ NewList,Gateways);
				false->
					initSortedList(T,[{H,inf,unknown}]++NewList,Gateways)
			end
	end.

route(Node, Table) ->
	case lists:keysearch(Node, 1, Table) of
		{value, {_,Gateway}} ->
			{ok, Gateway};
		false ->
			notfound
	end.
