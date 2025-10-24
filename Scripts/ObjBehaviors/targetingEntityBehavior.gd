extends CharacterBody3D
var target_velocity = Vector3.ZERO


func _physics_process(_delta: float) -> void:
    # 当たり判定を飛行機の元に移動
	var direction : Vector3 = get_node("../Plane").global_position
	var target : Vector3 = (direction - global_position).normalized()
	velocity = Vector3(target.x,0,target.z) *3
	move_and_slide()
	# レイを飛ばして衝突位置を取得
	var space_state = get_world_3d().direct_space_state
	var ray_length  = Vector3(0, -1000, 0)
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(global_position, global_position + ray_length,collision_mask, [self]))
	var pos = result.get("position")
	# 衝突位置にポインタを移動
	if pos != null and pos is Vector3:
		#$Aim.global_position.y = pos.y + 0.1
		$Aim.global_position = Vector3(global_position.x, pos.y + 0.1, global_position.z)
	#
