extends Node2D

var save_player := "user://player.tres"
var save_level := "user://level.tres"
@onready var Player:Node = $player
@onready var Level:Node = $level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		save_game()
	
	if Input.is_action_just_pressed("load"):
		load_game()

func save_game():
	ResourceSaver.save(Player.data, save_player)
	ResourceSaver.save(Level.data, save_level)

func load_game():
	$player.loadgame()
	$level.loadgame()
