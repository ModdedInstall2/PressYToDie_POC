extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var doubleJump = 0
var slope = 0
var dash := 0
var dead = false
var jumpedOffSlope = 0

func _physics_process(delta: float) -> void:
	var sprite = get_node("AnimatedSprite2D")
	
	if not dead:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, true)
		
		if not is_on_floor():
			velocity += get_gravity() * delta - $Collision/JumpDir.get_collision_normal()
		
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
				jumpedOffSlope = -1
			elif get_floor_normal().x > 0 and get_floor_normal().y != -1:
				jumpedOffSlope = 1
			if not is_on_floor():
				doubleJump = 1
			for i in range(3):
				await get_tree().process_frame
			if (not $sfx/jump.is_playing()) or doubleJump == 1:
				$sfx/jump.play()
			sprite.play(&"jump", 0.6)
		
		#if jumpedOffSlope == 1:
		#	for i in range(5):
		#		velocity.x -= JUMP_VELOCITY * 0.5
		#	jumpedOffSlope = 0
		#elif jumpedOffSlope == -1:
		#	for i in range(5):
		#		velocity.x += JUMP_VELOCITY * 0.5
		#	jumpedOffSlope = 0
		
		var direction := Input.get_axis("left", "right")
		var yDirection := Input.get_axis("down", "up")
		var dashDirection
		if 0.5 <= direction && direction <= 1:
			if 0.5 <= yDirection && yDirection <= 1:
				dashDirection = 0.25
			elif -0.5 >= yDirection && yDirection >= -1:
				dashDirection = 0.75
			else:
				dashDirection = 0.5
		elif -0.5 >= direction && direction >= -1:
			if 0.5 <= yDirection && yDirection <= 1:
				dashDirection = -0.25
			elif -0.5 >= yDirection && yDirection >= -1:
				dashDirection = -0.75
			else:
				dashDirection = -0.5
		elif 0.5 <= yDirection && yDirection <= 1:
			dashDirection = -1
		elif -0.5 >= yDirection && yDirection >= -1:
			dashDirection = 1
		if direction or yDirection:
			if direction < 0:
				sprite.set_flip_h(1)
			else:
				sprite.set_flip_h(0)
			if Input.is_action_just_pressed("b") and dash == 0:
				if dashDirection == 0.25:
					velocity.x = -JUMP_VELOCITY
					velocity.y = JUMP_VELOCITY
				elif dashDirection == 0.5:
					velocity.x = 1.25 * -JUMP_VELOCITY
				elif dashDirection == 0.75:
					velocity.x = -JUMP_VELOCITY
					velocity.y = -JUMP_VELOCITY
				elif dashDirection == 1:
					velocity.y = 1.25 * -JUMP_VELOCITY
				elif dashDirection == -0.25:
					velocity.x = JUMP_VELOCITY
					velocity.y = JUMP_VELOCITY
				elif dashDirection == -0.5:
					velocity.x = 1.25 * JUMP_VELOCITY
				elif dashDirection == -0.75:
					velocity.x = JUMP_VELOCITY
					velocity.y = -JUMP_VELOCITY
				elif dashDirection == -1:
					velocity.y = 1.25 * JUMP_VELOCITY
				sprite.play(&"dash", 0.6)
				dash = 1
				$sfx/dash.play()
			else:
				velocity.x = direction * SPEED
				if is_on_floor() and direction:
					sprite.play(&"walk", 1.5)
					if not $sfx/walk.is_playing():
						$sfx/walk.play()
					dash = 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if sprite.animation == &"walk":
				$sfx/walk.stop()
				sprite.stop()
		move_and_slide()
		if is_on_floor():
			dash = 0
		if not sprite.is_playing() or sprite.animation == &"die":
			if not dead:
				sprite.play(&"idle")
		print(direction)
		print(yDirection)
	
	elif dead:
		rotation = 0
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
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
		
		move_and_slide()
	
	if Input.is_action_just_pressed("y"):
		await get_tree().create_timer(0.05).timeout
		if not dead:
			$sfx/die.play()
			dead = true
			$Timer.start(10.0)
		else:
			$sfx/live.play()
			$Timer.start(0.05)
	

func _on_timer_timeout() -> void:
	dead = false
	var currentPos = position
	position.x += 1
	if currentPos == position:
		Input.action_press("y")
	position = currentPos
