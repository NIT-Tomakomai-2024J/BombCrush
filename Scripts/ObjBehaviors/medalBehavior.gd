extends "res://Scripts/AbstractFallingObject.gd"

func _falling():
	print("Falling...")
	get_node("../Plane").medalAmount += 1
	queue_free()
