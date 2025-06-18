extends Control

@onready var network_manager : NetworkManager = get_node("/root/Node3D/ExampleNetworkManager")

func _ready() -> void:
	network_manager.on_server_started.connect(_on_connected_to_server)
	$Host.pressed.connect(_host)
	$Refresh.pressed.connect(_open_lobby_list)

func _host():
	network_manager.networker.lobby_name = Steam.getPersonaName()
	network_manager._create_server()

func _on_connected_to_server():
	get_node("/root/Node3D/Menus/ColorSelectMenu").show()
	hide()

func _open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.requestLobbyList()
	

func _on_lobby_match_list(lobbies : Array):
	
	for lobby in lobbies:
		
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		
		var btn : Button = Button.new()
		btn.set_text("%s | Player Count: %s" % [lobby_name, memb_count])
		
		network_manager.networker.lobby_id = lobby
		
		btn.pressed.connect(network_manager._connect_client)
		
		$LobbyContainer/LobbiesList.add_child(btn)
