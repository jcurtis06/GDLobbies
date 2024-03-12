extends CharacterBody2D

@export var speed = 400

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer

func _enter_tree():
	set_multiplayer_authority(int(str(name)))

func get_input():
	if !is_multiplayer_authority():
		return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
