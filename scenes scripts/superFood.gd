class_name superFood
extends food

var randFrame = randi() % 6

func _ready() -> void:
	Global.sFood.connect(activate)
	teleport_random()
	$sprite.frame = randFrame

func activate():
	visible = true
	$food/CollisionShape2D.disabled = false
	
func deactivate():
	#visible = false
	$food/CollisionShape2D.disabled = true
	teleport_random()
	
func _on_food_2_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		deactivate()


#FIX CONSTANT TELEPORTING
func teleport_random():
	#visible = false
	var randX = randf_range(minX, maxX)
	var randY = randf_range(minY, maxY)
	
	# Round to nearest 4-pixel increment
	randX = round(randX / size) * size
	randY = round(randY / size) * size
	
	global_position = Vector2(randX, randY)
	await get_tree().process_frame 
	if $detect.has_overlapping_areas() or $detect.has_overlapping_bodies():
		teleport_random()
	else:
		visible = true
		$food/CollisionShape2D.disabled = false
