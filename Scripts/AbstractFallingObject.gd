@abstract class_name AbstractFallingObject extends RigidBody3D

var target_velocity = Vector3.ZERO
var force = Vector3.ZERO
	
func bombed(bombPosition: Vector3) -> void:
	force = global_position - bombPosition
	force = force.normalized()
	apply_impulse(force * 10, Vector3.ZERO)  # Apply force to the object

@abstract func _falling() -> void

func _process(_delta: float) -> void:
	if global_position.y < 0 and get_parent() != null:
		_falling()
