extends Node

var manager_ip: String = "127.0.0.1"
var manager_port: String = "25565"

var instances_ip: String = "127.0.0.1"

var room_state = 0
var room_key: String = ""

func _ready() -> void:
	# Read arguments that the server started with
	var arguments := {}
	for argument in OS.get_cmdline_args():
		if argument.find("=") > -1:
			var key_value := argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
		else:
			arguments[argument.lstrip("--")] = ""
	
	# Get the port that the server should be started on
	if arguments.has("port"):
		create_server(int(arguments["port"]))
	
	# Get the room key that is required to login
	if arguments.has("key"):
		room_key = arguments["key"]

func create_server(port: int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	print("Created server on port " + str(port))
	
	multiplayer.peer_connected.connect(
		func(pid: int) -> void:
			print(str(pid) + " has joined!")
	)
	
	# Listen for disconnections
	multiplayer.peer_disconnected.connect(
		func(pid: int) -> void:
			# Destroy the player's node if in game
			if room_state == 1:
				if has_node(str(pid)):
					get_node(str(pid)).queue_free()
			
			# Quit the server if lobby is empty
			if multiplayer.get_peers().size() == 0:
				get_tree().quit()
	)
