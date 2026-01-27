extends Node
var sceneGame = preload("res://scenes scripts/game.tscn")
var sceneMenu = preload("res://scenes scripts/menu.tscn")
var ScenetoSpawn = sceneMenu

var originalTime : float = 0.1
var finalTime : float = originalTime
var time : float = originalTime
var foodEaten : int = 0
var score : int = 0
var spriteFrame : int = 0
var highScore : int
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
var sceneDir

signal tick
signal reverse
signal spawnScene
signal changeScene

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

#tick system
func _process(delta: float) -> void:
	#makes time goes up
	time +=  delta
	
	if !hurting:
		#resets timer and emit tick signal
		if time >= finalTime and moveStart or reversing and time >= finalTime / 2:
			time = 0
			tick.emit()
			
			#counts down special food timer
			if foodTime > 0:
				foodTime -= 1
			
			#sets special food sprite frame
			if foodTime <= 0:
				spriteFrame = randi() % 6

#activates reverse
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
		reverse.emit()
	if event.is_action_released("action2"):
		reversing = false

#runs when snake dies
func hurt():
	hurting = true
	for i in range(4):
		seeable = !seeable
		await get_tree().create_timer(0.15).timeout
		seeable = !seeable
		await get_tree().create_timer(0.23).timeout
	hurting = false
	ScenetoSpawn = sceneMenu
	changeScene.emit()
	if score > highScore:
		highScore = score
	reset()	
	
