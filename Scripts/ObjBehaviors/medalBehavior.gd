extends "res://Scripts/AbstractFallingObject.gd"

@onready var plane = get_node("../Plane")
func _ready() -> void:
	plane.existingMedalsAmount += 1
func _falling():
	print("Falling...")
	if plane.game_play:
		plane.medalAmount += 1
		plane.medalDropCount += 1
	plane.existingMedalsAmount -= 1
	queue_free()
