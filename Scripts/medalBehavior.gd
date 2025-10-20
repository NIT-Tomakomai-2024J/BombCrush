extends "res://Scripts/AbstractFallingObject.gd"

func _falling():
    print("Falling...")
    get_node("../Plane").addMedal()
    queue_free()