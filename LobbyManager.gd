extends Node

signal connection_completed
signal connection_failed

var debug = true
var debug_port = 8000

var current_lobby: String
var is_host: bool

var _request: HTTPRequest

## Attempts to create a new lobby
func begin_hosting():
	is_host = true
	
	if debug:
		ServerManager.create_server(debug_port)
		connection_completed.emit()
	else:
		_request = HTTPRequest.new()
		get_tree().root.add_child(_request)
		_request.request_completed.connect(_on_host_complete)
		
		_request.request(
			"http://" + ServerManager.manager_ip + ":" + ServerManager.manager_port
			+ "/create_room"
		)

## Attempts to join an existing lobby
func begin_joining(key: String = "00000000"):
	is_host = false
	
	if debug:
		_join(debug_port, "DEBUG")
	else:
		_request = HTTPRequest.new()
		get_tree().root.add_child(_request)
		_request.request_completed.connect(_on_join_complete)
		
		print(key)
		
		_request.request(
			"http://" + ServerManager.manager_ip + ":" + ServerManager.manager_port + "/join_room", 
			["Content-Type: application/json"], 
			HTTPClient.METHOD_POST, JSON.stringify({"key": key})
		)

func _join(port: int, key: String):
	print("Attempting to join game...")
	
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ServerManager.instances_ip, port)
	multiplayer.multiplayer_peer = peer
	
	# Handle connection failure
	multiplayer.connection_failed.connect(
		func():
			print("Failed to join game.")
			connection_failed.emit()
	)
	
	# Handle connection success
	multiplayer.connected_to_server.connect(
		func():
			connection_completed.emit()
			print("Welcome to " + key + " brave adventurer " + str(peer.get_unique_id()))
	)

## Handles host API call
func _on_host_complete(
	result:int ,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
):
	if response_code == 200:
		var json := JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error == OK:
			# No error, get the port of the server instance and the lobby key
			var port = json.data["port"]
			var key = json.data["key"]
			print("PORT: " + str(port))
			print("KEY: " + key)
			
			# Copy key to clipboard
			DisplayServer.clipboard_set(key)
			_join(port, key)
	else:
		connection_failed.emit()
		print("Failed to start server instance.")
	
	_request.queue_free()

## Handles join API call
func _on_join_complete(
	result:int ,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray
):
	if response_code == 200:
		var json := JSON.new()
		var error = json.parse(body.get_string_from_utf8())
		if error == OK:
			var port = json.data["port"]
			var key = json.data["key"]
			
			_join(port, key)
	else:
		connection_failed.emit()
		print("Failed to join room.")
	
	_request.queue_free()
