extends Node
var finalTime : float = 1
var time : float = finalTime
var currentDirection : String = "where the player is currently facing"
var reversing = false
signal tick
signal reverse


func _process(_delta: float) -> void:
	time += _delta
	if time >= finalTime:
		time = 0
		tick.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
		reverse.emit()
	if event.is_action_released("action2"):
		reversing = false
