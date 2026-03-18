extends Control

func _process(_delta: float) -> void:
	if $ColorRect/Level.visible:
		Global.updateTime()
		$ColorRect/Level/VolBars.frame = Global.speed - 1

var level :bool = true

func _on_new_game_button_down() -> void:
	Global.changeScene.emit()
	await get_tree().process_frame
	queue_free()

#make it spawn scene ontop of main scene
func _on_level_button_down() -> void:
	$ColorRect/Level.visible = true
	$ColorRect/Menu.visible = false

func _on_button_button_down() -> void:
	$ColorRect/Level.visible = false
	$ColorRect/Menu.visible = true

func _input(event: InputEvent) -> void:
	#key presses if level screen active
	if $ColorRect/Level.visible:
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left"):
			if Global.speed >= 2:
				Global.speed -= 1
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_right"):
			if Global.speed <= 8:
				Global.speed += 1

	if Input.is_action_pressed("ui_cancel") or Input.is_action_pressed("ui_accept"):
		if $ColorRect/Level.visible:
			$ColorRect/Level.visible = false
			$ColorRect/Menu.visible = true
		elif $ColorRect/Instructions.visible:
			$ColorRect/Instructions.visible = false
			$ColorRect/Menu.visible = true
		elif $ColorRect/Mazes.visible:
			$ColorRect/Mazes.visible = false
			$ColorRect/Menu.visible = true


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
 


func _on_ok_button_down2() -> void:
	$ColorRect/Instructions.visible = false
	$ColorRect/Menu.visible = true


func _on_instructions_button_down() -> void:
	$ColorRect/Instructions.visible = true
	$ColorRect/Menu.visible = false


func _on_ok_button_down3() -> void:
	$ColorRect/Mazes.visible = false
	$ColorRect/Menu.visible = true


func _on_mazes_button_down() -> void:
	$ColorRect/Mazes.visible = true
	$ColorRect/Menu.visible = false


func _on_no_maze_button_down() -> void:
	Global.ScenetoSpawn = Global.sceneGame


func _on_maze_1_button_down() -> void:
	Global.ScenetoSpawn = Global.maze1


func _on_maze_2_button_down() -> void:
	Global.ScenetoSpawn = Global.maze2


func _on_maze_3_button_down() -> void:
	Global.ScenetoSpawn = Global.maze3


func _on_maze_4_button_down() -> void:
	Global.ScenetoSpawn = Global.maze4


func _on_maze_5_button_down() -> void:
	Global.ScenetoSpawn = Global.maze5
