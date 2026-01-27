extends Control
var game = preload("res://scenes scripts/game.tscn")
var menu = preload("res://scenes scripts/menu.tscn")



func _ready():
	Global.changeScene.connect(sceneing)
	
func sceneing():
	
	# Instantiate it
	var new_instance = Global.ScenetoSpawn.instantiate()

	# Add to scene tree
	add_child(new_instance)
