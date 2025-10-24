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
var medalAmount = 0
var bombAmount = 0
var missileAmount = 0

var jackpotGauge = 0
# ['Medal', 'Bomb', 'Missile']
var chosenOne = 0
"""
Medal:
Bomb:
Missile:
"""

@onready var gameUI:CanvasLayer = get_node("../CanvasLayer/Control/GameUI")
@onready var amountLabel:Label = gameUI.get_node("AmountLabel")
@onready var timerLabel:Label = gameUI.get_node("TimerLabel")
@onready var pauseUI:CanvasLayer = get_node("../CanvasLayer/Control/PauseUI")
@onready var targetingEntity = get_node("../TargetingEntity")


@onready var gameTimer:Timer = get_node("GameTimer")

# ゲームのプレイ中であるかどうか
var game_play:bool = false

func _ready() -> void:
	gameUI.visible = false
	pauseUI.visible = false
	get_node("../").game_start.connect(game_start)

func game_start() -> void:
	game_play = true
	gameUI.visible = true
	medalAmount = 20
	bombAmount = 20
	gameTimer.start(300) # 5分間のタイマーを開始

# 表示
func _process(_delta: float) -> void:
	amountLabel.text = "Medal: %d\nBomd: %d\nMissile: %d" % [medalAmount, bombAmount, missileAmount]
	timerLabel.text = "残りプレイ時間 %d:%02d" % [int(gameTimer.time_left/60), int(gameTimer.time_left)%60]

func _physics_process(_delta: float) -> void:
	x+=1
	var direction = Vector3.ZERO
	direction.z = -1
	if position.z <= -1.105:
		global_position = Vector3 (global_position.x,global_position.y,1.05)
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	if not get_tree().paused:
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
		if object != null:
			get_node("..").add_child(object)
			object.global_position = Vector3(targetingEntity.global_position.x, global_position.y, targetingEntity.global_position.z)

	if event.is_action_pressed("select_previous_item"):
		chooseLeft()
	elif event.is_action_pressed("select_next_item"):
		chooseRight()
		
	# Pause
	if event.is_action_pressed("pause"):
		if game_play:
			get_tree().paused = !get_tree().paused
			pauseUI.visible = !pauseUI.visible
			gameTimer.paused = !gameTimer.paused	
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
