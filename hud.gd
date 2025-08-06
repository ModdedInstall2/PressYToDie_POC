extends CanvasLayer

signal on_transition_finished

@onready var black = $fade/ColorRect
@onready var fade_anim = $fade/AnimationPlayer

func _ready():
	black.visible = false
	fade_anim.animation_finished.connect(_on_animation_finished)

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
