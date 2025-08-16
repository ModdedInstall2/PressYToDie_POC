@tool
extends EditorPlugin

# A class member to hold the dock during the plugin life cycle.
var dock : Control

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/magic_button/dock.tscn").instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, dock)

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, dock)
	# Erase the control from the memory.
	dock.free()
