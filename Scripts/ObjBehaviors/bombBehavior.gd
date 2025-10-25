extends "res://Scripts/AbstractFallingObject.gd"
@onready var explosion_area = $Area3D

func _falling():
	print("Falling...")
	queue_free()

func bomb():
	print("BOOM!")
	if explosion_area == null:
		print("Area3D node not found!")
		return
	for body in explosion_area.get_overlapping_bodies():
		if body is AbstractFallingObject:
			body.bombed(global_position)
	$AudioStreamPlayer3D.play()
	visible = false
	await $AudioStreamPlayer3D.finished
	queue_free()
