@tool
extends Control
signal was_pressed()

func _on_convert_toggled(toggled_on: bool) -> void:
	var root = EditorInterface.get_base_control()
	await root.get_tree().create_timer(1.0).timeout

	var node = root.find_child("DockVSplitCenter", true, false)
	node.set_vertical(!toggled_on)
