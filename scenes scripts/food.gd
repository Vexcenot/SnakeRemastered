extends Sprite2D


func _on_food_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		queue_free()
