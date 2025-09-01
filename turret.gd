extends CharacterBody2D

@export_range(0, 1) var target : int
var points : Array[Vector2] = []
var has_touched_ground = false
@onready var player : Node = get_tree().get_first_node_in_group("Test Subject 234")
@onready var attack := false

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
	
	if str($Area2D.get_overlapping_bodies()).contains(str(player)):
		var collider = $RayCast2D
		collider.target_position = player.global_position
		if str(collider.get_collider()).contains(str(player)):
			print("The player is visible")
			if (target == 0 and player.dead == false):
				$beam.visible = true
				$beam/BeamCollider.shape.segments[2] = player.position
				$beam/BeamCollider.shape.segments[3] = player.position
				$"beam/Ghost".visible = false
				$"beam/Not Ghost".visible = true
				$"beam/Not Ghost".points[1] = player.position
			elif (target == 1 and player.dead == true):
				$beam.visible = true
				$beam/BeamCollider.shape.segments[2] = player.position
				$beam/BeamCollider.shape.segments[3] = player.position
				$"beam/Ghost".visible = true
				$"beam/Ghost".visible = false
				$"beam/Ghost".points[1] = player.position
			else:
				$beam.visible = false
				$"beam/Ghost".visible = false
				$"beam/Not Ghost".visible = false
	else:
		$beam.visible = false
		$"beam/Ghost".visible = false
		$"beam/Not Ghost".visible = false

func get_local_scene_root(p_node : Node) -> Node:
	while (p_node and not p_node.name == "root"):
		p_node = p_node.get_parent()
		
	return p_node as Node
