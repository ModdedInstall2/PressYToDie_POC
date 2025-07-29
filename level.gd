extends Node2D

var permaButtons := [0]
var permaCells := [Vector2i(12, 6)]
var permaLights := [Vector2i(13, 4)]
var permaDoors := [[Vector2i(13, 5), Vector2i(13, 6)]]
var tempButtons := [0]
var tempCells := [Vector2i(18, 6)]
var tempLights := [Vector2i(19, 4)]
var tempDoors := [[Vector2i(19, 5), Vector2i(19, 6)]]
var levelData : PackedByteArray
@export var data:LevelData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	data = LevelData.new()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
				$btns/click.stop()
				$btns/click.play()
				$btns/button.set_cell(tempCells[i], 0, Vector2i(0, 3))
				$btns/button.set_cell(tempLights[i], 0, Vector2i(2, 1))
				$door.set_cell(door[0], 0, Vector2i(1, 2))
				$door.set_cell(door[1], 0, Vector2i(0, 2))
				tempButtons[i] = 0
	
	if "button_map" in data:
		data.button_map = $btns/button.get_used_cells()
	if "door_map" in data:
		data.door_map = $door.get_used_cells()

func savegame():
	var data = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"door" : $door.tile_map_data,
		"buttons" : $btns/button.tile_map_data
	}
	return data

func loadgame():
	data = load("user://level.tres")
	
	if "button_map" in data:
		for i in len(data.button_map):
			if $btns/button.get_cell_atlas_coords(data.button_map[i]) in permaButtons:
				$btns/button.set_cell(data.button_map[i], 0, Vector2i(2, 2))
			elif $btns/button.get_cell_atlas_coords(data.button_map[i]) in tempButtons:
				$btns/button.set_cell(data.button_map[i], 0, Vector2i(0, 3))
			elif $btns/button.get_cell_atlas_coords(data.button_map[i]) in permaLights \
				or $btns/button.get_cell_atlas_coords(data.button_map[i]) in tempLights:
					$btns/button.set_cell(data.button_map[i], 0, Vector2i(2, 1))
	
	if "door_map" in data:
		for i in len(data.door_map):
			if $door.get_cell_atlas_coords(data.door_map[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				$door.set_cell(data.door_map[i], 0, Vector2i(1, 2))
			elif $door.get_cell_atlas_coords(data.door_map[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				$door.set_cell(data.door_map[i], 0, Vector2i(0, 2))
	
	$door.update_internals()
	$btns/button.update_internals()
	print("Load successful.")
