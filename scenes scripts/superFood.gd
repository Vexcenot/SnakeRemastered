class_name superFood
extends food

var randFrame = randi() % 6

func _ready() -> void:
	teleport_random()
	Global.foodEaten = 0
	Global.foodTime = 15
	$sprite.frame = randFrame

	
func _process(_delta: float) -> void:
	if Global.foodTime < 1:
		queue_free()
	
func _on_food_2_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		queue_free()
