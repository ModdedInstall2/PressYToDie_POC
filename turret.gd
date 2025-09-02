extends CharacterBody2D

@export var BULLET: PackedScene = null

var target: Node2D = null
@export_range (0, 1) var type : int

@onready var gunSprite = $AnimatedSprite2D
@onready var rayCast = $RayCast2D
@onready var has_touched_ground := false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")

func _ready():
	await(get_tree().process_frame)
	target = find_target()

func _physics_process(delta):
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		rayCast.global_rotation = angle_to_target
		
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("Test Subject 234"):
			#gunSprite.rotation = angle_to_target
			shoot()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if type == 0:
		$AnimatedSprite2D.play(&"living")
	elif type == 1:
		$AnimatedSprite2D.play(&"dead")
	
	if !has_touched_ground:
		move_and_slide()
		if is_on_floor():
			has_touched_ground = true
	
	if str($VisionCone2D/Area2D.get_overlapping_areas()).contains("PlayerArea"):
		print("The player is visible")
		$VisionCone2D/Polygon2D.color = Color("#0000007a")
		var collider = $RayCast2D
		collider.target_position = player.global_position
		if str(collider.get_collider()).contains(str(player)):
			print("The player is visible")
			if (type == 0 and player.dead == false):
				# Put code here
				pass
			elif (type == 1 and player.dead == true):
				# Put code here
				pass
		else:
			# Put code here
			pass
	else:
		$VisionCone2D/Polygon2D.color = Color("#7c7c7c7a")


func shoot():
	print("PEW")
	rayCast.enabled = false
	
	if BULLET:
		var bullet: Node2D = BULLET.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = rayCast.global_rotation

func find_target():
	var new_target: Node2D = null
	
	if get_tree().has_group("Test Subject 234"):
		new_target = get_tree().get_nodes_in_group("Test Subject 234")[0]
	
	return new_target
