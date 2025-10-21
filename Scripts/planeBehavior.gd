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

@onready var amountLabel : Label = get_node("../CanvasLayer/Control/AmountLabel")

"""
Medal:
Bomb:
Missile:
"""
func _ready():
	changeAmount()

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
		changeAmount()
		if object != null:
			get_node("..").add_child(object)
			object.global_position = global_position

	if event.is_action_pressed("select_previous_item"):
		chooseLeft()
	elif event.is_action_pressed("select_next_item"):
		chooseRight()
		
	if event.is_action_pressed("exit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()

# Choose item
func chooseLeft():
	chosenOne -= 1
	if chosenOne < 0:
		chosenOne = 2
	print("Chosen Item: %d" % chosenOne)
	changeAmount()

func chooseRight():
	chosenOne += 1
	if chosenOne > 2:
		chosenOne = 0
	print("Chosen Item: %d" % chosenOne)
	changeAmount()

# Add amounts
func addMedal():
	medalAmount += 1
	print("Medal Amount: %d" % medalAmount)
	changeAmount()

func addBomb():
	bombAmount += 1
	print("Bomb Amount: %d" % bombAmount)
	changeAmount()

func addMissile():
	missileAmount += 1
	print("Missile Amount: %d" % missileAmount)
	changeAmount()

func addJackpot(amount):
	jackpotGauge += amount
	print("Jackpot Gauge: %d" % jackpotGauge)

#func changeAmount():
#	amountLabel.text = "Medal: %d\nBomb: %d\nMissile: %d" % [medalAmount, bombAmount, missileAmount]

func changeAmount():
	amountLabel.text = "Medal: %d\nBomb: %d\nMissile: %d\nChooseNum:%d" % [medalAmount, bombAmount, missileAmount,chosenOne]
		
