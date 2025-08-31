extends CharacterBody2D

@export_range(0, 1) var target : int
var points : Array[Vector2] = []
var has_touched_ground = false
@onready var player : Node = get_node("/root/Main/player/CharacterBody2D")

func _ready() -> void:
	$VisionCone2D.ray_count = 100
	for i in range(100):
		points.append(Vector2(1152.0, 400 - (8.25 * i)))
	print(player)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if target == 0:
		$AnimatedSprite2D.play(&"living")
	elif target == 1:
		$AnimatedSprite2D.play(&"dead")
	
	if has_touched_ground == false:
		move_and_slide()
		if is_on_floor():
			has_touched_ground = true
	for i in range(13):
		var ray := $Raycast.get_node(str(i)) as RayCast2D
		if ray and ray.is_colliding():
			var collider = ray.get_collider()
			if collider == player:
				print(str(i) + " is touching the player")

func get_local_scene_root(p_node : Node) -> Node:
	while (p_node and not p_node.name == "root"):
		p_node = p_node.get_parent()
		
	return p_node as Node
