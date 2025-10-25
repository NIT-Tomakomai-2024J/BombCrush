@abstract class_name AbstractFallingObject extends RigidBody3D


var target_velocity = Vector3.ZERO
var force = Vector3.ZERO
var falled = false
@onready var setup:Node3D= get_node("/root/Node3D")
@onready var plane = get_node("../Plane")
var _MedalBehaviorScript = preload("res://Scripts/ObjBehaviors/MedalBehavior.gd")

func _ready() -> void:
	# シグナル
	setup.game_end.connect(free)
	if self.get_script() == _MedalBehaviorScript:
		plane.existingMedalsAmount -= 1

func free() -> void:
	queue_free()

func bombed(bombPosition: Vector3) -> void:
	force = global_position - bombPosition
	force = force.normalized()
	apply_impulse(force * 10, Vector3.ZERO)  # Apply force to the object

@abstract func _falling() -> void

func _process(_delta: float) -> void:
	if global_position.y < 0 and get_parent() != null && !falled:
		_falling()
		falled = true