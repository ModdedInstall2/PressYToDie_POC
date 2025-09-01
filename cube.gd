extends CharacterBody2D

@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var grabbed = false

func _physics_process(delta: float) -> void:
	if grabbed == true:
		set_collision_mask_value(1, false)
		set_collision_mask_value(8, false)
		set_collision_layer_value(1, false)
		set_collision_layer_value(8, false)
		if get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == false:
			global_position.x = player.global_position.x + 30
		elif get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == true:
			global_position.x = player.global_position.x - 30
		global_position.y = player.global_position.y
	else:
		set_collision_mask_value(1, true)
		set_collision_mask_value(8, true)
		set_collision_layer_value(1, true)
		set_collision_layer_value(8, true)
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if is_on_floor():
			rotation = get_floor_normal().angle() + PI/2
		else:
			rotation = 0
		
		move_and_slide()
		
	if Input.is_action_just_pressed("x"):
		if str($Area2D.get_overlapping_bodies()).contains(str(player)):
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
