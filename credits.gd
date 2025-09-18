extends Control

@onready var credits_playing := false
@onready var credits_scrolling := false
@onready var credits_ending := false

func _ready() -> void:
	$text.position = Vector2(0, -30.0)
	$text.modulate = Color(255, 255, 255, 0)

func _physics_process(delta: float) -> void:
	if not credits_playing:
		start_credits()
	elif not credits_scrolling:
		pass
	else:
		if $text.position.y >= -6582.0:
			if !credits_ending:
				$text.velocity.y = -45.0
				$text.move_and_slide()
		else:
			$text.position.y = -6582.0
			$text.velocity = Vector2.ZERO
			if !credits_ending:
				end_credits()
			else:
				pass

func start_credits():
	credits_playing = true
	$still_alive.play()
	$timer.start()
	await $timer.timeout
	$text.modulate = Color(255, 255, 255, 255)
	await get_tree().create_timer(16.5).timeout
	credits_scrolling = true

func end_credits():
	credits_ending = true
	await get_tree().create_timer(12.0).timeout
	get_tree().quit();
