extends CanvasLayer

signal on_transition_finished

@onready var black = $fade/ColorRect
@onready var fade_anim = $fade/AnimationPlayer
@onready var timer_active := false
@onready var seconds := 10
@onready var player := get_tree().get_first_node_in_group("Test Subject 234")

func _ready():
	black.visible = false
	fade_anim.animation_finished.connect(_on_animation_finished)

@warning_ignore("unused_parameter")
func _process(delta : float):
	player = get_tree().get_first_node_in_group("Test Subject 234")
	#print(get_tree().get_nodes_in_group("Test Subject 234"))
	if player and player.dead:
		#print("Found player")
		timer_active = true
	else:
		timer_active = false
	
	if timer_active == true:
		if $timer/Timer.is_stopped():
			$timer/Timer.start(10.0)
		$timer/Label.text = str($timer/Timer.get_time_left()).pad_decimals(0)
	else:
		$timer/Timer.start(0.00001)
		$timer/Label.text = "10"
	
	#$timer/Label.text = str(seconds)

func _on_animation_finished(anim):
	if anim == "fade_out":
		on_transition_finished.emit()
		await get_tree().create_timer(0.5).timeout
		fade_anim.play("fade_in")
	elif anim == "fade_in":
		black.visible = false

func transition():
	black.visible = true
	fade_anim.play("fade_out")
