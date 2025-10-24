extends RigidBody3D

func _falling():
	print("Falling...")
	get_node("../Plane").addJackpot(1)
	queue_free()