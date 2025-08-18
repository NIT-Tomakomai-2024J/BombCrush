extends StaticBody3D
@export var speed = 0.01
var target_velocity = Vector3.ZERO
var x = 0
func _physics_process(delta):
	x+=speed*PI
	#
	global_position = Vector3 (0.2+0.15*cos(x),global_position.y,global_position.z)
