extends CharacterBody2D

@export var BULLET: PackedScene = null

var target: Node2D = null

@onready var gunSprite = $AnimatedSprite2D
@onready var rayCast = $Area2D
@onready var has_touched_ground := false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var main_node : Node = get_parent()
@onready var cube_blocking := false
@onready var correct_type := false

func _ready():
	await(get_tree().process_frame)
	target = find_target()

func _physics_process(delta):
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		$Area2D/CollisionShape2D.scale.x = target.position.x + 50.0
		$Area2D/CollisionShape2D.global_rotation = angle_to_target
		
		if str($Area2D.get_overlapping_areas()).contains("Cube"):
			cube_blocking = true
		else:
			cube_blocking = false
	
	if main_node.type == 0 and player.dead == false \
	or main_node.type == 1 and player.dead == true:
		correct_type = true
	else:
		correct_type = false
	
	if str($VisionCone2D/Area2D.get_overlapping_areas()).contains("PlayerArea") \
	and cube_blocking == false \
	and correct_type == true:
		$VisionCone2D/Polygon2D.color = Color("#0000007a")
		#print("The player is visible")
	else:
		$VisionCone2D/Polygon2D.color = Color("#7c7c7c7a")
		#print("The player is not visible")
	
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
