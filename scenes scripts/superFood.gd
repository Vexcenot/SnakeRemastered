class_name superFood
extends food

func _ready() -> void:
	deactivate()
	

func _process(_delta: float) -> void:
	if Global.foodEaten >= 5:
		teleport_random()
	if Global.foodTime <= 0:
		deactivate()


func activate():
	$AudioStreamPlayer.play()
	$sprite.frame = Global.spriteFrame
	$sprite.visible = true
	$food/CollisionShape2D.disabled = false
	$food.monitorable = true
	Global.foodTime = Global.setTime
	Global.foodEaten = 0
	print("fuck2")
	

func deactivate():
	Global.foodTime = 0
	$food/CollisionShape2D.disabled = true
	$food.monitorable = false
	$sprite.visible = false


func _on_food_2_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		deactivate()
		await get_tree().process_frame
		deactivate()
		Global.score += 64

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
	await get_tree().process_frame 
	if $detect.has_overlapping_areas() or $detect.has_overlapping_bodies():
		teleport_random()
	else:
		activate()
