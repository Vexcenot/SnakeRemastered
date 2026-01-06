extends Control
var score = Global.score

func _ready():
	Global.tick.connect(update)

# Update label
func update(): 
	$Label.text = "%04d" %Global.score
