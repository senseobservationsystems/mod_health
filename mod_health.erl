%%% ---------------------------------------
%%% Chris Conley
%%% ---------------------------------------

-module(mod_health).

-export([
	process/2
]).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("ejabberd_http.hrl").


% application constants
% -define(MNESIA, mnesia).
-define(MYSQL, mysql).
-define(EJABBERD, ejabberd).
-define(SSL, ssl).
-define(CRYPTO, crypto).
%% add additional applications


process(Path, #request{method = 'GET'} ) ->
	[InnerPath] = Path,
	LPath = string:to_lower(binary_to_list(InnerPath)),
	case LPath of
		"status" ->
			check_health();
		_ ->
			bad_path_response(LPath)
	end;

process(_Path, _Request) ->
	jsx:encode([{<<"error">>,<<"Invalid Path">>}]).

check_health() ->
	jsx:encode([
			{<<"ejabberd">>, get_status(?EJABBERD)},
			% {<<"mnesia">>, get_status(?MNESIA)},
			{<<"mysql">>, get_status(?MYSQL)},
			{<<"crypto">>, get_status(?CRYPTO)},
			{<<"ssl">>, get_status(?SSL)}
			% add addutional applications to check
	]).


get_status(Application) ->
	Status = lists:keymember(Application, 1, application:which_applications()),
	atom_to_binary(Status, utf8).


bad_path_response(LPath) ->
	Error = erlang:iolist_to_binary([<<"Invalid Path: ">>, LPath]),
	jsx:encode([{<<"error">>,Error}]).
