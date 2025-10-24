extends CanvasLayer

@onready var setup:Node3D= get_node("/root/Node3D")
# シグナル
#setup.game_end.connect(showResult)
func _ready() -> void:
	setup.game_end.connect(end_game)
	
func end_game():
	setup.is_initialized = false
	visible = true
	setup.arrangement()
	await get_tree().create_timer(4).timeout
	setup.is_initialized = true
	setup.initialization.emit()


func _on_restart_button_pressed() -> void:
	if not setup.is_initialized:
		await setup.initialization
	visible = false
	setup.start_game()
