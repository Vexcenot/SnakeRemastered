extends Control

func _input(event: InputEvent) -> void:
	#key presses if level screen active
	if $ColorRect/Level.visible:
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_left"):
			pass
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			pass
		if Input.is_action_pressed("ui_cancel") or Input.is_action_pressed("ui_accept"):
			$ColorRect/Level.visible = false
			$"ColorRect/main menu".visible = true


func _on_button_button_down() -> void:
	Global.ScenetoSpawn = Global.sceneMenu
	Global.changeScene.emit()
	await get_tree().process_frame
	queue_free()
