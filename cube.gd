extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		rotation = get_floor_normal().angle() + PI/2
	else:
		rotation = 0
	
	move_and_slide()
