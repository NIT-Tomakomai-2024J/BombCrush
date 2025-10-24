extends Node3D
signal initialization


const GROUND:float = 1
var game_play:bool = false
var is_initialized:bool = false
@onready var title_screen : Control = get_node("CanvasLayer/Control/TitleScreen")
#TitleScreen
func _ready() -> void:
	self.initialization.connect(initialized)
	# メダルを配置
	for i in range(0, 500):
		var rand_pos = Vector3(randf_range(-3.4, 0.4), GROUND, randf_range(-0.7, 0.7))
		var coin = preload("res://Resources/scenes/medal.tscn").instantiate()
		coin.position = rand_pos
		self.add_child(coin)
	initialization.emit()

func initialized() -> void:
	print("Game Initialized")
	is_initialized = true

func start_game() -> void:
	title_screen.visible = false
	game_play = true

func _on_start_button_pressed() -> void:
	if not is_initialized:
		await initialization
	start_game()
