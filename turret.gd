extends CharacterBody2D

@export var target : int

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if target == 0:
		$AnimatedSprite2D.play(&"living")
	elif target == 1:
		$AnimatedSprite2D.play(&"dead")
	
	move_and_slide()
	print($Area2D2.get_overlapping_areas())
