extends CharacterBody3D

@export var medal_scene: PackedScene
@export var bomb_scene: PackedScene

# How fast the player moves in meters per second.
@export var speed = 0.3
#0.3
# The downward acceleration when in the air, in meters per second squared.
var target_velocity = Vector3.ZERO
var x = 0
var object = null
# Amounts
var medalAmount = 20
var bombAmount = 1000
var missileAmount = 0

var jackpotGauge = 0
# ['Medal', 'Bomb', 'Missile']
var chosenOne = 0

@onready var amountLabel : Label = get_node("../CanvasLayer/Control/GameUI/AmountLabel")
@onready var ui : Control = get_node("../CanvasLayer/Control/PauseUI")
@onready var targetingEntity = get_node("../TargetingEntity")

"""
Medal:
Bomb:
Missile:
"""

func _process(_delta: float) -> void:
	amountLabel.text = "Medal: %d\nBomd: %d\nMissile: %d" % [medalAmount, bombAmount, missileAmount]

func _physics_process(_delta: float) -> void:
	x+=1
	var direction = Vector3.ZERO
	direction.z = -1
	if position.z <= -1.105:
		global_position = Vector3 (global_position.x,global_position.y,1.05)
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	move_and_slide()
	"""
	# レイを飛ばして衝突位置を取得
	var space_state = get_world_3d().direct_space_state
	var ray_length  = Vector3(0, -1000, 0)
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(global_position, global_position + ray_length))
	var pos = result.get("position")
	# 衝突位置にポインタを移動
	if pos != null and pos is Vector3:
		$Sprite3D.global_position.y = pos.y + 0.1
	"""

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("drop"):
		object = null
		print("Dropping...")
		if medalAmount >= 1 && chosenOne == 0:
			object = medal_scene.instantiate()
			medalAmount -= 1
		elif bombAmount >= 1 && chosenOne == 1:
			object = bomb_scene.instantiate()
			bombAmount -= 1
		elif chosenOne == 2:
			#object = missile_scene.instantiate()
			#missileAmount -= 1
			pass
		else:
			print("No items left to drop!")
		if object != null:
			get_node("..").add_child(object)
			object.global_position = Vector3(targetingEntity.global_position.x, global_position.y, targetingEntity.global_position.z)

	if event.is_action_pressed("select_previous_item"):
		chooseLeft()
	elif event.is_action_pressed("select_next_item"):
		chooseRight()
		
	if event.is_action_pressed("pause"):
		ui.visible = !ui.visible
		"""
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		"""

func _exit_game() ->void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
# Choose item
func chooseLeft():
	if chosenOne == 2:
		targetingEntity.set_automatic_target()
	chosenOne -= 1
	if chosenOne < 0:
		chosenOne = 2
	print("Chosen Item: %d" % chosenOne)
	if chosenOne == 2:
		targetingEntity.set_manual_target()

func chooseRight():
	if chosenOne == 2:
		targetingEntity.set_automatic_target()
	chosenOne += 1
	if chosenOne > 2:
		chosenOne = 0
	print("Chosen Item: %d" % chosenOne)
	if chosenOne == 2:
		targetingEntity.set_manual_target()
