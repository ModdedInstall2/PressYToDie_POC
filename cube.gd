extends CharacterBody2D

@onready var player = get_parent().get_parent().get_parent().get_parent().get_node("player/CharacterBody2D")
@onready var grabbed = false

func _physics_process(delta: float) -> void:
	if grabbed == false:
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
	elif grabbed == true:
		if get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == false:
			position.x = player.position.x + 20
		elif get_node(str(player.get_path()) + "/AnimatedSprite2D").flip_h == true:
			position.x = player.position.x - 20
		position.y = player.position.y
		
	if Input.is_action_just_pressed("x"):
		if str($Area2D.get_overlapping_bodies()).contains("CharacterBody2D"):
			if grabbed == false:
				set_collision_mask_value(1, false)
				set_collision_mask_value(8, false)
				set_collision_layer_value(1, false)
				set_collision_layer_value(8, false)
				grabbed = true
			elif grabbed == true:
				set_collision_mask_value(1, true)
				set_collision_mask_value(8, true)
				set_collision_layer_value(1, true)
				set_collision_layer_value(8, true)
				grabbed = false
