extends Sprite2D

enum {stop, up, down, left, right}
@export var turn : int
@export var direction : int
@export var nextDirection : int
@export var lastTail : bool = false
var turning : bool = false
var full : bool = false #make this true if cant update upon spawn on player script

#func _process(delta: float) -> void:
	#print(global_position)

func _ready() -> void:
	Global.tick.connect(update)
	update()
	if lastTail:
		$StaticBody2D/straightCol.disabled = true
	else:
		$StaticBody2D/straightCol.disabled = false

 
func update():
	
	#print(direction, nextDirection)
	visible = true
		#print(direction, nextDirection)
		
	if direction != nextDirection and direction != stop:
		turning = true #true
	else:
		turning = false
	if turning:
		$StaticBody2D/turnCol.disabled = false
		$StaticBody2D/straightCol.disabled = true
		if lastTail:
			pass
		elif full:
			frame = 7
		else:
			frame = 3
	else:
		$StaticBody2D/turnCol.disabled = true
		$StaticBody2D/straightCol.disabled = false
		if lastTail:
			frame = 0
		elif full:
			frame = 6
		else:
			frame = 1
	rotation()

func rotation():
	if turning and not lastTail:
		if direction == up:
			if nextDirection == left:
				global_rotation = deg_to_rad(0)
				flip_h = true
				flip_v = false
			else:
				global_rotation = deg_to_rad(0)
				flip_h = false
				flip_v = false
		if direction == down:
			if nextDirection == left:
				global_rotation = deg_to_rad(180)
				flip_h = false
				flip_v = false
			else:
				global_rotation = deg_to_rad(0)
				flip_h = false
				flip_v = true
		if direction == right:
			if nextDirection == up:
				global_rotation = deg_to_rad(90)
				flip_h = true
				flip_v = false
			else:
				global_rotation = deg_to_rad(90)
				flip_h = false
				flip_v = false
		if direction == left:
			if nextDirection == up:
				global_rotation = deg_to_rad(-90)
				flip_h = false
				flip_v = false
			else:
				global_rotation = deg_to_rad(90)
				flip_h = false
				flip_v = true
	else:
		match nextDirection:
			up:
				global_rotation = deg_to_rad(-90) 
				flip_h = false
				flip_v = false

			down:
				global_rotation = deg_to_rad(90)   
				flip_h = false
				flip_v = true

			left:
				global_rotation = deg_to_rad(0)  
				flip_h = true
				flip_v = false

			right:
				global_rotation = deg_to_rad(0)
				flip_h = false
				flip_v = false
