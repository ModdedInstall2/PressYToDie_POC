extends Node2D

@export_range (0, 1) var sprite_entered_from_right := 0
@export var permaButtons : Array[int]
@export var permaCells : Array[Vector2i]
@export var permaLights : Array[Vector2i]
@export var permaDoors : Array
@export var tempButtons : Array[int]
@export var tempCells : Array[Vector2i]
@export var tempLights : Array[Vector2i]
@export var tempDoors : Array
@export var tempButtons2 : Array[int]
@export var tempCells2 : Array[Vector2i]
@export var tempLights2 : Array[Vector2i]
@export var tempDoors2 : Array[Vector2i]
@onready var cubes = 1
@export var level_data:LevelData
@onready var saving := false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var main_node := get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player/CharacterBody2D/AnimatedSprite2D.set_flip_h(sprite_entered_from_right)
	level_data = LevelData.new()
	for i in range(len(permaButtons)):
		$btns/button.set_cell(permaCells[i], 0, Vector2i(2, 2))
		$btns/button.set_cell(permaLights[i], 0, Vector2i(2, 1))
		var door := Array(permaDoors[i])
		$door.set_cell(door[0], 0, Vector2i(1, 2))
		$door.set_cell(door[1], 0, Vector2i(0, 2))
	for i in range(len(tempButtons)):
		$btns/button.set_cell(tempCells[i], 0, Vector2i(0, 3))
		$btns/button.set_cell(tempLights[i], 0, Vector2i(2, 1))
		var door := Array(tempDoors[i])
		$door.set_cell(door[0], 0, Vector2i(1, 2))
		$door.set_cell(door[1], 0, Vector2i(0, 2))
	for i in range(len(tempButtons2)):
		$btns/button2.set_cell(tempCells2[i], 0, Vector2i(0, 3))
		$btns/button2.set_cell(tempLights2[i], 0, Vector2i(2, 1))
#		var door := Array(tempDoors2[i])
#		$door2.set_cell(door[0], 0, Vector2i(1, 2))
#		$door2.set_cell(door[1], 0, Vector2i(0, 2))
	for i in range(cubes):
		level_data.cubes.append(get_node("cubes/" + str(i) + "/CubeBody").position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if saving == false:
		# Buttons.
		for i in range(len(permaButtons)):
			var currentBtn := get_node("btns/permaTriggers/" + str(i))
			var door := Array(permaDoors[i])
			if currentBtn.get_overlapping_bodies() != []:
				if permaButtons[i] == 0:
					$btns/click.play()
					$btns/button.set_cell(permaCells[i], 0, Vector2i(1, 3))
					$btns/button.set_cell(permaLights[i], 0, Vector2i(1, 1))
					$door.set_cell(door[0], 0, Vector2i(3, 0))
					$door.set_cell(door[1], 0, Vector2i(3, 1))
					permaButtons[i] = 1
					await get_tree().create_timer(0.25).timeout
					$btns/button.set_cell(permaCells[i], 0, Vector2i(2, 3))
		for i in range(len(tempButtons)):
			var currentBtn := get_node("btns/tempTriggers/" + str(i))
			var door := Array(tempDoors[i])
			if currentBtn.get_overlapping_bodies() != []:
				if tempButtons[i] == 0:
					$btns/click.play()
					$btns/button.set_cell(tempCells[i], 0, Vector2i(1, 3))
					$btns/button.set_cell(tempLights[i], 0, Vector2i(1, 1))
					$door.set_cell(door[0], 0, Vector2i(3, 0))
					$door.set_cell(door[1], 0, Vector2i(3, 1))
					tempButtons[i] = 1
					await get_tree().create_timer(0.25).timeout
					if tempButtons[i] == 1:
						$btns/button.set_cell(tempCells[i], 0, Vector2i(2, 3))
			elif currentBtn.get_overlapping_bodies() == []:
				if tempButtons[i] == 1:
					$btns/click.play()
					$btns/button.set_cell(tempCells[i], 0, Vector2i(0, 3))
					$btns/button.set_cell(tempLights[i], 0, Vector2i(2, 1))
					$door.set_cell(door[0], 0, Vector2i(1, 2))
					$door.set_cell(door[1], 0, Vector2i(0, 2))
					tempButtons[i] = 0
		for i in range(len(tempButtons2)):
			var currentBtn := get_node("btns/tempTriggers/" + str(i))
#			var door := Array(tempDoors2[i])
			if currentBtn.get_overlapping_bodies() != []:
				if tempButtons2[i] == 0:
					$btns/click.play()
					$btns/button2.set_cell(tempCells2[i], 0, Vector2i(1, 3))
					$btns/button2.set_cell(tempLights2[i], 0, Vector2i(1, 1))
#					$door2.set_cell(door[0], 0, Vector2i(3, 0))
#					$door2.set_cell(door[1], 0, Vector2i(3, 1))
					tempButtons2[i] = 1
					await get_tree().create_timer(0.25).timeout
					if tempButtons2[i] == 1:
						$btns/button2.set_cell(tempCells2[i], 0, Vector2i(2, 3))
			elif currentBtn.get_overlapping_bodies() == []:
				if tempButtons2[i] == 1:
					$btns/click.stop()
					$btns/click.play()
					$btns/button2.set_cell(tempCells2[i], 0, Vector2i(0, 3))
					$btns/button2.set_cell(tempLights2[i], 0, Vector2i(2, 1))
#					$door2.set_cell(door[0], 0, Vector2i(1, 2))
#					$door2.set_cell(door[1], 0, Vector2i(0, 2))
					tempButtons2[i] = 0
		
		if "button_map" in level_data:
			level_data.button_map = $btns/button.get_used_cells()
		if "door_map" in level_data:
			level_data.door_map = $door.get_used_cells()
		if "button_map_2" in level_data:
			level_data.button_map_2 = $btns/button2.get_used_cells()
		if "door_map_2" in level_data:
			level_data.door_map_2 = $door2.get_used_cells()
	

func savegame():
	var data = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"door" : $door.get_used_cells(),
		"buttons" : $btns/button.get_used_cells()
	}
	return data

func loadgame():
	saving = true
	level_data = load("user://level.tres")
	
	if "button_map" in level_data and saving == true:
		for i in len(level_data.button_map):
			if $btns/button.get_cell_atlas_coords(level_data.button_map[i]) in permaCells:
				$btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 2))
				permaButtons[i] = 0
			elif $btns/button.get_cell_atlas_coords(level_data.button_map[i]) in tempCells:
				$btns/button.set_cell(level_data.button_map[i], 0, Vector2i(0, 3))
				tempButtons[i] = 0
			elif $btns/button.get_cell_atlas_coords(level_data.button_map[i]) in permaLights \
				or $btns/button.get_cell_atlas_coords(level_data.button_map[i]) in tempLights:
					$btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 1))
	
	if "door_map" in level_data and saving == true:
		for i in len(level_data.door_map):
			if $door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				$door.set_cell(level_data.door_map[i], 0, Vector2i(1, 2))
			elif $door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				$door.set_cell(level_data.door_map[i], 0, Vector2i(0, 2))
	
	if "button_map_2" in level_data and saving == true:
		for i in len(level_data.button_map_2):
			if $btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) in tempCells2:
				$btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(0, 3))
				tempButtons2[i] = 0
			elif $btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) in tempLights2:
					$btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(2, 1))
	
	if "door_map_2" in level_data and saving == true:
		for i in len(level_data.door_map_2):
			if $door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				$door2.set_cell(level_data.door_map_2[i], 0, Vector2i(1, 2))
			elif $door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				$door2.set_cell(level_data.door_map_2[i], 0, Vector2i(0, 2))
	
	if "cubes" in level_data and saving == true:
		for i in len(level_data.cubes):
			var cube = str(i)
			var cubeNode = get_node("cubes/" + cube + "/CubeBody")
			cubeNode.position = level_data.cubes[i]
	
	$door.update_internals()
	$btns/button.update_internals()
	$door2.update_internals()
	$btns/button2.update_internals()
	print("Load successful. (Level Data)")
	saving = false
