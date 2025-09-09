extends CharacterBody3D
@export var speed = 0.01
var target_velocity = Vector3.ZERO
var x = 0
var time = 0
func _physics_process(delta):
	time += 1
	x = time*0.01*PI
	#目標のglobal_position = 0.3+0.15*cos(x)
	self.velocity.x = 0.4+(0.45*cos(x) - global_position.x)
	move_and_slide()
