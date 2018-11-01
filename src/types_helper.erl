%%%-------------------------------------------------------------------
%%% @author dmitryditas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Окт. 2018 8:28
%%%-------------------------------------------------------------------
-module(types_helper).
-author("dmitryditas").

%% API
-export([
    val_to_list/1
]).

val_to_list(Val) when is_float(Val) ->
    float_to_list(Val);
val_to_list(Val) when is_integer(Val) ->
    integer_to_list(Val);
val_to_list(Val) when is_binary(Val) ->
    binary_to_list(Val);
val_to_list(Val) ->
    Val.