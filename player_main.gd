extends Node2D

@export var player_data:PlayerData = PlayerData.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if "position" in player_data:
		player_data.position = $CharacterBody2D.position
	if "rotation" in player_data:
		player_data.rotation = $CharacterBody2D/AnimatedSprite2D.flip_h

func savegame():
	var data = {
		"filename" : get_scene_file_path(),
		"parent" : get_path(),
		"x" : $CharacterBody2D.position.x,
		"y" : $CharacterBody2D.position.y,
	}
	return data

func loadgame():
	player_data = load("user://player.tres")
	
	if "position" in player_data:
		$CharacterBody2D.position = player_data.position
	if "rotation" in player_data:
		$CharacterBody2D/AnimatedSprite2D.set_flip_h(player_data.rotation)
	
	print("Load successful. (Player Data)")
