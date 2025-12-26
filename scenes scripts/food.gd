extends Node2D
var minX : int = 2
var maxX : int = 82
var minY : int = 2
var maxY : int = 46
var teleporting : bool = false

func _ready() -> void:
	teleport_random()

#make it teleport to a grid
func teleport_random():
	visible = false
	$food/CollisionShape2D.disabled = true
	var randX = randf_range(minX, maxX)
	var randY = randf_range(minY, maxY)
	
	# Round to nearest 4-pixel increment
	randX = round(randX / 4.0) * 4.0
	randY = round(randY / 4.0) * 4.0
	
	## Optional: Clamp to ensure within bounds after rounding
	#randX = clamp(randX, minX, maxX)
	#randY = clamp(randY, minY, maxY)
	
	global_position = Vector2(randX, randY)
	await get_tree().process_frame 
	if $detect.has_overlapping_areas():
		teleport_random()
		print("SHIT", global_position)
	else:
		visible = true
		$food/CollisionShape2D.disabled = false

		#queue_free()


#func _on_detect_area_entered(area: Area2D) -> void:
#


func _on_food_2_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		if Global.foodEaten >= 5:
			#spawn special food
			pass
		else:
			Global.foodEaten += 1
		teleporting = true
		teleport_random()
