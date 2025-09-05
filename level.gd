extends Node2D

var permaButtons := [0, 0, 0, 0, 0, 0]
var permaCells := [Vector2i(12, 6), Vector2i(58, 12), Vector2i(138, 12), Vector2i(439, 25), \
Vector2i(497, 25), Vector2i(524, 11)]
var permaLights := [Vector2i(13, 3), Vector2i(60, 10), Vector2i(141, 10), Vector2i(442, 23), \
Vector2i(498, 23), Vector2i(526, 9)]
var permaDoors := [[Vector2i(13, 5), Vector2i(13, 6)], [Vector2i(61, 11), Vector2i(61, 12)], \
[Vector2i(142, 11), Vector2i(142, 12)], [Vector2i(443, 24), Vector2i(443, 25)], \
[Vector2i(499, 24), Vector2i(499, 25)], [Vector2i(527, 10), Vector2i(527, 11)]]
var tempButtons := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var tempCells := [Vector2i(18, 6), Vector2i(82, 12), Vector2i(110, 12), Vector2i(155, 19), \
Vector2i(184, 17), Vector2i(-1, -1), Vector2i(204, 17), Vector2i(215, 17), Vector2i(-1, -1), \
Vector2i(236, 16), Vector2i(260, 28), Vector2i(268, 28), Vector2i(297, 18), Vector2i(312, 12), \
Vector2i(-1, -1), Vector2i(348, 23), Vector2i(375, 23), Vector2i(382, 20), Vector2i(393, 25), \
Vector2i(-1, -1), Vector2i(456, 26), Vector2i(-1, -1), Vector2i(503, 22), Vector2i(544, 13), \
Vector2i(552, 10)]
var tempLights := [Vector2i(19, 4), Vector2i(87, 10), Vector2i(114, 10), Vector2i(168, 10), \
Vector2i(195, 15), Vector2i(-1, -1), Vector2i(209, 15), Vector2i(222, 15), Vector2i(-1, -1), \
Vector2i(249, 15), Vector2i(253, 21), Vector2i(277, 16), Vector2i(298, 16), Vector2i(331, 10), \
Vector2i(-1, -1), Vector2i(359, 21), Vector2i(378, 21), Vector2i(386, 18), Vector2i(414, 23), \
Vector2i(470, 23), Vector2i(509, 9), Vector2i(550, 8), Vector2i(554, 8), Vector2i(-1, -1)]
var tempDoors := [[Vector2i(19, 5), Vector2i(19, 6)], [Vector2i(88, 11), Vector2i(88, 12)], \
[Vector2i(115, 11), Vector2i(115, 12)], [Vector2i(169, 11), Vector2i(169, 12)], \
[Vector2i(196, 16), Vector2i(196, 17)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(210, 216), Vector2i(210, 217)], [Vector2i(223, 16), Vector2i(223, 17)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(250, 16), Vector2i(250, 17)], \
[Vector2i(252, 22), Vector2i(252, 23)], [Vector2i(278, 17), Vector2i(278, 18)], \
[Vector2i(299, 17), Vector2i(299, 18)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(332, 11), Vector2i(332, 12)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(360, 22), Vector2i(360, 23)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(379, 22), Vector2i(379, 23)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(387, 19), Vector2i(387, 20)], [Vector2i(415, 24), Vector2i(415, 25)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(471, 24), Vector2i(471, 25)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(510, 10), Vector2i(510, 11)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(551, 9), Vector2i(551, 10)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(555, 9), Vector2i(555, 10)], \
[Vector2i(-1, -1), Vector2i(-1, -1)]]
var tempButtons2 := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var tempCells2 := [Vector2i(18, 6), Vector2i(82, 12), Vector2i(110, 12), Vector2i(155, 19), \
Vector2i(-1, -1), Vector2i(187, 17), Vector2i(204, 17), Vector2i(-1, -1), Vector2i(219, 17), \
Vector2i(236, 16), Vector2i(260, 28), Vector2i(268, 28), Vector2i(297, 18), Vector2i(-1, -1), \
Vector2i(312, 0), Vector2i(348, 23), Vector2i(375, 23), Vector2i(-1, -1), Vector2i(-1, -1), \
Vector2i(405, 25), Vector2i(-1, -1), Vector2i(460, 26), Vector2i(503, 22), Vector2i(544, 13), \
Vector2i(554, 10)]
var tempLights2 := [Vector2i(19, 3), Vector2i(87, 10), Vector2i(114, 10), Vector2i(168, 10), \
Vector2i(-1, -1), Vector2i(195, 15), Vector2i(209, 15), Vector2i(-1, -1), Vector2i(222, 15), \
Vector2i(249, 15), Vector2i(253, 21), Vector2i(277, 16), Vector2i(304, 10), Vector2i(-1, -1), \
Vector2i(331, 10), Vector2i(359, 21), Vector2i(386, 18), Vector2i(-1, -1), Vector2i(414, 23), \
Vector2i(470, 23), Vector2i(509, 9), Vector2i(550, 8), Vector2i(-1, -1), Vector2i(554, 8)]
var tempDoors2 := [[Vector2i(19, 1), Vector2i(19, 2)], [Vector2i(88, 11), Vector2i(88, 12)], \
[Vector2i(115, 11), Vector2i(115, 12)], [Vector2i(169, 11), Vector2i(169, 12)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(196, 16), Vector2i(196, 17)], \
[Vector2i(210, 216), Vector2i(210, 217)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(223, 16), Vector2i(223, 17)], [Vector2i(250, 16), Vector2i(250, 17)], \
[Vector2i(252, 22), Vector2i(252, 23)], [Vector2i(278, 17), Vector2i(278, 18)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(299, 17), Vector2i(299, 18)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(332, 11), Vector2i(332, 12)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(360, 22), Vector2i(360, 23)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(387, 19), Vector2i(387, 20)], \
[Vector2i(-1, -1), Vector2i(-1, -1)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(415, 24), Vector2i(415, 25)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(471, 24), Vector2i(471, 25)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(510, 10), Vector2i(510, 11)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(551, 9), Vector2i(551, 10)], [Vector2i(-1, -1), Vector2i(-1, -1)], \
[Vector2i(555, 9), Vector2i(555, 10)]]
@onready var cubes = 1
@export var level_data:LevelData
@onready var saving := false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@export var level : int
@onready var main_node := get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		var door := Array(tempDoors2[i])
		$door2.set_cell(door[0], 0, Vector2i(1, 2))
		$door2.set_cell(door[1], 0, Vector2i(0, 2))
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
			var door := Array(tempDoors2[i])
			if currentBtn.get_overlapping_bodies() != []:
				if tempButtons2[i] == 0:
					$btns/click.play()
					$btns/button2.set_cell(tempCells2[i], 0, Vector2i(1, 3))
					$btns/button2.set_cell(tempLights2[i], 0, Vector2i(1, 1))
					$door2.set_cell(door[0], 0, Vector2i(3, 0))
					$door2.set_cell(door[1], 0, Vector2i(3, 1))
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
					$door2.set_cell(door[0], 0, Vector2i(1, 2))
					$door2.set_cell(door[1], 0, Vector2i(0, 2))
					tempButtons2[i] = 0
			
		for i in range(5):
			if get_node("level_list/" + str(i)):
				if get_node("level_list/" + str(i)).overlaps_body(player):
					if level != i:
						main_node.save_game()
						level = i
					get_node("cams/" + str(i)).enabled = true
					await get_tree().create_timer(0.25).timeout
					#main_node.load_game()
				else:
					get_node("cams/" + str(i)).enabled = false
		
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
