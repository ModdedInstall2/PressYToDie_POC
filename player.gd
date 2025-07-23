extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var doubleJump = 0
var slope = 0
var dash := 0
var dead = false

func _physics_process(delta: float) -> void:
	var sprite = get_node("AnimatedSprite2D")
	
	if not dead:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		collision_mask = 1
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if is_on_floor():
			rotation = get_floor_normal().angle() + PI/2
		else:
			rotation = 0
		
		if is_on_floor():
			doubleJump = 0
			if sprite.animation == &"jump":
				sprite.play(&"idle")
			
			set_floor_snap_length(5)
			set_floor_max_angle(1.5)
		elif !is_on_floor():
			set_floor_snap_length(1)
			set_floor_max_angle(0.785398)
		apply_floor_snap()
		
		if Input.is_action_just_pressed("a") and (is_on_floor() or doubleJump == 0):
			velocity.y = JUMP_VELOCITY
			if get_floor_normal().x < 0 and get_floor_normal().y != -1:
				velocity.x = SPEED * get_floor_normal().x * 2
			elif get_floor_normal().x > 0 and get_floor_normal().y != -1:
				velocity.x = -SPEED * get_floor_normal().x * 2
			if not is_on_floor():
				doubleJump = 1
			for i in range(3):
				await get_tree().process_frame
			sprite.play(&"jump", 0.6)
		
		var direction := Input.get_axis("left", "right")
		var yDirection := Input.get_axis("down", "up")
		if direction or yDirection:
			if direction < 0:
				sprite.set_flip_h(1)
			else:
				sprite.set_flip_h(0)
			if Input.is_action_just_pressed("b") and dash == 0:
				if direction > 1 or direction < -1:
					velocity.x = direction * -JUMP_VELOCITY * 0.85
				else:
					velocity.x = direction * -JUMP_VELOCITY * 1.5
				if yDirection < 1 or yDirection > -1:
					velocity.y += yDirection * JUMP_VELOCITY * 0.85
				else:
					velocity.y = yDirection * JUMP_VELOCITY * 1.5
				sprite.play(&"dash", 0.6)
				dash = 1
			else:
				velocity.x = direction * SPEED
				if is_on_floor() and direction:
					sprite.play(&"walk", 1.5)
					dash = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if sprite.animation == &"walk":
				sprite.stop()
		move_and_slide()
		if is_on_floor():
			dash = 0
		if not sprite.is_playing() or sprite.animation == &"die":
			if not dead:
				sprite.play(&"idle")
	
	elif dead:
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		collision_mask = 2
		sprite.play(&"die")
		
		var direction := Input.get_axis("left", "right")
		var yDirection := Input.get_axis("down", "up")
		if direction or yDirection:
			if direction < 0:
				sprite.set_flip_h(1)
			else:
				sprite.set_flip_h(0)
			velocity.x = direction * SPEED
			velocity.y = -yDirection * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if Input.is_action_just_pressed("y"):
		await get_tree().create_timer(0.05).timeout
		if not dead:
			dead = true
			$Timer.start(10.0)
		else:
			$Timer.start(0.05)

func _on_timer_timeout() -> void:
	dead = false
	var currentPos = position
	position.x += 1
	if currentPos == position:
		Input.action_press("y")
