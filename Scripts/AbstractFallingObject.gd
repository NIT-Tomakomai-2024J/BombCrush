@abstract class_name AbstractFallingObject extends RigidBody3D
var target_velocity = Vector3.ZERO
var force = Vector3.ZERO
@onready
var node = get_node("../FallingArea")	
	
func bombed(bombPosition: Vector3) -> void:
	force = global_position - bombPosition
	force = force.normalized()
	apply_force(force * 10, Vector3.ZERO)  # Apply force to the object

#func _ready():
	#node.area_entered.connect(_falling)

@abstract func _falling()-> void

func _process(_delta: float) -> void:
	if global_position.y < 0:
		_falling()
