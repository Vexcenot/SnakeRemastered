extends Node2D
@export var currentDirection : int
@export var nextDirection : int

func _ready() -> void:
	Global.tick.connect(update)

func update():
	print("fuck")

func _process(_delta: float) -> void:
	if currentDirection != nextDirection:
		$SmolSnake.frame = 3
	else:
		$SmolSnake.frame = 1
