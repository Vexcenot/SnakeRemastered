extends Sprite2D

enum {stop, up, down, left, right}
@export var turn : int
@export var direction : int
@export var nextDirection : int
var turning = false

func _ready() -> void:
	Global.tick.connect(update)
 
func update():
	#print(direction, nextDirection)
	visible = true
	if direction != nextDirection and direction != stop:
		turning = true
	else:
		turning = false
	if turning:
		frame = 3
	else:
		frame = 1
	rotation()

func rotation():
	if turning:
		if direction == up:
			if nextDirection == left:
				global_rotation = deg_to_rad(0)
			else:
				global_rotation = deg_to_rad(-90)
		if direction == down:
			if nextDirection == left:
				global_rotation = deg_to_rad(90)
			else:
				global_rotation = deg_to_rad(180)
		if direction == right:
			if nextDirection == up:
				global_rotation = deg_to_rad(90)
			else:
				global_rotation = deg_to_rad(0)
		if direction == left:
			if nextDirection == up:
				global_rotation = deg_to_rad(-180)
			else:
				global_rotation = deg_to_rad(-90)
	else:
		match direction:
			up:
				global_rotation = deg_to_rad(-90)

			down:
				global_rotation = deg_to_rad(90)

			left:
				global_rotation = deg_to_rad(0)

			right:
				global_rotation = deg_to_rad(0)
