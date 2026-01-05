class_name superFood
extends food

var randFrame = randi() % 6

func _ready() -> void:
	deactivate()
	Global.sFood.connect(activate)
	$sprite.frame = randFrame
	

func _process(_delta: float) -> void:
	if Global.foodEaten >= 5:
		activate()
	if Global.foodTime <= 0:
		deactivate()


func activate():
	$sprite.visible = true
	$food.monitorable = true
	Global.foodTime = 15
	Global.foodEaten = 0
	print("fuck2")
	

func deactivate():
	$sprite.visible = false
	$food.monitorable = false
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
