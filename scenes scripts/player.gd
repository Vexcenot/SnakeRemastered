extends Node2D

signal updateTexture
enum {stop, up, down, left, right}
var direction : int = stop
var tail = preload("res://scenes scripts/tail.tscn")

var finalTime : float = 1
var time : float = 0
var moveDistance : int = 100
var eat : int = 0
var reversing : bool = false  # NEW: Track if we're reversing
var limitHor : bool = false

var positions : Array = []
var moveOrders : Array = []
var tailSegments : Array = [] 
var directionHistory : Array = []
var turnHistory : Array = []

func _ready() -> void:
	positions.append(global_position)
	directionHistory.append(direction)
	turnHistory.append(0)

func _process(delta: float) -> void:
	# tick timer
	time += delta
	if time >= finalTime:
		time = 0
		move()
		spawnTail()
		updateTailPositions()  
		print(direction)
		#print("tur ", turnHistory)
		#print("dir ", directionHistory)

func _input(event: InputEvent) -> void:
	# append move orders (only if not reversing)
	if moveOrders.size() < 4 && !reversing:
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
	# Check for action2 button states
	if event.is_action_pressed("action2"):
		reversing = true
	if event.is_action_released("action2"):
		reversing = false
	if event.is_action_pressed("action3"):
		direction = stop




#AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
# spawns tail at head current pos and adds it to array
func spawnTail():
	if eat > 0 and direction != stop:
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
			
			# Get the direction from history for this tail segment's position
			var dirIndex = directionHistory.size() - 1 - stepsAgo
			if dirIndex >= 0:
				var segmentDirection = directionHistory[dirIndex]
				
				# Apply rotation and flip based on direction
				match segmentDirection:
					up:
						tailSegments[i].get_node("tailSprite").rotation = deg_to_rad(-90)
						tailSegments[i].get_node("tailSprite").flip_h = false
					down:
						tailSegments[i].get_node("tailSprite").rotation = deg_to_rad(90)
						tailSegments[i].get_node("tailSprite").flip_h = false
					left:
						tailSegments[i].get_node("tailSprite").rotation = 0
						tailSegments[i].get_node("tailSprite").flip_h = true
					right:
						tailSegments[i].get_node("tailSprite").rotation = 0
						tailSegments[i].get_node("tailSprite").flip_h = false
#AAAAAAAAA end




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
						$headSprite.rotation = 0
						$headSprite.flip_h = false
					elif prevPos.x > currentPos.x:
						direction = left
						$headSprite.rotation = 0
						$headSprite.flip_h = true
					elif prevPos.y < currentPos.y:
						direction = down
						$headSprite.rotation = deg_to_rad(90)
						$headSprite.flip_h = false
					elif prevPos.y > currentPos.y:
						direction = up
						$headSprite.rotation = deg_to_rad(-90)
						$headSprite.flip_h = false
				
				# Remove the current position from history (pop back)
				if positions.size() > 1:
					positions.pop_back()
					if directionHistory.size() > 0:
						directionHistory.pop_back()
	else:
		# Original forward movement
		if moveOrders.size() > 0:
			var storedMove = moveOrders.pop_front()
			if direction == storedMove or storedMove == up and limitHor == false or storedMove == down and limitHor == false or storedMove == left and limitHor == true or storedMove == right and limitHor == true:
				pass
			else:
				direction = storedMove
		match direction:
			up:
				position.y -= moveDistance
				$headSprite.rotation = deg_to_rad(-90) 
				$headSprite.flip_h = false
				limitHor = false
			down:
				position.y += moveDistance
				$headSprite.rotation = deg_to_rad(90)   
				$headSprite.flip_h = false
				limitHor = false
			left:
				position.x -= moveDistance
				$headSprite.rotation = 0
				$headSprite.flip_h = true
				limitHor = true
			right:
				position.x += moveDistance
				$headSprite.rotation = 0
				$headSprite.flip_h = false
				limitHor = true

		# saves position to arrays after move
		if direction != stop:
			updateArrays()

func updateArrays():
	if direction != directionHistory.back() and directionHistory.back() != stop:
		turnHistory.append(1)
	else:
		turnHistory.append(0)
	positions.append(global_position)
	directionHistory.append(direction)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	# NEW CODE: LIMIT DIRECTION HISTORY TO MATCH POSITIONS HISTORY
	# Keep direction history in sync with positions history
	# If we're limiting positions, we should also limit directionHistory
	# (Uncomment if you uncomment the positions limiting code below)
	#if directionHistory.size() > positions.size():
		#directionHistory.remove_at(0)
	# END NEW CODE
	
	# NEW: Optional: Limit position history to avoid memory issues
	# Keep enough positions for all tail segments plus a buffer
	#var maxPositions = tailSegments.size() + 10
	#if positions.size() > maxPositions:
		#positions.remove_at(0)
