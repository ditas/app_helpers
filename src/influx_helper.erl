%%%-------------------------------------------------------------------
%%% @author dmitryditas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Авг. 2018 13:41
%%%-------------------------------------------------------------------
-module(influx_helper).
-author("dmitryditas").

%% API
-export([
    store/3,
    store_fields/3
]).

store(MetricName, Tags, Value) ->
    TagsStr = proplist_to_str(Tags),
    URL = get_url(),
    Headers = headers(),
    httpc:request(post, {URL, Headers, "text-plain", atom_to_list(MetricName) ++ "," ++ TagsStr ++ " value=" ++ val_to_str(Value)}, [], []).

store_fields(MetricName, Tags, Fields) ->
    TagsStr = proplist_to_str(Tags),
    FieldsStr = proplist_to_str(Fields),
    URL = get_url(),
    Headers = headers(),
    case TagsStr of
        [] ->
            httpc:request(post, {URL, Headers, "text-plain", atom_to_list(MetricName) ++ " " ++ FieldsStr}, [], []);
        TagsStr ->
            httpc:request(post, {URL, Headers, "text-plain", atom_to_list(MetricName) ++ "," ++ TagsStr ++ " " ++ FieldsStr}, [], [])
    end.

get_url() ->
    {ok, {Host, Port}} = application:get_env(app_helpers, influxdb),
    {ok, InfluxDBName} = application:get_env(app_helpers, influxdb_name),
    "http://" ++ Host ++ ":" ++ integer_to_list(Port) ++ "/write?db=" ++ InfluxDBName.

proplist_to_str(Tags) ->
    proplist_to_str(Tags, []).

proplist_to_str([], Acc) ->
    Acc;
proplist_to_str([{K,V}], Acc) ->
    Acc ++ K ++ "=" ++ val_to_str(V);
proplist_to_str([{K,V}|T], Acc) ->
    proplist_to_str(T, Acc ++ K ++ "=" ++ val_to_str(V) ++ ",").

val_to_str(V) when is_integer(V) ->
    integer_to_list(V);
val_to_str(V) when is_float(V) ->
    float_to_list(V);
val_to_str(V) when is_atom(V) ->
    atom_to_list(V);
val_to_str(V) when is_binary(V) ->
    binary_to_list(V);
val_to_str(V) ->
    V.

headers() ->
    {ok, User} = application:get_env(app_helpers, influxdb_login),
    {ok, Pass} = application:get_env(app_helpers, influxdb_password),
    [auth_header(User, Pass), {"Content-Type", "text"}].

auth_header(User, Pass) ->
    Encoded = base64:encode_to_string(lists:append([User,":",Pass])),
    {"Authorization","Basic " ++ Encoded}.