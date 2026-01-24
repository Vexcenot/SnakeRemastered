extends Node
var originalTime : float = 0.1
var finalTime : float = originalTime
var time : float = originalTime
var foodEaten : int = 0
var score : int = 0
var spriteFrame : int = 0
var foodTime : float = 0
var setTime : float = 20
var currentDirection : String = "where the player is currently facing"
var reversing : bool = false
var moveStart : bool = false
var seeable : bool = true
var hurting : bool = false
var multiplayerMode : bool = false
var playerX : float = 0
var sFoodActive : bool = false

signal tick
signal reverse

func reset():
	finalTime = originalTime
	time = originalTime
	foodEaten = 0
	foodTime = 0
	currentDirection = "where the player is currently facing"
	reversing = false
	moveStart = false
	seeable = true
	hurting = false
	score = 0

func _process(delta: float) -> void:
	time +=  delta
	if foodTime > 0:
		foodTime -= delta
	if !hurting:
		if time >= finalTime and moveStart or reversing and time >= finalTime / 2:
			time = 0
			tick.emit()
			if foodTime > 0:
				foodTime -= 1
			if foodTime <= 0:
				spriteFrame = randi() % 6


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
		reverse.emit()
	if event.is_action_released("action2"):
		reversing = false

func hurt():
	hurting = true
	for i in range(4):
		seeable = !seeable
		await get_tree().create_timer(0.15).timeout
		seeable = !seeable
		await get_tree().create_timer(0.23).timeout
	hurting = false
	
#make this go back to title screen after showing score screen
	reset()
	get_tree().reload_current_scene()
	#get_tree().change_scene_to_file("res://scenes scripts/TitleScreen.tscn")
