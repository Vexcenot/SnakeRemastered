extends Control
var game = preload("res://scenes scripts/game.tscn")
var menu = preload("res://menu.gd")

func _ready():
	Global.changeScene.connect(sceneing)
	
func sceneing():
	for child in $".".get_children():
		child.queue_free()
	
