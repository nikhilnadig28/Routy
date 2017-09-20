-module(hist).
-export([new/1, update/3]).

%Return new history, where messages from Name will always be seen as old.
new(Name) ->
	[{Name, 0}].

%Check if N is from Node is old or new. If old, return old. Else, return {new, Updated} where Updated is the updated history.
update(Node, N, History) ->
  case lists:keysearch(Node, 1, History) of
    {value , Tuple} ->
      if
        N > element(2,Tuple) ->
          Temp = lists:keydelete(Node, 1, History),
		  {new,lists:append([{Node,N}], Temp)};
        true -> old
      end;
    false ->
      {new, new(Node)  ++ History}
  end.


