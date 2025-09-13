extends Node2D

var save := "user://ddm.sav"
@onready var Player:Node = get_tree().get_first_node_in_group("Test Subject 234")
#@onready var Level:Node = $level
@export_range (0, 19) var current_level:int = 4
@export_range (0, 2) var entered_from:int = 1
@onready var active:bool = false
@onready var loading:bool = false

func _ready() -> void:
	Engine.max_fps = 60

func _physics_process(delta: float) -> void:
	# Check if we need to load the game or not
	if !active:
		loading = true
		load_game()
		active = true
	
	if Input.is_action_just_pressed("load"):
		loading = true
		load_game()
	
	if str(%left.get_overlapping_areas()).contains("IsInWall"):
		entered_from = 0
		if !loading:
			loading = true
			load_game()
	elif str(%right.get_overlapping_areas()).contains("IsInWall"):
		entered_from = 2
		if !loading:
			loading = true
			load_game()
	else:
		entered_from = 1
		

func save_game():
	# Shiny new saving code fit for the new system!
	var save_file = FileAccess.open(save, FileAccess.WRITE)
	var save_string = JSON.stringify({"level": current_level})
	save_file.store_line(save_string)
	loading = false
	
	# Old saving code from back when everything was still one map.
	# This code really, *really* sucks, but it took ages to make.
	# Please validate my effort
	#ResourceSaver.save(Player.player_data, save_player)
	#ResourceSaver.save(Level.level_data, save_level)

func load_game():
	# Shiny new loading code fit for multiple maps!
	Hud.transition()
	await Hud.on_transition_finished
	if get_node(str(current_level)):
		get_node(str(current_level)).queue_free()
	if active:
		if entered_from == 0:
			current_level -= 1
		elif entered_from == 2:
			current_level += 1
		
		var new_level = load("res://levels/" + str(current_level) + ".tscn")
		var instantized = new_level.instantiate()
		add_child(instantized)
		#if get_node(str(current_level)):
			#if str(get_node(str(current_level)).get_property_list()).contains("sprite_entered_from"):
				#get_node(str(current_level)).sprite_entered_from = entered_from
		#get_node(str(current_level)).queue_free()
		#instantized = new_level.instantiate()
		#add_child(instantized)
		entered_from = 1
		active = true
		save_game()
		#load_game()
	elif !active:
		if not FileAccess.file_exists(save):
			return
		
		var save_file = FileAccess.open(save, FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			var json_string = save_file.get_line()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
			
			var load_data = json.data
			var current_level = load_data["level"]
			var new_level = load("res://levels/" + str(current_level) + ".tscn")
			var instantized  = new_level.instantiate()
			add_child(instantized)
		save_game()
	else:
		print("Somehow, a boolean equals something other than true or false.")
		print("This probably means you're running on a computer that doesn't use binary.")
		print("Please return to period-accurate technology at once so the game isn't destroyed.")
		get_tree().quit();
	loading = false
	
	# Old loading code from back when everything was still one map.
	# This code really, *really* sucks, but it took ages to make.
	# Please validate my effort
	#var player_data = load(save_player)
	#
	#if "position" in player_data:
		#$player/CharacterBody2D.position = player_data.position
	#if "rotation" in player_data:
		#$player/CharacterBody2D/AnimatedSprite2D.set_flip_h(player_data.rotation)
	#
	#print("Load successful. (Player Data)")
	#
	#var level_data = load("user://level.tres")
	#
	#if "button_map" in level_data:
		#print(level_data.button_map)
		#for i in len(level_data.button_map):
			#if $level/btns/button.get_cell_atlas_coords(level_data.button_map[i]) \
				#in [Vector2i(2, 3)]:
				#if level_data.button_map[i] in $level.permaCells:
					#$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 2))
					#$level.permaButtons[i] = 0
				#elif level_data.button_map[i] in $level.tempCells:
					#$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(0, 3))
					#$level.tempButtons[i - len($level.permaButtons)] = 0
				#print(level_data.button_map[i])
			#if $level/btns/button.get_cell_atlas_coords(level_data.button_map[i]) \
				#in [Vector2i(1, 1), Vector2i(2, 1)]:
					#$level/btns/button.set_cell(level_data.button_map[i], 0, Vector2i(2, 1))
					#print(level_data.button_map[i])
	#
	#if "door_map" in level_data:
		#print(level_data.door_map)
		#for i in len(level_data.door_map):
			#if $level/door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				#$level/door.set_cell(level_data.door_map[i], 0, Vector2i(1, 2))
			#if $level/door.get_cell_atlas_coords(level_data.door_map[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				#$level/door.set_cell(level_data.door_map[i], 0, Vector2i(0, 2))
	#
	#if "button_map_2" in level_data:
		#print(level_data.button_map_2)
		#for i in len(level_data.button_map_2):
			#if $level/btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) \
				#in [Vector2i(2, 3)]:
				#if level_data.button_map_2[i] in $level.tempCells2:
					#$level/btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(0, 3))
					#$level.tempButtons2[i - len($level.permaButtons2)] = 0
				#print(level_data.button_map_2[i])
			#if $level/btns/button2.get_cell_atlas_coords(level_data.button_map_2[i]) \
				#in [Vector2i(1, 1), Vector2i(2, 1)]:
					#$level/btns/button2.set_cell(level_data.button_map_2[i], 0, Vector2i(2, 1))
					#print(level_data.button_map_2[i])
	#
	#if "door_map_2" in level_data:
		#print(level_data.door_map_2)
		#for i in len(level_data.door_map_2):
			#if $level/door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(1, 2), Vector2i(3, 0)]:
				#$level/door2.set_cell(level_data.door_map_2[i], 0, Vector2i(1, 2))
			#if $level/door2.get_cell_atlas_coords(level_data.door_map_2[i]) in [Vector2i(0, 2), Vector2i(3, 1)]:
				#$level/door2.set_cell(level_data.door_map_2[i], 0, Vector2i(0, 2))
	#
	#if "cubes" in level_data:
		#for i in len(level_data.cubes):
			#var cube = str(i)
			#var cubeNode = get_node("level/cubes/" + cube + "/CubeBody")
			#cubeNode.grabbed = false
			#cubeNode.position = level_data.cubes[i]
	#
	#$level/door.update_internals()
	#$level/btns/button.update_internals()
	#$level/door2.update_internals()
	#$level/btns/button2.update_internals()
	#print("Load successful. (Level Data)")
