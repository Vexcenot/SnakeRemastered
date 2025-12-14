extends Sprite2D

enum {stop, up, down, left, right}
@export var turn : int
@export var direction : int
@export var nextDirection : int

func _ready() -> void:
	Global.tick.connect(update)

func update():
	rotation()
	if direction != nextDirection :
		frame = 3
	else:
		frame = 1

#func _process(_delta: float) -> void:
	#if Global.time >= Global.finalTime:
		#if turnCheck == 1:
			#frame = 3
		#else:
			#frame = 1
		#rotation()

func rotation():
	match direction:
		up:
			global_rotation = deg_to_rad(-90)
			flip_h = false
		down:
			global_rotation = deg_to_rad(90)
			flip_h = false
		left:
			global_rotation = 0
			flip_h = true
		right:
			global_rotation = 0
			flip_h = false
