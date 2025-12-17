extends Sprite2D

enum {stop, up, down, left, right}
@export var turn : int
@export var direction : int
@export var nextDirection : int
@export var lastTail : bool = false
var turning = false

func _ready() -> void:
	Global.tick.connect(update)
 
func update():
	#print(direction, nextDirection)
	visible = true
	if direction != nextDirection and direction != stop:
		turning = true #true
	else:
		turning = false
	if turning:
		if lastTail:
			frame = 4
		else:
			frame = 3
	else:
		if lastTail:
			frame = 0
		else:
			frame = 1
	rotation()

func rotation():
	if turning:
		if direction == up:
			if nextDirection == left:
				global_rotation = deg_to_rad(90)
				flip_h = false
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
				global_rotation = deg_to_rad(-90)
				flip_h = false
				flip_v = false
		if direction == right:
			if nextDirection == up:
				global_rotation = deg_to_rad(180)
				flip_h = false
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
				global_rotation = deg_to_rad(0)
				flip_h = false
				flip_v = false
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
