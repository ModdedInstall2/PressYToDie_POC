extends Node2D

var btn1 := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$btns/button.set_cell(Vector2i(12, 6), 0, Vector2i(2, 2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"btns/permaTriggers/1".get_overlapping_bodies() != []:
		if btn1 == false:
			$btns/button.set_cell(Vector2i(12, 6), 0, Vector2i(1, 3))
			btn1 = true
			await get_tree().create_timer(0.5).timeout
			$btns/button.set_cell(Vector2i(12, 6), 0, Vector2i(2, 3))
