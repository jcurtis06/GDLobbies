extends Node2D

@onready var player_tscn: PackedScene = preload("res://demo/scenes/player.tscn")

func _on_start_pressed():
	if LobbyManager.is_host:
		if LobbyManager.debug:
			_start_game()
		else:
			_start_game.rpc_id(1)

@rpc("any_peer")
func _start_game():
	if !multiplayer.is_server():
		return
	
	for peer in multiplayer.get_peers():
		var player = player_tscn.instantiate()
		player.name = str(peer)
		add_child(player)
