extends Node2D

enum {stop, up, down, left, right}
var direction : int = stop
var tail = preload("res://scenes scripts/tail.tscn")

var finalTime : float = 1
var time : float = 0
var moveDistance : int = 100
var eat : int = 0
var reversing : bool = false  # NEW: Track if we're reversing

var positions : Array = []
var moveOrders : Array = []
var tailSegments : Array = [] 
var directionHistory : Array = []

func _ready() -> void:
	move()


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
	# append move orders (only if not reversing)
	if moveOrders.size() < 4 && !reversing:
		if event.is_action_pressed("ui_up"):
			if moveOrders.size() == 0 || moveOrders.back() != up:
				moveOrders.append(up)
		if event.is_action_pressed("ui_down"):
			if moveOrders.size() == 0 || moveOrders.back() != down:
				moveOrders.append(down)
		if event.is_action_pressed("ui_left"):
			if moveOrders.size() == 0 || moveOrders.back() != left:
				moveOrders.append(left)
		if event.is_action_pressed("ui_right"):
			if moveOrders.size() == 0 || moveOrders.back() != right:
				moveOrders.append(right)
		# debug
	if event.is_action_pressed("action"):
		eat += 1
	# Check for action2 button states
	if event.is_action_pressed("action2"):
		reversing = true
	if event.is_action_released("action2"):
		reversing = false

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
	if reversing:
		# Reverse movement - move backwards through position history
		if positions.size() > 0:
			# Get the last position from history (before current position)
			var lastPosIndex = positions.size() - 2
			if lastPosIndex >= tailSegments.size():
				global_position = positions[lastPosIndex]
				
				# Update direction based on movement
				if positions.size() >= 2:
					var currentPos = positions[positions.size() - 1]
					var prevPos = positions[positions.size() - 2]
					
					# Determine direction from previous to current position
					if prevPos.x < currentPos.x:
						direction = right
						$SmolSnake.rotation = 0
						$SmolSnake.flip_h = false
					elif prevPos.x > currentPos.x:
						direction = left
						$SmolSnake.rotation = 0
						$SmolSnake.flip_h = true
					elif prevPos.y < currentPos.y:
						direction = down
						$SmolSnake.rotation = deg_to_rad(90)
						$SmolSnake.flip_h = false
					elif prevPos.y > currentPos.y:
						direction = up
						$SmolSnake.rotation = deg_to_rad(-90)
						$SmolSnake.flip_h = false
				
				# Remove the current position from history (pop back)
				if positions.size() > 1:
					positions.pop_back()
					if directionHistory.size() > 0:
						directionHistory.pop_back()
	else:
		# Original forward movement
		if moveOrders.size() > 0:
			direction = moveOrders.pop_front()
		match direction:
			up:
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
