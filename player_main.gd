extends Node2D

@export var data:PlayerData = PlayerData.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if "position" in data:
		data.position = $CharacterBody2D.position
	if "rotation" in data:
		data.rotation = $CharacterBody2D/AnimatedSprite2D.flip_h

func savegame():
	var data = {
		"filename" : get_scene_file_path(),
		"parent" : get_path(),
		"x" : $CharacterBody2D.position.x,
		"y" : $CharacterBody2D.position.y,
	}
	return data

func loadgame():
	data = load("user://player.tres")
	
	if "position" in data:
		$CharacterBody2D.position = data.position
	if "rotation" in data:
		$CharacterBody2D/AnimatedSprite2D.set_flip_h(data.rotation)
