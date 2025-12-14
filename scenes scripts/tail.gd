extends Node2D
@export var turnCheck : int

func _ready() -> void:
	Global.tick.connect(update)

func update():
	print("fuck")

func _process(_delta: float) -> void:
	if turnCheck == 1:
		$tailSprite.frame = 3
	else:
		$tailSprite.frame = 1
