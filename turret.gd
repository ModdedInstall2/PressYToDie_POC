extends Node2D

@export var BULLET: PackedScene = null

var target: Node2D = null

@onready var gunSprite = $AnimatedSprite2D
@onready var rayCast = $RayCast2D

func _ready():
	await(get_tree().process_frame)
	target = find_target()

func _physics_process(delta):
	if target != null:
		var angle_to_target: float = global_position.direction_to(target.global_position).angle()
		rayCast.global_rotation = angle_to_target
		
		if rayCast.is_colliding() and rayCast.get_collider().is_in_group("Test Subject 234"):
			gunSprite.rotation = angle_to_target
			shoot()

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

func _on_ReloadTimer_timeout():
	rayCast.enabled = true
