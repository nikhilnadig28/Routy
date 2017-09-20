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
    
%if there are no entires in the sortes list, we are done and the routing table is complete.
%case Sorted of
	% length(Sorted) == 0 ->
%	[] ->
%		Table;

%if the first entry is a dummy with an infinite path to a city we know the rest of the sorted list is also of infinite length and the routing table is complete
	% element(2,hd(Sorted)) == inf -> 
%	[{_,inf,_}|_] ->
%		Table;

%else, take the first entry in the sorted list, find reachable nodes for this entry, update the sorted list

%	[H|T] ->
%		{Node, N, Gateway} = H,

		%case map:reachable(Node, Map) of
		%	[] ->
		%		iterate(T, Map, {Node, Gateway} ++ Table);

		%	ReachableNodes -> 
				%NewList = lists:foldl(fun(Element, SortedList) ->
				 %update(Element, N + 1, Gateway, SortedList)
				 %end, T, ReachableNodes),
				%iterate(NewList, Map, {Node, Gateway} ++ Table)
		%end

		% NodeOfFirst = element(1,hd(Sorted)),
		% ReachableNodes = lists:flatten(map:reachable(Node, Map)),
	%This needs to be iterated through all the elements in ReachableNodes	
		% lists:append([{NodeOfFirst, hd(ReachableNodes)}, Table])
%This entire function needs to be iterated through the Sorted List till it is empty.
%end.

table(Gateways, Map) ->
	%Nodes = map:all_nodes(Map),
	%Sorted = initSortedList(Nodes,[],Gateways),
	%iterate(Sorted,Map,[]).
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
    %now try this one nikhil. YEAH


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


% table(Gateways, Map) -> 
% 	AllNodes = map:all_nodes(Map),
%     InitialList = lists:keysort(2, lists:map(fun(Element) ->
%                                               case lists:member(Element, Gateways) of
%                                                   true ->
%                                                       {Element,0,Element};
                                  
%                                                   false ->
%                                                       {Element,inf,unknown}
%                                               end
%                                               end, AllNodes)),
%     iterate(InitialList, Map, []).


route(Node, Table) ->
	case lists:keysearch(Node, 1, Table) of
		{value, {_,Gateway}} ->
			{ok, Gateway};
		false ->
			notfound
	end.
