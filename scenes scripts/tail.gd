extends Node2D

enum {stop, up, down, left, right}
@export var turn : int
@export var direction : int
@export var nextDirection : int
@export var lastTail : bool = false
var turning : bool = false
var full : bool = false #make this true if cant update upon spawn on player script

#func _process(_delta: float) -> void:
	#visible = Global.seeable

func _ready() -> void:
	Global.tick.connect(update)
	update()
	if lastTail:
		$tailSprite/StaticBody2D/straightCol.disabled = true
		$tailSprite/finalArea/CollisionShape2D.disabled = false
	#else:
		#$StaticBody2D/straightCol.disabled = false

 
func update():
	if !Global.hurting:
		#print(direction, nextDirection)
		visible = true
			#print(direction, nextDirection)
			
		if direction != nextDirection and direction != stop:
			turning = true #true
		else:
			turning = false
			
		#changes collision shape when bending
		if turning:
			$tailSprite/StaticBody2D/turnCol.disabled = false
			$tailSprite/StaticBody2D/straightCol.disabled = true
			if lastTail:
				pass
			elif full:
				$tailSprite.frame = 7
			else:
				$tailSprite.frame = 3
		else:
			$tailSprite/StaticBody2D/turnCol.disabled = true
			$tailSprite/StaticBody2D/straightCol.disabled = false
			if lastTail:
				$tailSprite.frame = 0
			elif full:
				$tailSprite.frame = 6
			else:
				$tailSprite.frame = 1
		rotation()

func rotation():
	if turning and not lastTail:
		if direction == up:
			if nextDirection == left:
				$tailSprite.global_rotation = deg_to_rad(0)
				$tailSprite.flip_h = true
				$tailSprite.flip_v = false
			else:
				$tailSprite.global_rotation = deg_to_rad(0)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false
		if direction == down:
			if nextDirection == left:
				$tailSprite.global_rotation = deg_to_rad(180)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false
			else:
				$tailSprite.global_rotation = deg_to_rad(0)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = true
		if direction == right:
			if nextDirection == up:
				$tailSprite.global_rotation = deg_to_rad(90)
				$tailSprite.flip_h = true
				$tailSprite.flip_v = false
			else:
				$tailSprite.global_rotation = deg_to_rad(90)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false
		if direction == left:
			if nextDirection == up:
				$tailSprite.global_rotation = deg_to_rad(-90)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false
			else:
				$tailSprite.global_rotation = deg_to_rad(90)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = true
	else:
		match nextDirection:
			up:
				$tailSprite.global_rotation = deg_to_rad(-90) 
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false

			down:
				$tailSprite.global_rotation = deg_to_rad(90)   
				$tailSprite.flip_h = false
				$tailSprite.flip_v = true

			left:
				$tailSprite.global_rotation = deg_to_rad(0)  
				$tailSprite.flip_h = true
				$tailSprite.flip_v = false

			right:
				$tailSprite.global_rotation = deg_to_rad(0)
				$tailSprite.flip_h = false
				$tailSprite.flip_v = false
