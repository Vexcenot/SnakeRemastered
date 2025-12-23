extends Node
var originalTime = 0.2
var finalTime : float = originalTime
var time : float = originalTime
var currentDirection : String = "where the player is currently facing"
var reversing : bool = false
var moveStart : bool = false
var seeable : bool = true
signal tick
signal reverse


func _process(_delta: float) -> void:
	time += _delta
	if time >= finalTime and moveStart or reversing and time >= finalTime / 2:
		time = 0
		tick.emit()
	#print(time)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action2"):
		reversing = true
		reverse.emit()
	if event.is_action_released("action2"):
		reversing = false

func hurt():
	for i in range(4):
		seeable = !seeable
		await get_tree().create_timer(0.15).timeout
		seeable = !seeable
		await get_tree().create_timer(0.23).timeout

	get_tree().reload_current_scene()
