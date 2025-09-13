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
@onready var angle_to_target : float
@onready var zappy_played := false
@onready var scene_root:Node = get_tree().get_first_node_in_group("Testing Facility")

func _ready():
	await(get_tree().process_frame)
	target = find_target()
	$death_ray/living.visible = false
	$death_ray/dead.visible = false
	$death_ray.monitorable = false

func _physics_process(delta):
	if player and player.really_dead \
	and !scene_root.loading:
		await Hud.on_transition_finished
		main_node.queue_free()
	
	if target != null:
		angle_to_target = global_position.direction_to(target.global_position).angle()
		$Area2D/CollisionShape2D.scale.x = target.position.x + 50.0/2
		$Area2D/CollisionShape2D.global_rotation = angle_to_target
		
		if str($Area2D.get_overlapping_areas()).contains("Cube"):
			cube_blocking = true
		else:
			cube_blocking = false
	
	if player:
		if main_node.type == 0 and not player.dead \
		or main_node.type == 1 and player.dead:
			correct_type = true
		else:
			correct_type = false
	
	if str($VisionCone2D/Area2D.get_overlapping_areas()).contains("IsInWall") \
	and not cube_blocking \
	and correct_type:
		if not zappy_played:
			$zappy_zap.play()
			zappy_played = true
		$VisionCone2D/Polygon2D.color = Color("#0000007a")
		$death_ray.monitorable = true
		if main_node.type == 0:
			$death_ray/living.visible = true
			$death_ray/dead.visible = false
			if target != null:
				$death_ray/living.points[1].x = (target.position.x) + 30
				$death_ray/living.global_rotation = angle_to_target
				$death_ray/collider.shape.points[1].x = (target.position.x) + 30
				$death_ray/collider.shape.points[2].x = (target.position.x) + 30
				$death_ray/collider.global_rotation = angle_to_target
		elif main_node.type == 1:
			$death_ray/living.visible = false
			$death_ray/dead.visible = true
			if target != null:
				$death_ray/dead.points[1].x = (0 - target.position.x) + 30
				$death_ray/dead.global_rotation = angle_to_target
				$death_ray/collider.shape.points[1].x = (0 - target.position.x) + 30
				$death_ray/collider.shape.points[2].x = (0 - target.position.x) + 30
				$death_ray/collider.global_rotation = angle_to_target
		#print("The player is visible")
	else:
		zappy_played = false
		$VisionCone2D/Polygon2D.color = Color("#7c7c7c7a")
		$death_ray.monitorable = false
		$death_ray/living.visible = false
		$death_ray/dead.visible = false
		#print("The player is not visible")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if main_node.type == 0:
		$AnimatedSprite2D.play(&"living")
	elif main_node.type == 1:
		$AnimatedSprite2D.play(&"ghost")
	
	if !has_touched_ground and main_node.gravity:
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
