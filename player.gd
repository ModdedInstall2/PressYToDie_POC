extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
var doubleJump = 0
var slope = 0
var dash := 0
var dead = false

func _physics_process(delta: float) -> void:
	var sprite = get_node("AnimatedSprite2D")
	var rc = get_node("CollisionShape2D/Stuck?")
	
	
	if not dead:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		collision_mask = 1
		
		print(rc.get_collider())
		if rc.get_collider() == $level/white:
			dead = true
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if is_on_floor():
			doubleJump = 0
			if sprite.animation == &"jump":
				sprite.play(&"idle")
		
		if Input.is_action_just_pressed("a") and (is_on_floor() or doubleJump == 0):
			velocity.y = JUMP_VELOCITY
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
		
		move_and_slide()
	
	if Input.is_action_just_pressed("y"):
		await get_tree().create_timer(0.05).timeout
		if not dead:
			dead = true
			$Timer.start()
		else:
			$Timer.start(0.05)
	
	# My attempt at hacking together slope rotation.
	#if leftRC.is_colliding() and rightRC.is_colliding() and is_on_floor():
	#	print(leftRC.get_collision_point())
	#	print(rightRC.get_collision_point())
	#	if leftRC.get_collision_point().y > rightRC.get_collision_point().y and slope == 0:
	#		while rotation_degrees > -45.0:
	#			rotation -= 0.05
	#		rotation_degrees = -45.0
	#		slope = 1
	#	elif rightRC.get_collision_point().y > leftRC.get_collision_point().y and slope == 0:
	#		while rotation_degrees < 45.0:
	#			rotation += 0.05
	#		rotation_degrees = 45.0
	#		slope = 1
	#if not direction:
	#	rotation = 0
	#	slope = 0

func _on_timer_timeout() -> void:
	dead = false
