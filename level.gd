extends Node2D

var permaButtons := [0]
var permaCells := [Vector2i(12, 6)]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(permaButtons)):
		$btns/button.set_cell(permaCells[i], 0, Vector2i(2, 2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(len(permaButtons)):
		var currentBtn := get_node("btns/permaTriggers/" + str(i))
		if currentBtn.get_overlapping_bodies() != []:
			if permaButtons[i] == 0:
				$btns/button.set_cell(permaCells[i], 0, Vector2i(1, 3))
				permaButtons[i] = 1
				await get_tree().create_timer(0.5).timeout
				$btns/button.set_cell(permaCells[i], 0, Vector2i(2, 3))
