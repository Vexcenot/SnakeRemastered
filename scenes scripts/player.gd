extends Node2D

@export var player2 : bool = false
@export var startDir = right
@export var minX = 4
@export var minY = 13
@export var maxX = 80
@export var maxY = 44
enum {stop, up, down, left, right}
enum {limitHor, limitVer ,limitUp, limitDown, limitLeft, limitRight}
var direction : int = stop
var tail = preload("res://scenes scripts/tail.tscn")
var full = preload("res://scenes scripts/fullArea.tscn")
var sFood = preload("res://scenes scripts/superFood.tscn")

var finalTime : float = 1
var time : float = 0
var moveDistance : int = 4
var eat : int = 0
var startLength : int = 6
var openJaw : int = 0
var limitDir : int = limitLeft
var readyStart : bool = false
var upBlocked : bool = false
var dnBlocked : bool = false
var rtBlocked : bool = false
var lfBlocked : bool = false
var teleport : bool = false
var pain : bool = false

var positionHistory : Array = []
var moveOrders : Array = []
var tailSegments : Array = []
var directionHistory : Array = []
var turnHistory : Array = []
var eatHistory : Array = []



func _ready() -> void:
	if !Global.multiplayerMode and player2:
		queue_free()
	Global.tick.connect(update)
	startTeleport()
	
	
func _process(_delta: float) -> void:
	#see if you can make this on update
	if openJaw >= 1:
		$headSprite.frame = 5
	else:
		await get_tree().create_timer(0.1).timeout
		if openJaw <= 0:
			$headSprite.frame = 2
	visible = Global.seeable
	


#spawns tail on game start
#FIX THIS
func startTeleport():
	await get_tree().process_frame
	position.x -= moveDistance*startLength
	eat += startLength
	direction = startDir
	positionHistory.append(global_position)
	positionHistory.append(global_position)
	for i in startLength:
		update()
	direction = stop
	limitDir = limitLeft
	readyStart = true

#runs every tick
func update():
	#print(Global.foodEaten)
	if !Global.hurting:
		colCheck()
		
		move()
		
		spawnTail()
		
		updateTail()
	
	#print("tur ", turnHistory)
	#print("dir ", directionHistory)

#sheesh make this better ffs with 2d vectors or some shit
func _input(event: InputEvent) -> void:
	# make it swap controls if 2p mode enabled
	if moveOrders.size() < 4 and !Global.reversing and !Global.hurting:
		
		if (
		event.is_action_pressed("up") and !player2 or
		event.is_action_pressed("up2") and !Global.multiplayerMode or
		event.is_action_pressed("up2") and player2
		):
			if moveOrders.back() != up:
				moveOrders.append(up)
				Global.moveStart = true
				
		if (
		event.is_action_pressed("down") and !player2 or
		event.is_action_pressed("down2") and !Global.multiplayerMode or
		event.is_action_pressed("down2") and player2
		):
			if moveOrders.back() != down:
				moveOrders.append(down)
				Global.moveStart = true
				
		if (
		event.is_action_pressed("left") and !player2 or
		event.is_action_pressed("left2") and !Global.multiplayerMode or
		event.is_action_pressed("left2") and player2
		):
			if moveOrders.back() != left:
				moveOrders.append(left)
				Global.moveStart = true
				
		if (
		event.is_action_pressed("right") and !player2 or
		event.is_action_pressed("right2") and !Global.multiplayerMode or
		event.is_action_pressed("right2") and player2
		):
			if moveOrders.back() != right:
				moveOrders.append(right)
				Global.moveStart = true

		# debug
	if event.is_action_pressed("action"):
		eat += 1
	# Check for action2 button states
	if event.is_action_pressed("action3"):
		direction = stop
	if event.is_action_pressed("sprint"):
		Global.finalTime = Global.originalTime * 0.1
	if event.is_action_released("sprint"):
		Global.finalTime = Global.originalTime
		


#AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

# spawns tail at head current pos and adds it to array
func spawnTail():
	#pushes full sprite to array then spawn tails
	if eat > 0 and direction != stop:
		eat -= 1
		
		if readyStart:
			eatHistory.append(true)

		var spawn = tail.instantiate()
		spawn.global_position = global_position
		tailSegments.push_front(spawn)  # Add new tail segment to array for tracking
		if directionHistory.size() > 1:
			spawn.direction = directionHistory[-2]
			spawn.nextDirection = directionHistory[-1]
		#sets last tail
		if tailSegments.size() <= 1:
			spawn.lastTail = true
		if readyStart:
			spawn.full = true
		
		# Add as child of the player (this node) instead of get_parent()
		add_child(spawn)
		
	#pushes empty stomach to array
	else:
		eatHistory.append(false)

#REALLY FIX THIS
# Moves tails
func updateTail():
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
				
			#full tail
			var eatIndex = eatHistory.size() - stepsAgo
			if eatIndex >= 0:
				var segmentEat = eatHistory[eatIndex]
				tailSegments[i].full = segmentEat

#AAAAAAAAA end


# takes move orders and moves the player every tick
func move():
	if Global.reversing and !Global.hurting:
		# Reverse movement - move backwards through position history
		if positionHistory.size() > 0:
			# Get the last position from history (before current position)
			var lastPosIndex = positionHistory.size() - 3
			var lastDirIndex = directionHistory.size() - 2
			if lastPosIndex >= tailSegments.size():
				global_position = positionHistory[lastPosIndex]
				direction = directionHistory[lastDirIndex]

				# Update direction based on movement
				if positionHistory.size() > 0:
					posRot()
							
					#this one is for tail segment
					direction = directionHistory.pop_back()
				
				# Remove the current position from history (pop back)
				if positionHistory.size() > 0:
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
		posRot()

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
	
	
#moves and flip and turns
func posRot():
	match direction:
		up:
			if upBlocked:
				hurt()
			else:
				#teleports down if to up
				if global_position.y <= minY: 
					global_position.y = maxY + 4
				position.y -= moveDistance
				$headSprite.rotation = deg_to_rad(-90)
				$headSprite.flip_h = false
				$headSprite.flip_v = false
				limitDir = limitVer
		down:
			if dnBlocked:
				hurt()
			else:
				#teleports up if too down
				if global_position.y >= maxY: 
					global_position.y = minY - 5
				position.y += moveDistance
				$headSprite.rotation = deg_to_rad(90)
				$headSprite.flip_h = false
				$headSprite.flip_v = true
				limitDir = limitVer
		right:
			if rtBlocked:
				hurt()
			else:
				#teleports left if too right
				if global_position.x >= maxX:
					global_position.x = minX - 4
				position.x += moveDistance
				$headSprite.rotation = deg_to_rad(0)
				$headSprite.flip_h = false
				$headSprite.flip_v = false
				limitDir = limitHor
		left:
			if lfBlocked:
				hurt()
			else:
				#teleports right if too left
				if global_position.x <= minX: 
					global_position.x = maxX + 4
				position.x -= moveDistance
				$headSprite.rotation = deg_to_rad(0)
				$headSprite.flip_h = true
				$headSprite.flip_v = false
				limitDir = limitHor


#snake killer
func hurt():
	pass
	pain = true
	direction = stop
	Global.hurt()
	
	
	
#checks surrounding for collisions`
func colCheck():
	if $up.has_overlapping_bodies():
		upBlocked = true
	else:
		upBlocked = false
	if $down.has_overlapping_bodies():
		dnBlocked = true
	else:
		dnBlocked = false
	if $right.has_overlapping_bodies():
		rtBlocked = true
	else:
		rtBlocked = false
	if $left.has_overlapping_bodies():
		lfBlocked = true
	else:
		lfBlocked = false


#food detect
func _on_head_area_area_entered(area: Area2D) -> void:
	if area.name == "food":
		eat += 1
		#if Global.foodEaten >= 5:
			#var scene = sFood.instantiate()  # This creates the instance
			## Add it to the scene tree instead of calling instantiate() again
			#get_parent().add_child(scene)  # Or whatever parent node you want
		#print(Global.foodEaten)

func _on_head_buffer_area_entered(area: Area2D) -> void:
	if area.name == "food":
		openJaw += 1

func _on_head_buffer_area_exited(area: Area2D) -> void:
	if area.name == "food" and openJaw > 0:
		openJaw -= 1
