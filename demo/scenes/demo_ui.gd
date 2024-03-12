extends Control

@onready var code: LineEdit = $VBoxContainer/HBoxContainer/Code
@onready var start: Button = $VBoxContainer/Start
@onready var host: Button = $VBoxContainer/Host
@onready var join: Button = $VBoxContainer/HBoxContainer/Join

func _on_host_pressed():
	LobbyManager.begin_hosting()
	
	host.disabled = true
	join.disabled = true
	
	LobbyManager.connection_completed.connect(
		func():
			start.disabled = false
			print("done")
	)
	
	LobbyManager.connection_failed.connect(
		func():
			host.disabled = false
			join.disabled = false
			start.disabled = true
	)

func _on_join_pressed():
	LobbyManager.begin_joining(code.text)
	
	host.disabled = true
	join.disabled = true
	
	LobbyManager.connection_failed.connect(
		func():
			host.disabled = false
			join.disabled = false
			start.disabled = true
	)

func _on_start_pressed():
	if LobbyManager.is_host:
		_switch_to_game.rpc()

@rpc("any_peer", "call_local", "reliable")
func _switch_to_game():
	visible = false
