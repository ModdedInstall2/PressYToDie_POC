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
	print($Area2D2.overlaps_body(player))
	if $Area2D2.overlaps_body(player):
		if not str($Area2D2.get_overlapping_bodies()).contains("CubeBody"):
			$beam.visible = true
			$beam/BeamCollider.shape[3] = player.position
			$beam/BeamCollider.shape[2].x = player.position.x
			$beam/BeamCollider.shape[2].y = player.position.y - 2.0
			if target == 0 and player.dead == false:
				$"beam/Not Ghost".visible = true
				$beam/Ghost.visible = false
				$"beam/Not Ghost".shape[1] = player.position
			elif target == 1 and player.dead == true:
				$beam/Ghost.visible = true
				$"beam/Not Ghost".visible = false
				$beam/Ghost.shape[1] = player.position
		else:
			$beam.visible = false
	else:
		$beam.visible = false

func get_local_scene_root(p_node : Node) -> Node:
	while (p_node and not p_node.name == "root"):
		p_node = p_node.get_parent()
		
	return p_node as Node
