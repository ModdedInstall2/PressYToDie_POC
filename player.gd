extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -260.0
@onready var doubleJump := 0
@onready var slope := 0
@onready var dash := 0
@export var dead := false
@onready var jumpedOffSlope := 0
@onready var really_dead := false
@export var sprite : Node
@onready var main_node := get_tree().get_first_node_in_group("Testing Facility")
@onready var ragdoll := get_parent().get_node("Ragdoll")
@onready var in_wall := false

func _ready() -> void:
	sprite = get_node("AnimatedSprite2D")
	set_collision_layer_value(16, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, false)
	set_collision_mask_value(3, true)

func _physics_process(delta: float) -> void:
	if not dead:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(3, true)
		
		if str($IsInWall.get_overlapping_areas()).contains("death_ray"):
			# Fix a minor glitch with turrets
			await get_tree().create_timer(0.05).timeout
		
		if str($IsInWall.get_overlapping_areas()).contains("water") \
		or str($IsInWall.get_overlapping_areas()).contains("death_ray"):
			if really_dead == false:
				really_dead = true
				dead = true
				sprite.play(&"fade", 10)
				await sprite.animation_finished
				really_die()
		elif sprite.animation == &"fade":
			sprite.stop()
		
		if not is_on_floor():
			velocity += get_gravity() * delta - $Collision/JumpDir.get_collision_normal()
		
		# You don't even want to know how long it took to get this pathetic little
		# thing to exist - only for it to be useless.
		#if is_on_floor():
		#	rotation = get_floor_normal().angle() + PI/2
		#else:
		#	rotation = 0
		
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
			if really_dead == true:
				really_dead = false
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
			if really_dead == true:
				really_dead = false
		
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
		# Dashing was scrapped to simplfy controls, and also bc it's kinda useless tbh.
		# Any platform that you'd have to dash up to can also be reached with the (less
		# janky) double jump.
		#var dashDirection
		#if 0.5 <= direction && direction <= 1:
		#	if 0.5 <= yDirection && yDirection <= 1:
		#		dashDirection = 0.25
		#	elif -0.5 >= yDirection && yDirection >= -1:
		#		dashDirection = 0.75
		#	else:
		#		dashDirection = 0.5
		#elif -0.5 >= direction && direction >= -1:
		#	if 0.5 <= yDirection && yDirection <= 1:
		#		dashDirection = -0.25
		#	elif -0.5 >= yDirection && yDirection >= -1:
		#		dashDirection = -0.75
		#	else:
		#		dashDirection = -0.5
		#elif 0.5 <= yDirection && yDirection <= 1:
		#	dashDirection = -1
		#elif -0.5 >= yDirection && yDirection >= -1:
		#	dashDirection = 1
		if direction or yDirection:
			if direction < 0:
				sprite.set_flip_h(1)
			else:
				sprite.set_flip_h(0)
			#if Input.is_action_just_pressed("b") and dash == 0:
			#	if dashDirection == 0.25:
			#		velocity.x = -JUMP_VELOCITY
			#		velocity.y = JUMP_VELOCITY
			#	elif dashDirection == 0.5:
			#		velocity.x = 1.25 * -JUMP_VELOCITY
			#	elif dashDirection == 0.75:
			#		velocity.x = -JUMP_VELOCITY
			#		velocity.y = -JUMP_VELOCITY
			#	elif dashDirection == 1:
			#		velocity.y = 1.25 * -JUMP_VELOCITY
			#	elif dashDirection == -0.25:
			#		velocity.x = JUMP_VELOCITY
			#		velocity.y = JUMP_VELOCITY
			#	elif dashDirection == -0.5:
			#		velocity.x = 1.25 * JUMP_VELOCITY
			#	elif dashDirection == -0.75:
			#		velocity.x = JUMP_VELOCITY
			#		velocity.y = -JUMP_VELOCITY
			#	elif dashDirection == -1:
			#		velocity.y = 1.25 * JUMP_VELOCITY
			#	sprite.play(&"dash", 0.6)
			#	dash = 1
			#	$sfx/dash.play()
			#else:
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
		if not str($IsInWall.get_overlapping_areas()).contains("water"):
			move_and_slide()
		if is_on_floor():
			dash = 0
		if not sprite.is_playing() or sprite.animation == &"die":
			if not dead:
				sprite.play(&"idle")
		
		ragdoll.visible = false
		ragdoll.rotation_degrees = 0
		ragdoll.position = position
	
	elif dead:
		rotation = 0
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
		if not (str($IsInWall.get_overlapping_areas()).contains("water") \
		or str($IsInWall.get_overlapping_areas()).contains("death_ray")):
			sprite.play(&"die")
		
		if str($IsInWall.get_overlapping_areas()).contains("death_ray"):
			motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
			set_collision_mask_value(1, true)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
			if not is_on_floor():
				velocity += get_gravity() * delta - $Collision/JumpDir.get_collision_normal()
		else:
			motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
			set_collision_mask_value(1, false)
			set_collision_mask_value(2, true)
			set_collision_mask_value(3, true)
		
		if str($IsInWall.get_overlapping_areas()).contains("water") && \
			sprite.animation not in [&"fade", &"really_die"] && not \
			$"sfx/really-die".playing && really_dead == false:
			really_die()
		
		if not (str($IsInWall.get_overlapping_areas()).contains("water") \
		or str($IsInWall.get_overlapping_areas()).contains("death_ray")):
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
		
		if not str($IsInWall.get_overlapping_areas()).contains("water"):
			move_and_slide()
		
		if really_dead == false:
			ragdoll.visible = true
			ragdoll.scale = Vector2(1, 1)
			if not ragdoll.is_on_floor():
				ragdoll.velocity += get_gravity() * delta
			
			if ragdoll.rotation_degrees > -90:
				ragdoll.rotation_degrees -= 4
			else:
				ragdoll.rotation_degrees = -90
			
			ragdoll.move_and_slide()
	
	if Input.is_action_just_pressed("y"):
		await get_tree().create_timer(0.05).timeout
		if str($IsInWall.get_overlapping_areas()).contains("water"):
			if not dead:
				really_die()
			else:
				$sfx/live.play()
				$DeathTimer.start(0.05)
		else:
			if not dead:
				$sfx/die.play()
				dead = true
				$DeathTimer.start(10.0)
			else:
				$sfx/live.play()
				$DeathTimer.start(0.05)
	
	#var currentLevel = str($PlayerArea.get_overlapping_areas())
	#if currentLevel.contains("lvl0"):
	#	$Camera2D.limit_left = 0
	#	$Camera2D.limit_top = 0
	#	$Camera2D.limit_bottom = 450
	#	$Camera2D.limit_right = 1050
	#
	#print(get_viewport().get_mouse_position())
	#print(str($PlayerArea.get_overlapping_areas()))
	

func _on_timer_timeout() -> void:
	if not str($IsInWall.get_overlapping_bodies()).contains("white"):
		dead = false
		in_wall = false
	else:
		if not in_wall:
			in_wall = true
			$"sfx/save-yourself".play()
		$DeathTimer.start(1.0)

func really_die():
	$"sfx/really-die".play()
	$AnimatedSprite2D.play(&"really_die")
	await $AnimatedSprite2D.animation_finished
	get_parent().queue_free()
	main_node.load_game()
	#self.queue_free()
