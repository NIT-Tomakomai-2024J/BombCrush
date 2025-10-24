extends CharacterBody3D
var target_velocity = Vector3.ZERO
@onready var plane = get_node("../Plane")
var manual_target : Vector3 = Vector3.ZERO
var pos = null
func _ready() -> void:
	pass
func _physics_process(_delta: float) -> void:
	global_position.y = plane.global_position.y + 0.1
	# 当たり判定を飛行機の元に移動
	var plane_position : Vector3 = plane.global_position
	var distance : float = global_position.distance_to(plane_position)
	if distance > 0.1:
		velocity = (plane_position - global_position).normalized() * 5
	else:
		velocity = (plane_position - global_position).normalized()

	move_and_slide()
	# レイを飛ばして衝突位置を取得
	var space_state = get_world_3d().direct_space_state
	var ray_length  = Vector3(0, -1000, 0)
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(global_position, global_position + ray_length,collision_mask, [self]))
	pos = result.get("position")
	# 衝突位置にポインタを移動
	if pos != null and pos != Vector3.ZERO and pos is Vector3:
		#$Aim.global_position.y = pos.y + 0.1
		$Aim.global_position = Vector3(global_position.x, pos.y + 0.1, global_position.z)
	#

func set_manual_target():
	global_position = manual_target
	velocity = Vector3.ZERO

func set_automatic_target():
	manual_target = global_position
