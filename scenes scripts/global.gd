extends Node
var finalTime : float = 0.3
var time : float = 0
var currentDirection : String = "where the player is currently facing"
signal tick


func _process(_delta: float) -> void:
	time += _delta
	if time >= finalTime:
		time = 0
		tick.emit()
