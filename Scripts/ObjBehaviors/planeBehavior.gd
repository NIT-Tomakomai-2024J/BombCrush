extends CharacterBody3D

@export var medal_scene: PackedScene
@export var bomb_scene: PackedScene
@export var aim_missile_scene: PackedScene
@export var missile_scene: PackedScene


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

var existingMedalsAmount = 0

var medalDropCount = 0
var lastMedalCount = 0
var numberOfCoinsInserted = 0
var numberOfBombsDropped = 0
var jackpotCount = 0

var jackpotGauge = 0
var chosenOne:bool = false


# シグナル
@onready var setup:Node3D= get_node("/root/Node3D")
#setup.game_end.connect(showResult)

# 照準
@onready var targetingEntity = get_node("../TargetingEntity")
# UI nodes
@onready var controlUI:Control = get_node("../CanvasLayer/Control")
# ゲーム中に表示するUI
@onready var gameUI:CanvasLayer = controlUI.get_node("GameUI")
@onready var amountLabel:Label = gameUI.get_node("AmountLabel")
@onready var timerLabel:Label = gameUI.get_node("TimerLabel")
# ポーズ画面
@onready var pauseUI:CanvasLayer = controlUI.get_node("PauseUI")
# リザルト画面
@onready var result:CanvasLayer = controlUI.get_node("Result")
@onready var resultLabel:Label = result.get_node("ResultLabel")

@onready var gameTimer:Timer = get_node("GameTimer")

# ゲームのプレイ中であるかどうか
var game_play:bool = false

func _ready() -> void:
	gameUI.visible = false
	pauseUI.visible = false
	result.visible = false
	setup.game_start.connect(game_start)
	setup.game_end.connect(showResult)

func game_start() -> void:
	# 初期化
	game_play = true
	gameUI.visible = true
	medalAmount = 20
	bombAmount = 20
	medalDropCount = 0
	numberOfBombsDropped = 0
	numberOfCoinsInserted = 0
	jackpotCount = 0
	jackpotGauge = 0
	gameTimer.start(300) # 5分間のタイマーを開始

# リザルト表示
func showResult() -> void:
	lastMedalCount = medalAmount
	game_play = false
	resultLabel.text = "投入されたメダルの数:%d\n投下したボムの数:%d\n落としたメダルの数:%d\nジャックポットに入った回数:%d\n最終メダル数:%d" % [numberOfCoinsInserted, numberOfBombsDropped, medalDropCount, jackpotCount, lastMedalCount]

func _process(_delta: float) -> void:
	# 表示
	amountLabel.text = "Medal: %d\nBomb: %d" % [medalAmount, bombAmount]
	timerLabel.text = "残りプレイ時間 %d:%02d" % [int(gameTimer.time_left/60), int(gameTimer.time_left)%60]
	# メダル数を一定以上に維持
	if existingMedalsAmount < 300:
		var rand_pos = Vector3(randf_range(0.8, 1.0), 1, randf_range(-0.7, 0.7))
		var medal = medal_scene.instantiate()
		medal.position = rand_pos
		get_node("..").add_child(medal)


func _physics_process(_delta: float) -> void:
	x+=1
	var direction = Vector3.ZERO
	direction.z = -1
	if position.z <= -1.105:
		global_position = Vector3 (global_position.x,global_position.y,1.05)
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	move_and_slide()


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("drop"):
		if game_play == true:
			object = null
			print("Dropping...")
			if medalAmount >= 1 && chosenOne == false:
				object = medal_scene.instantiate()
				medalAmount -= 1
				numberOfCoinsInserted += 1
			elif medalAmount >= 10 && chosenOne == true:
				object = bomb_scene.instantiate()
				medalAmount -= 10
				numberOfBombsDropped += 1
			else:
				print("No items left to drop!")
			if object != null:
				get_node("..").add_child(object)
				object.global_position = Vector3(targetingEntity.global_position.x, global_position.y, targetingEntity.global_position.z)
	
	if event.is_action_pressed("select_previous_item") or event.is_action_pressed("select_next_item"):
		chosenOne = !chosenOne
		
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
