extends CharacterBody3D

@export var medal_scene: PackedScene
@export var bomb_scene: PackedScene

# How fast the player moves in meters per second.
@export var speed = 0.3
#0.3
# The downward acceleration when in the air, in meters per second squared.
var target_velocity = Vector3.ZERO
var x = 0
var medal = null
func _physics_process(_delta: float) -> void:
	x+=1
	var direction = Vector3.ZERO
	direction.z = -1
	#	$Pivot.basis = Basis.looking_at(direction)
	if position.z <= -0.505:
		global_position = Vector3 (global_position.x,global_position.y,0.45)
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	#if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
	#	target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		print("Dropping medal")
		medal = medal_scene.instantiate()
		medal.global_position = global_position
		get_node("..").add_child(medal)
		
