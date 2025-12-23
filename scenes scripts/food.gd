extends Sprite2D
var minX = 84
var maxX = 80
var minY = 44
var maxY = 40

func _on_food_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		if Global.foodEaten >= 5:
			#spawn special food
			pass
		else:
			Global.foodEaten += 1
		teleport_random()


#make it teleport to a grid
func teleport_random():
	visible = false
	var randX = randf_range(minX, maxX)
	var randY = randf_range(minY, maxY)
	global_position = Vector2(randX, randY)
	await get_tree().process_frame
	if $food.has_overlapping_areas() or $food.has_overlapping_bodies():
		teleport_random()
		print("SHIT", global_position)
	else:
		visible = true

		#queue_free()
