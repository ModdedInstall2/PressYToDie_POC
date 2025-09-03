extends CharacterBody2D

@export var BULLET: PackedScene = null

var target: Node2D = null

@onready var gunSprite = $AnimatedSprite2D
@onready var rayCast = $Area2D
@onready var has_touched_ground := false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var main_node : Node = get_parent()

func _ready():
	await(get_tree().process_frame)
	target = find_target()

func _physics_process(delta):
	if str($VisionCone2D/Area2D.get_overlapping_areas()).contains("PlayerArea"):
		if target != null:
			var angle_to_target: float = global_position.direction_to(target.global_position).angle()
			$Area2D/CollisionShape2D.scale.x = target.position.x + 60.0
			$Area2D/CollisionShape2D.global_rotation = angle_to_target
			
			if not str($Area2D.get_overlapping_areas()).contains("Cube"):
				$VisionCone2D/Polygon2D.color = Color("#0000007a")
				print("The player is visible")
		else:
			print("Couldn't find player")
	else:
		$VisionCone2D/Polygon2D.color = Color("#7c7c7c7a")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if main_node.type == 0:
		$AnimatedSprite2D.play(&"living")
	elif main_node.type == 1:
		$AnimatedSprite2D.play(&"dead")
	
	if !has_touched_ground:
		move_and_slide()
		if is_on_floor():
			has_touched_ground = true

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
		new_target = get_tree().get_first_node_in_group("Test Subject 234")
	
	return new_target
