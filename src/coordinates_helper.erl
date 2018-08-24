%%%-------------------------------------------------------------------
%%% @author dmitryditas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Авг. 2018 18:05
%%%-------------------------------------------------------------------
-module(coordinates_helper).
-author("dmitryditas").

-define(RADIUS, 6371000).

%% API
-export([
    convert/2,
    is_in_area/3
]).

convert(Lat, Lon) ->
    X = ?RADIUS * math:cos(Lat) * math:cos(Lon),
    Y = ?RADIUS * math:cos(Lat) * math:sin(Lon),
    {X, Y}.

is_in_area(LeftLowerCorner, RightUpperCorner, Point) ->
    {Lat1, Lon1} = LeftLowerCorner,
    {Lat2, Lon2} = RightUpperCorner,
    {Lat, Lon} = Point,
    case Lat >= Lat1 of
        true when Lat =< Lat2 andalso Lon >= Lon1 andalso Lon =< Lon2 -> true;
        _ -> false
    end.