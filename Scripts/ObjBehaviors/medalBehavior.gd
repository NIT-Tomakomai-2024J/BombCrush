extends "res://Scripts/AbstractFallingObject.gd"

@onready var plane = get_node("../Plane")
func _falling():
	print("Falling...")
	if plane.game_play:
		plane.medalAmount += 1
		plane.medalDropCount += 1
	queue_free()
