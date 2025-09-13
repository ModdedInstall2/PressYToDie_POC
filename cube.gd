extends CharacterBody2D

@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var grabbed = false
@onready var node = get_parent()

func _physics_process(delta: float) -> void:
	if player and player.really_dead:
		await Hud.on_transition_finished
		get_parent().queue_free()
	
	if node.plane == 0:
		$Sprite.play(&"alive")
		motion_mode = MOTION_MODE_GROUNDED
	elif node.plane == 1:
		$Sprite.play(&"dead")
		motion_mode = MOTION_MODE_FLOATING
	if grabbed == true:
		if (node.plane == 0 and player.dead == false) \
		or (node.plane == 1 and player.dead == true):
			set_collision_mask_value(1, false)
			set_collision_mask_value(8, false)
			set_collision_layer_value(1, false)
			set_collision_layer_value(8, false)
			if get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == false:
				global_position.x = player.global_position.x + 15
			elif get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == true:
				global_position.x = player.global_position.x - 15
			global_position.y = player.global_position.y
		else:
			grabbed = false
	else:
		if node.plane == 0:
			set_collision_mask_value(1, true)
			set_collision_mask_value(8, true)
			set_collision_layer_value(1, true)
			set_collision_layer_value(8, true)
		else:
			set_collision_mask_value(1, false)
			set_collision_mask_value(8, false)
			set_collision_layer_value(1, false)
			set_collision_layer_value(8, false)
		
		if node.plane == 0:
			if not is_on_floor():
				velocity += get_gravity() * delta
		
		if node.plane == 0 and grabbed == false:
			move_and_slide()
		
	if Input.is_action_just_pressed("b"):
		if str($CubeArea.get_overlapping_bodies()).contains(str(player)) \
		and not str($RayCast2D.get_collider()).contains("mesh"):
			if grabbed == false:
				set_collision_mask_value(1, false)
				set_collision_mask_value(8, false)
				set_collision_layer_value(1, false)
				set_collision_layer_value(8, false)
				grabbed = true
			else:
				set_collision_mask_value(1, true)
				set_collision_mask_value(8, true)
				set_collision_layer_value(1, true)
				set_collision_layer_value(8, true)
				grabbed = false
	
	if Input.is_action_just_pressed("x"):
		if str($CubeArea.get_overlapping_bodies()).contains(str(player)):
			if node.plane == 0:
				node.plane = 1
			elif node.plane == 1:
				node.plane = 0
	
