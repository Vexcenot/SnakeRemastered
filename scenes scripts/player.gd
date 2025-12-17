extends Node2D


enum {stop, up, down, left, right}
enum {limitHor, limitVer ,limitUp, limitDown, limitLeft, limitRight}
var direction : int = stop
var tail = preload("res://scenes scripts/tail.tscn")

var finalTime : float = 1
var time : float = 0
var moveDistance : int = 6
var eat : int = 0
var limitDir : int = limitLeft

var positionHistory : Array = []
var moveOrders : Array = []
var tailSegments : Array = [] 
var directionHistory : Array = []
var turnHistory : Array = []



func _ready() -> void:
	moveOrders.append(right)
	eat += 2
	positionHistory.append(global_position)
	directionHistory.append(direction)
	turnHistory.append(0)
	Global.tick.connect(update)


func update():
	move()
	updateTailPositions()
	spawnTail()
	print("tur ", turnHistory)
	print("dir ", directionHistory)



func _input(event: InputEvent) -> void:
	# append move orders (only if not Global.reversing)
	if moveOrders.size() < 4 and !Global.reversing:
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
		tailSegments.push_front(spawn)  # Add new tail segment to array for tracking
		
		#sets last tail
		if tailSegments.size() <= 1:
			tailSegments.back().lastTail = true


#update this shit to be less stupid VVVV
# Moves tails
func updateTailPositions():
	# Each tail segment follows the head's position from (i+1) steps ago
	for i in range(tailSegments.size()):
		var stepsAgo = i + 1
		var posIndex = positionHistory.size() - 1 - stepsAgo
		
		# Moves tail
		if posIndex >= 0:
			tailSegments[i].global_position = positionHistory[posIndex]
			
			# Get the direction from history for this tail segment's position
			var dirIndex = directionHistory.size() - 1 - stepsAgo
			if dirIndex >= 1:
				var segmentDirection = directionHistory[dirIndex]
				tailSegments[i].direction = segmentDirection
			
			#turns tail	
			var turIndex = directionHistory.size() - stepsAgo
			if turIndex >= 0:
				var segmentTurn = directionHistory[turIndex]
				tailSegments[i].nextDirection = segmentTurn

#AAAAAAAAA end


# takes move orders and moves the player every tick
func move():
	if Global.reversing:
		# Reverse movement - move backwards through position history
		if positionHistory.size() > 0:
			# Get the last position from history (before current position)
			var lastPosIndex = positionHistory.size() - 2
			var lastDirIndex = directionHistory.size() - 2
			if lastPosIndex >= tailSegments.size():
				global_position = positionHistory[lastPosIndex]
				direction = directionHistory[lastDirIndex]

				# Update direction based on movement
				if positionHistory.size() >= 2:
					match direction:
						up:
							$headSprite.rotation = deg_to_rad(-90) 
							$headSprite.flip_h = false
							limitDir = limitVer
						down:
							$headSprite.rotation = deg_to_rad(90)   
							$headSprite.flip_h = false
							limitDir = limitVer
						left:
							$headSprite.rotation = deg_to_rad(0) 
							$headSprite.flip_h = true
							limitDir = limitHor
						right:
							$headSprite.rotation = deg_to_rad(0) 
							$headSprite.flip_h = false
							limitDir = limitHor
							
					#this one is for tail segment
					direction = directionHistory.pop_back()
				
				# Remove the current position from history (pop back)
				if positionHistory.size() > 1:
					positionHistory.pop_back()
					turnHistory.pop_back()


	else:
		# Normal foward movement
		if moveOrders.size() > 0:
			var storedMove = moveOrders.pop_front()
			#skips move if same or in opposite direction
			#look into making this a dictionary
			if (
				direction == storedMove or
				storedMove == up and limitDir == limitVer or
				storedMove == up and limitDir == limitUp or
				storedMove == down and limitDir == limitVer or
				storedMove == down and limitDir == limitDown or
				storedMove == left and limitDir == limitHor or
				storedMove == left and limitDir == limitLeft or
				storedMove == right and limitDir == limitHor or
				storedMove == right and limitDir == limitRight
				):
				pass
			else:
				direction = storedMove
		
		#Apply position & direction
		match direction:
			up:
				position.y -= moveDistance
				$headSprite.rotation = deg_to_rad(-90) 
				$headSprite.flip_h = false
				$headSprite.flip_v = false
				limitDir = limitVer
			down:
				position.y += moveDistance
				$headSprite.rotation = deg_to_rad(90)   
				$headSprite.flip_h = false
				$headSprite.flip_v = true
				limitDir = limitVer
			left:
				position.x -= moveDistance
				$headSprite.rotation = deg_to_rad(0)  
				$headSprite.flip_h = true
				$headSprite.flip_v = false
				limitDir = limitHor
			right:
				position.x += moveDistance
				$headSprite.rotation = deg_to_rad(0)
				$headSprite.flip_h = false
				$headSprite.flip_v = false
				limitDir = limitHor

		# saves position to arrays after move
		if direction != stop:
			updateArrays()


#pushes updates to a buncha arrays
func updateArrays():
	if direction != directionHistory.back() and directionHistory.back() != stop:
		turnHistory.append(1)
	else:
		turnHistory.append(0)
	positionHistory.append(global_position)
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
