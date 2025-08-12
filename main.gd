extends Node2D

var save_player := "user://player.tres"
var save_level := "user://level.tres"
@onready var Player:Node = $player
@onready var Level:Node = $level

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save_game()
	
	if Input.is_action_just_pressed("load"):
		load_game()

func save_game():
	ResourceSaver.save(Player.player_data, save_player)
	ResourceSaver.save(Level.level_data, save_level)

func load_game():
	var player_data = load(save_player)
	
	if "position" in player_data:
		$player/CharacterBody2D.position = player_data.position
	if "rotation" in player_data:
		$player/CharacterBody2D/AnimatedSprite2D.set_flip_h(player_data.rotation)
	
	print("Load successful. (Player Data)")
	
	var level_data = load("user://level.tres")
	
	if "button_map" in level_data:
		print(level_data.button_map)
		for i in len(level_data.button_map):
			if $level/btns/button.get_cell_atlas_coords(level_data.button_map[i]) \
				in [Vector2i(2, 3)]:
				if level_data.button_map[i] in $level.permaCells:
					$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 2))
					$level.permaButtons[i] = 0
				elif level_data.button_map[i] in $level.tempCells:
					$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(0, 3))
					$level.tempButtons[i - len($level.permaButtons)] = 0
				print(level_data.button_map[i])
			if $level/btns/button.get_cell_atlas_coords(level_data.button_map[i]) \
				in [Vector2i(1, 1), Vector2i(2, 1)]:
					$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 1))
					print(level_data.button_map[i])
	
	if "door_map" in level_data:
		print(level_data.door_map)
		for i in len(level_data.door_map):
			if $level/door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				$level/door.set_cell(level_data.door_map[i], 0, Vector2i(1, 2))
			if $level/door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				$level/door.set_cell(level_data.door_map[i], 0, Vector2i(0, 2))
	
	if "button_map_2" in level_data:
		print(level_data.button_map_2)
		for i in len(level_data.button_map_2):
			if $level/btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) \
				in [Vector2i(2, 3)]:
				if level_data.button_map_2[i] in $level.permaCells2:
					$level/btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(2, 2))
					$level.permaButtons2[i] = 0
				elif level_data.button_map_2[i] in $level.tempCells2:
					$level/btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(0, 3))
					$level.tempButtons2[i - len($level.permaButtons2)] = 0
				print(level_data.button_map_2[i])
			if $level/btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) \
				in [Vector2i(1, 1), Vector2i(2, 1)]:
					$level/btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(2, 1))
					print(level_data.button_map_2[i])
	
	if "door_map_2" in level_data:
		print(level_data.door_map_2)
		for i in len(level_data.door_map_2):
			if $level/door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				$level/door2.set_cell(level_data.door_map_2[i], 0, Vector2i(1, 2))
			if $level/door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				$level/door2.set_cell(level_data.door_map_2[i], 0, Vector2i(0, 2))
	
	$level/door.update_internals()
	$level/btns/button.update_internals()
	$level/door2.update_internals()
	$level/btns/button2.update_internals()
	print("Load successful. (Level Data)")
