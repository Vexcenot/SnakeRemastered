extends Control

func _process(delta: float) -> void:
	$ColorRect/Level/VolBars.frame = Global.speed - 1


func _on_new_game_button_down() -> void:
	Global.ScenetoSpawn = Global.sceneGame
	Global.changeScene.emit()
	await get_tree().process_frame
	queue_free()

#make it spawn scene ontop of main scene
func _on_level_button_down() -> void:
	$ColorRect/Level.visible = true
	$"ColorRect/main menu".visible = false

func _on_button_button_down() -> void:
	$ColorRect/Level.visible = false
	$"ColorRect/main menu".visible = true

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


func _on__button_down() -> void:
	Global.speed = 1
	$ColorRect/Level/VolBars.frame = 0



func _on__button_down2() -> void:
	Global.speed = 2
	$ColorRect/Level/VolBars.frame = 1


func _on__button_down3() -> void:
	Global.speed = 3
	$ColorRect/Level/VolBars.frame = 2


func _on__button_down4() -> void:
	Global.speed = 4
	$ColorRect/Level/VolBars.frame = 3


func _on__button_down5() -> void:
	Global.speed = 5
	$ColorRect/Level/VolBars.frame = 4


func _on__button_down6() -> void:
	Global.speed = 6
	$ColorRect/Level/VolBars.frame = 5


func _on__button_down7() -> void:
	Global.speed = 7
	$ColorRect/Level/VolBars.frame = 6


func _on__button_down8() -> void:
	Global.speed = 8
	$ColorRect/Level/VolBars.frame = 7


func _on__button_down9() -> void:
	Global.speed = 9
	$ColorRect/Level/VolBars.frame = 8
 
