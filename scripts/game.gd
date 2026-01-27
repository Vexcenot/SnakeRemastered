extends Control


func _ready():
	Global.changeScene.connect(sceneChange)
	
func sceneChange():
	queue_free()
