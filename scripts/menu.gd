extends Control
var score : int = Global.score
var Hscore : int = Global.highScore
var lvlName : String = "Maze 1"
var mazeMessage : String
var level :bool = true
var maxScrollBar : int = 20
var maxScrollVert : int = 40
var maxMazeScrollBar : int = 20
var maxMazeScrollVert : int = 30

#scroll bar
func scrollbar():
	var scroll_value = $ColorRect/Menu/VBoxContainer/ScrollContainer.scroll_vertical
	# Clamp the scroll value between 0 and maxScrollVert
	scroll_value = clamp(scroll_value, 0, maxScrollVert)
	# Map the scroll value proportionally to the range 0 to maxScrollBar
	var mapped_position = (scroll_value * maxScrollBar) / maxScrollVert
	# Set the position, ensuring it doesn't exceed maxScrollBar
	$ColorRect/Menu/scroll/ScrollBar.position.y = min(mapped_position, maxScrollBar)

#scroll bar in maze
func scrollbarMazeChooser():
	var scroll_value = $"ColorRect/maze chooser/VBoxContainer/mazescrolls".scroll_vertical
	# Clamp the scroll value between 0 and maxScrollVert
	scroll_value = clamp(scroll_value, 0, maxMazeScrollVert)
	# Map the scroll value proportionally to the range 0 to maxScrollBar
	var mapped_position = (scroll_value * maxMazeScrollBar) / maxMazeScrollVert
	# Set the position, ensuring it doesn't exceed maxScrollBar
	$"ColorRect/maze chooser/scroll/ScrollBar".position.y = min(mapped_position, maxMazeScrollBar)


func _ready():
#skips opening animation
	if !Global.title:
		skipTitle()
	else:
		$"ColorRect/title animation/introAnim".play("intro")

	Global.ScenetoSpawn = Global.levelSpawn

#displays highscore
	$ColorRect/Menu/score.text = "%03d" %Hscore
	$ColorRect/Mazes/Label.text = "%03d" %Global.highScore
	$"ColorRect/maze chooser/score".text = "%03d" %Global.highScore

#shows score after game ends
	if Global.gameStarted and !Global.isHighscore:
		Global.gameStarted = false
		$"ColorRect/Score end/VBoxContainer/outroScore".text = str(score)
		$ColorRect/Menu.visible = false
		$"ColorRect/Score end".visible = true
		$"ColorRect/Score end/Timer".start()

#plays fire works when highscored
	elif Global.isHighscore: 
		Global.gameStarted = false
		Global.isHighscore = false
		$"ColorRect/Score end/VBoxContainer/outroScore".text = str(score)
		$ColorRect/Menu.visible = false
		$ColorRect/fireworks.visible = true
		$ColorRect/fireworks/AnimationPlayer.play("fireworks")

func _process(_delta: float) -> void:
	scrollbar()
	scrollbarMazeChooser()
	print($ColorRect/Menu/VBoxContainer/ScrollContainer.scroll_vertical)
	if $ColorRect/Level.visible:
		Global.updateTime()
		$ColorRect/Level/VolBars.frame = Global.speed - 1
		Global.ScenetoSpawn = Global.levelSpawn

func _input(event: InputEvent) -> void:
	#key presses if level screen active (controls level)
	if $ColorRect/Level.visible:
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left"):
			if Global.speed >= 2:
				Global.speed -= 1
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_right"):
			if Global.speed <= 8:
				Global.speed += 1

#skip screen at any key press
	if event is InputEventKey:
		if event.pressed and not event.echo:
			$tone.play()
			if Global.title:
				skipTitle()
			if $"ColorRect/Score end".visible:
				skipScore()
			if $ColorRect/fireworks.visible:
				skipFireworks()

#cancel back to menu
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
		elif $"ColorRect/maze chooser".visible:
			$"ColorRect/maze chooser".visible = false
			$ColorRect/Menu.visible = true


########
#MAIN MENU BUTTONS
########
func _on_con_pressed() -> void:
	pass # Replace with function body.

func _on_new_pressed() -> void:
	$tone.play()
	Global.changeScene.emit()
	Global.gameStarted = true
	await get_tree().process_frame
	queue_free()


func _on_lev_pressed() -> void:
	$tone.play()
	$ColorRect/Level.visible = true
	$ColorRect/Menu.visible = false


func _on_maz_pressed() -> void:
	$tone.play()
	$"ColorRect/maze chooser".visible = true
	$ColorRect/Menu.visible = false


func _on_mul_pressed() -> void:
	$tone.play()
	Global.multiplayerMode = true
	Global.changeScene.emit()
	Global.gameStarted = true
	await get_tree().process_frame
	queue_free()


func _on_ins_pressed() -> void:
	$tone.play()
	$ColorRect/Instructions.visible = true
	$ColorRect/Menu.visible = false


func _on_top_pressed() -> void:
	pass # Replace with function body.


func _on_dpad_pressed() -> void:
	pass # Replace with function body.

	
#maze select animation
func selectMaze():
	$"ColorRect/Maze selected screen/mazeName".text = lvlName
	$"ColorRect/Maze selected screen".visible = true
	$"ColorRect/maze chooser".visible = false
	$"ColorRect/Maze selected screen/AnimationPlayer".play("tick")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"ColorRect/Maze selected screen".visible = false
	$ColorRect/Menu.visible = true


########
#LEVEL BUTTONS
########
func _on__button_down() -> void:
	$tone.play()
	Global.speed = 1
	$ColorRect/Level/VolBars.frame = 0

func _on__button_down2() -> void:
	$tone.play()
	Global.speed = 2
	$ColorRect/Level/VolBars.frame = 1

func _on__button_down3() -> void:
	$tone.play()
	Global.speed = 3
	$ColorRect/Level/VolBars.frame = 2

func _on__button_down4() -> void:
	$tone.play()
	Global.speed = 4
	$ColorRect/Level/VolBars.frame = 3

func _on__button_down5() -> void:
	$tone.play()
	Global.speed = 5
	$ColorRect/Level/VolBars.frame = 4

func _on__button_down6() -> void:
	$tone.play()
	Global.speed = 6
	$ColorRect/Level/VolBars.frame = 5

func _on__button_down7() -> void:
	$tone.play()
	Global.speed = 7
	$ColorRect/Level/VolBars.frame = 6

func _on__button_down8() -> void:
	$tone.play()
	Global.speed = 8
	$ColorRect/Level/VolBars.frame = 7

func _on__button_down9() -> void:
	$tone.play()
	Global.speed = 9
	$ColorRect/Level/VolBars.frame = 8
 
func _on_button_button_down() -> void:
	$tone.play()
	$ColorRect/Level.visible = false
	$ColorRect/Menu.visible = true



########
#INSTRUCTIONS BUTTONS
########
func _on_ok_button_down2() -> void:
	$tone.play()
	$ColorRect/Instructions.visible = false
	$ColorRect/Menu.visible = true



########
#MAZE MENU BUTTONS
########
func _on_maz_0_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.sceneGame
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "No maze"
	selectMaze()


func _on_maz_1_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.maze1
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 1"
	selectMaze()


func _on_maz_2_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.maze2
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 2"
	selectMaze()


func _on_maz_3_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.maze3
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 3"
	selectMaze()


func _on_maz_4_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.maze4
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 4"
	selectMaze()


func _on_maz_5_pressed() -> void:
	$tone.play()
	Global.levelSpawn = Global.maze5
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 5"
	selectMaze()

func _on_ok_button_down3() -> void:
	$tone.play()
	$ColorRect/Mazes.visible = false
	$ColorRect/Menu.visible = true




########
#INTRO ANIMATION
########
func intro_finished(anim_name: StringName) -> void:
	if $"ColorRect/title animation".visible:
		skipTitle()
func introarea(area: Area2D) -> void:
	skipTitle()
func titlebuttondown() -> void:
	skipTitle()
func skipTitle():
	Global.title = false
	$"ColorRect/title animation".visible = false
	$ColorRect/Menu.visible = true
	



########
#SCORE SCREEN
########
func score_timeout() -> void:
	if $"ColorRect/Score end".visible:
		$"ColorRect/Score end".visible = false
		$ColorRect/Menu.visible = true

func skipScore():
	$"ColorRect/Score end".visible = false
	$ColorRect/Menu.visible = true
	
func skipFireworks():
	$ColorRect/fireworks.visible = false
	$"ColorRect/Score end".visible = true
	$"ColorRect/Score end/Timer".start()
	

########
#FIREWORKS
########
func fireworksAnimationFinished(anim_name: StringName) -> void:
	if $ColorRect/fireworks.visible:
		skipFireworks()
		$winsound.play()
