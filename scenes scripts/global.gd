extends Node
var originalTime = 0.5
var finalTime : float = originalTime
var time : float = originalTime
var foodEaten : int = 0
var foodTime : float = 0
var currentDirection : String = "where the player is currently facing"
var reversing : bool = false
var moveStart : bool = false
var seeable : bool = true
var hurting : bool = false
var multiplayerMode : bool = false

signal tick
signal reverse
signal sFood

func reset():
	finalTime = originalTime
	time = originalTime
	foodEaten = 1
	foodTime = 0
	currentDirection = "where the player is currently facing"
	reversing = false
	moveStart = false
	seeable = true
	hurting = false

func _process(delta: float) -> void:
	time +=  delta
	if foodTime > 0:
		foodTime -= delta
	if time >= finalTime and moveStart or reversing and time >= finalTime / 2:
		time = 0
		tick.emit()
		if foodEaten >= 5:
			startSFood()
			print("fuck1")


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
	reset()
	get_tree().reload_current_scene()
	
	
func startSFood():
	#foodTime = 15
	#foodEaten = 0
	sFood.emit()
