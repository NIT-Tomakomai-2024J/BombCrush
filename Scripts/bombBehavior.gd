extends "res://Scripts/AbstractFallingObject.gd"


@onready var explosion_area
func _falling():
	print("Falling...")
	queue_free()

func bomb():
	print("BOOM!")
	explosion_area = Area3D.new()
	add_child(explosion_area)
	if explosion_area == null:
		print("Area3D node not found!")
		return
	for body in explosion_area.get_overlapping_bodies():
		if body is AbstractFallingObject:
			body.bombed(global_position)

func _init() -> void:
	get_tree().create_timer(10).timeout.connect(bomb)
