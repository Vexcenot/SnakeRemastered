extends Control

# Preload the scene at compile time
const game = preload("res://scenes scripts/game.tscn")

func spawn_enemy():
	var gameInstance = game.instantiate()
	get_tree().root.add_child(gameInstance)


func _on_button_pressed() -> void:
	Global.changeScene.emit()
	queue_free()
