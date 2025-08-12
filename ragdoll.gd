extends CharacterBody2D

func _physics_process(delta: float) -> void:
	$AnimatedSprite2D.animation = &"ragdoll"
	if $CharacterBody2D.dead == true:
		scale = Vector2(1, 1)
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if rotation_degrees > -90:
			rotation_degrees -= 2
		else:
			rotation_degrees = -90
		
		move_and_slide()
	else:
		scale = Vector2(0, 0)
		position.x = $CharacterBody2D.position.x
		position.y = $CharacterBody2D.position.y
