extends Node2D

var permaButtons := [0]
var permaCells := [Vector2i(12, 6)]
var permaLights := [Vector2i(13, 4)]
var permaDoors := [[Vector2i(13, 5), Vector2i(13, 6)]]
var tempButtons := [0]
var tempCells := [Vector2i(18, 6)]
var tempLights := [Vector2i(19, 4)]
var tempDoors := [[Vector2i(19, 5), Vector2i(19, 6)]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		print(currentBtn.get_overlapping_bodies())
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
