extends Node
var finalTime : float = 0.3
var time : float = 0
var currentDirection : String = "where the player is currently facing"
var reversing = false
signal tick


func _process(_delta: float) -> void:
	time += _delta
	if time >= finalTime:
		time = 0
		tick.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
	if event.is_action_released("action2"):
		reversing = false
