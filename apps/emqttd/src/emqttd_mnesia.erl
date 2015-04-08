%%%-----------------------------------------------------------------------------
%%% @Copyright (C) 2012-2015, Feng Lee <feng@emqtt.io>
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in all
%%% copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%%% SOFTWARE.
%%%-----------------------------------------------------------------------------
%%% @doc
%%% emqttd mnesia.
%%%
%%% @end
%%%-----------------------------------------------------------------------------
-module(emqttd_mnesia).

-author('feng@emqtt.io').

-include("emqttd.hrl").

-export([init/0, wait/0]).

init() ->
    case mnesia:system_info(extra_db_nodes) of
        [] -> 
            mnesia:stop(),
            mnesia:create_schema([node()]);
        _ -> 
            ok
    end,
    ok = mnesia:start(),
    create_tables().

create_tables() ->
	mnesia:create_table(mqtt_retained, [
                        {type, ordered_set},
                        {ram_copies, [node()]},
                        {attributes, record_info(fields, mqtt_retained)}]),
    mnesia:add_table_copy(mqtt_retained, node(), ram_copies).

wait() ->
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity).

