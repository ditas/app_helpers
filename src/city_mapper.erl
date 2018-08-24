%%%-------------------------------------------------------------------
%%% @author dmitryditas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Авг. 2018 17:58
%%%-------------------------------------------------------------------
-module(city_mapper).
-author("dmitryditas").

%% API
-export([
    city/1,
    time_offset/1
]).

city(City) ->
    RootDir = os:getenv("PWD"),
    {ok, [CitiesList]} = file:consult(RootDir++"/priv/cities"),
    City1 = binary_to_list(City),
    case lists:keyfind(City1, 1, CitiesList) of
        {_, _, CityTrans, _} -> CityTrans;
        false -> City1
    end.

time_offset(City) ->
    RootDir = os:getenv("PWD"),
    {ok, [CitiesList]} = file:consult(RootDir++"/priv/cities"),
    City1 = binary_to_list(City),
    case lists:keyfind(City1, 1, CitiesList) of
        {_, _, _, TimeOffset} -> TimeOffset;
        false -> 0
    end.