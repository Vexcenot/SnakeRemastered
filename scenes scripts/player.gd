extends Node2D

enum {stop, up, down, left, right}
var direction : int = stop
var tail = preload("res://scenes scripts/tail.tscn")

var finalTime : float = 1
var time : float = 0
var moveDistance : int = 100
var eat : int = 0

var positions : Array = []
var moveOrders : Array = []
var tailSegments : Array = [] 
var directionHistory : Array = []



func _process(delta: float) -> void:
	# tick timer
	time += delta
	if time >= finalTime:
		time = 0
		spawnTail()
		move()
		updateTailPositions()  
		print(directionHistory)

func _input(event: InputEvent) -> void:
	# append move orders
	if moveOrders.size() < 4:
		if event.is_action_pressed("ui_up"):
			if moveOrders.back() != up:
				moveOrders.append(up)
		if event.is_action_pressed("ui_down"):
			if moveOrders.back() != down:
				moveOrders.append(down)
		if event.is_action_pressed("ui_left"):
			if moveOrders.back() != left:
				moveOrders.append(left)
		if event.is_action_pressed("ui_right"):
			if moveOrders.back() != right:
				moveOrders.append(right)
		# debug
	if event.is_action_pressed("action"):
		eat += 1

# spawns tail at head current pos and adds it to array
func spawnTail():
	if eat > 0:
		eat -= 1
		var spawn = tail.instantiate() 
		get_parent().add_child(spawn)
		spawn.global_position = global_position
		tailSegments.append(spawn)  # Add new tail segment to array for tracking

# Moves tails
func updateTailPositions():
	# Each tail segment follows the head's position from (i+1) steps ago
	for i in range(tailSegments.size()):
		var stepsAgo = i + 1
		var posIndex = positions.size() - 1 - stepsAgo
		
		# Ensure we have enough history
		if posIndex >= 0:
			tailSegments[i].global_position = positions[posIndex]

# takes move orders and moves the player every tick
func move():
	if moveOrders.size() > 0:
		direction = moveOrders.pop_front()
	match direction:
		up:
			#add prev cur directions here
			position.y -= moveDistance
			$SmolSnake.rotation = deg_to_rad(-90) 
			$SmolSnake.flip_h = false
		down:
			position.y += moveDistance
			$SmolSnake.rotation = deg_to_rad(90)   
			$SmolSnake.flip_h = false
		left:
			position.x -= moveDistance
			$SmolSnake.rotation = 0
			$SmolSnake.flip_h = true
		right:
			position.x += moveDistance
			$SmolSnake.rotation = 0
			$SmolSnake.flip_h = false

	# saves position to array after move
	positions.append(global_position)
	directionHistory.append(direction)
	
	# NEW: Optional: Limit position history to avoid memory issues
	# Keep enough positions for all tail segments plus a buffer
	#var maxPositions = tailSegments.size() + 10
	#if positions.size() > maxPositions:
		#positions.remove_at(0)
