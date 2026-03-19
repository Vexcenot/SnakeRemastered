extends Control
var score = Global.highScore
var lvlName : String = "Maze 1"
var mazeMessage : String

func _ready():
	print(Global.highScore)
	Global.ScenetoSpawn = Global.levelSpawn
	$ColorRect/Menu/Label.text = "%03d" %score
	$ColorRect/Mazes/Label.text = "%03d" %Global.highScore

func _process(_delta: float) -> void:
	if $ColorRect/Level.visible:
		Global.updateTime()
		$ColorRect/Level/VolBars.frame = Global.speed - 1
		Global.ScenetoSpawn = Global.levelSpawn

var level :bool = true


func _input(event: InputEvent) -> void:
	#key presses if level screen active
	if $ColorRect/Level.visible:
		if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left"):
			if Global.speed >= 2:
				Global.speed -= 1
		if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_right"):
			if Global.speed <= 8:
				Global.speed += 1


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



########
#LEVEL BUTTONS
########
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
 
func _on_button_button_down() -> void:
	$ColorRect/Level.visible = false
	$ColorRect/Menu.visible = true



########
#INSTRUCTIONS BUTTONS
########
func _on_ok_button_down2() -> void:
	$ColorRect/Instructions.visible = false
	$ColorRect/Menu.visible = true





########
#MAZE MENU BUTTONS
########
func _on_no_maze_button_down() -> void:
	Global.levelSpawn = Global.sceneGame
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "No maze"
	closeMaze()


func _on_maze_1_button_down() -> void:
	Global.levelSpawn = Global.maze1
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 1"
	closeMaze()


func _on_maze_2_button_down() -> void:
	Global.levelSpawn = Global.maze2
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 2"
	closeMaze()


func _on_maze_3_button_down() -> void:
	Global.levelSpawn = Global.maze3
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 3"
	closeMaze()


func _on_maze_4_button_down() -> void:
	Global.levelSpawn = Global.maze4
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 4"
	closeMaze()


func _on_maze_5_button_down() -> void:
	Global.levelSpawn = Global.maze5
	Global.ScenetoSpawn = Global.levelSpawn
	lvlName = "Maze 5"
	selectMaze()
	
func closeMaze():
	$ColorRect/Mazes.visible = false
	$ColorRect/Menu.visible = true


func _on_ok_button_down3() -> void:
	$ColorRect/Mazes.visible = false
	$ColorRect/Menu.visible = true




########
#MAIN MENU BUTTONS
########
func _on_new_button_down() -> void:
	Global.changeScene.emit()
	await get_tree().process_frame
	queue_free()

func _on_lev_button_down() -> void:
	$ColorRect/Level.visible = true
	$ColorRect/Menu.visible = false

func _on_ins_button_down() -> void:
	$ColorRect/Instructions.visible = true
	$ColorRect/Menu.visible = false


func _on_maz_button_down() -> void:
	$ColorRect/Mazes.visible = true
	$ColorRect/Menu.visible = false
	
#maze select animation
func selectMaze():
	$"ColorRect/Maze selected screen".visible = true
	$ColorRect/Mazes.visible = false
	$"ColorRect/Maze selected screen/AnimationPlayer".play("tick")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"ColorRect/Maze selected screen".visible = false
	$ColorRect/Menu.visible = true
