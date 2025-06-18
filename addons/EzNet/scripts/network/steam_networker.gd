extends Networker

@export var max_players : int = 4

var lobby_name : String
var lobby_type : SteamMultiplayerPeer.LobbyType = SteamMultiplayerPeer.LobbyType.LOBBY_TYPE_PUBLIC
var lobby_id : int

var peer : SteamMultiplayerPeer

signal on_lobby_created

func host() -> MultiplayerPeer:
	peer = SteamMultiplayerPeer.new()
	peer.lobby_created.connect(_on_lobby_created)
	var err : Error = peer.create_lobby(lobby_type, max_players)
	
	if err != OK:
		printerr("Could not initialize network host")
		return null
	
	return peer
	

func connect_client() -> MultiplayerPeer:
	peer = SteamMultiplayerPeer.new()
	var err : Error = peer.connect_lobby(lobby_id)
	
	if err != OK:
		printerr("Could not connect to lobby")
		return null
	
	return peer

func _on_lobby_created(connect : int, id : int):
	if connect == Steam.Result.RESULT_OK:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", lobby_name)
		Steam.setLobbyJoinable(lobby_id, true)
		on_lobby_created.emit()
