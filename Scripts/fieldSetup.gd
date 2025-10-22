extends Node3D

const GROUND:float = 1;

func _ready() -> void:
	# メダルを配置
	for i in range(0, 500):
		var rand_pos = Vector3(randf_range(-3.4, 0.4), GROUND, randf_range(-0.7, 0.7))
		var coin = preload("res://Resources/scenes/medal.tscn").instantiate()
		coin.position = rand_pos
		self.add_child(coin)
