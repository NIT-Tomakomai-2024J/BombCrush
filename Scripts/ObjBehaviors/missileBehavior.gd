extends CharacterBody3D

@onready var explosion_area = $Area3D
@onready var setup:Node3D= get_node("../")
var target_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	# シグナル
	setup.game_end.connect(free)

func _physics_process(_delta: float) -> void:
	velocity = (target_position - global_position).normalized() * 3
	global_rotation = Vector3(atan2(target_position.x, target_position.z),atan2(target_position.y,target_position.z),atan2(target_position.x,target_position.z))
	print(target_position)
	move_and_slide()

func free() -> void:
	queue_free()

func bomb():
	print("BOOM!")
	if explosion_area == null:
		print("Area3D node not found!")
		return
	for body in explosion_area.get_overlapping_bodies():
		if body is AbstractFallingObject:
			body.bombed(global_position)
	queue_free()

func _falling():
	queue_free()