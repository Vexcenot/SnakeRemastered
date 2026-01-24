extends Control
var score = Global.score

func _ready():
	Global.tick.connect(update)

# Update label
func update(): 
	$score.text = "%04d" %Global.score
	
	
#shows food timer
	if Global.sFoodActive:
		$Control/Sprite2D.frame = Global.spriteFrame
		$Control/Timer.text = "%02d" %Global.foodTime
		$Control.visible = true
	else:
		$Control.visible = false
