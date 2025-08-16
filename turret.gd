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
	#print($Area2D2.get_overlapping_areas())

func _on_vision_cone_area_body_entered(body: Node2D) -> void:
	print(body)
	if body.name == "TurretBody":
		if (target == 0 and body.get_parent().dead == false) or (target == 1 and body.get_parent().dead == true):
			$beam.visible = true

func _on_vision_cone_area_body_exited(body: Node2D) -> void:
	$beam.visible = false
