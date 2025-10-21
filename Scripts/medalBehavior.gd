extends "res://Scripts/AbstractFallingObject.gd"

@onready var plane = get_node("../Plane")

func _falling():
	print("Falling...")
	plane.addMedal()
	queue_free()
