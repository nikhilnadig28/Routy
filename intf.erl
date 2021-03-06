-module(intf).
-export([new/0, add/4, remove/2, lookup/2, ref/2, name/2, list/1, broadcast/2]).

%Returns an empty set of interfaces
new() ->
[].

%Adds new entry to the set and return the new set of interfaces.
add(Name, Ref, Pid, Intf) ->
[{Name, Ref, Pid}] ++ Intf.

%Removes the entry of the interface by the Name given.
remove(Name, Intf) ->
lists:keydelete(Name, 1, Intf).

%Find Pid and of the Name and return.
lookup(Name, Intf) ->
Tuple = lists:keyfind(Name, 1, Intf),
if
	 Tuple/= false ->
		X = element(3,Tuple),
		{ok, X};
	Tuple == false ->
	notfound
end.

%Find the Ref for the Name.

ref(Name, Intf) ->
Tuple = lists:keyfind(Name, 1, Intf),
if
	 Tuple/= false ->
		X = element(2,Tuple),
		{ok, X};
	Tuple == false ->
	notfound
end.

%Find name of given Ref
name(Ref, Intf) ->
	case lists:keysearch(Ref, 2, Intf) of
		            {value, Tuple} ->
							{ok,element(1,Tuple)};
					false->
							notfound
	end.

%Return list of all names
list(Intf) ->
[element(1,Names) || Names <- Intf].

%Send message to all interface processes 
broadcast(Message, Intf) ->
case Intf of
	[] ->
		ok;

	[{_, _, Pid} | T] ->
		Pid ! Message,
		broadcast(Message, T)
end.

