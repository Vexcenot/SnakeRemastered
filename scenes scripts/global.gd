extends Node
var originalTime = 0.1
var finalTime : float = originalTime
var time : float = originalTime
var currentDirection : String = "where the player is currently facing"
var reversing : bool = false
var moveStart : bool = false
signal tick
signal reverse


func _process(_delta: float) -> void:
	time += _delta
	if time >= finalTime and moveStart:
		time = 0
		tick.emit()
	#print(time)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
		reverse.emit()
	if event.is_action_released("action2"):
		reversing = false
