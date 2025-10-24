extends Node3D

signal initialization
signal game_start
signal game_end

const GROUND:float = 1
var is_initialized:bool = false
@onready var title_screen : CanvasLayer = get_node("CanvasLayer/Control/TitleScreen")

# TitleScreen
func _ready() -> void:
	title_screen.visible = true
	# メダルを配置
	arrangement()
	# 初期化完了を通知
	await get_tree().create_timer(4).timeout
	self.initialization.connect(initialized)
	initialization.emit()

func initialized() -> void:
	print("Game Initialized")
	is_initialized = true

func start_game() -> void:
	title_screen.visible = false
	game_start.emit()

func arrangement() -> void:
	for i in range(0, 300):
		var rand_pos = Vector3(randf_range(-0.5, 0.8), GROUND, randf_range(-0.7, 0.7))
		var medal = preload("res://Resources/scenes/medal.tscn").instantiate()
		medal.position = rand_pos
		self.add_child(medal)
	"""
	for i in range(0, 3):
		var rand_pos = Vector3(randf_range(0.4, 0.8), GROUND, randf_range(-0.7, 0.7))
		var ball = preload("res://Resources/scenes/ball.tscn").instantiate()
		ball.position = rand_pos
		self.add_child(ball)
	"""


func _on_start_button_pressed() -> void:
	if not is_initialized:
		await initialization
	start_game()

func _on_end_game() -> void:
	game_end.emit()
