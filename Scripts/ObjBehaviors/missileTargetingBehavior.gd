extends Sprite3D

@export var missile_scene: PackedScene
func _ready() -> void:
	"""
	var object = missile_scene.instantiate()
	get_node("/root/Node3D").add_child(object)
	object.global_position = Vector3(randf_range(-3.4, 0.4), 5, randf_range(-0.7, 0.7))
	
	object.set_target_position(position)
	"""
	#queue_free()
