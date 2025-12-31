class_name food
extends Node2D
@export var minX : int = 2
@export var maxX : int = 82
@export var minY : int = 2
@export var maxY : int = 46
@export var size : int = 4
@export var addEat : bool = true
var teleporting : bool = false

func _ready() -> void:
	await get_tree().process_frame
	teleport_random()

#make it teleport to a grid
func teleport_random():
	visible = false
	$food/CollisionShape2D.disabled = true
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


func _on_food_2_area_entered(area: Area2D) -> void:
	if area.name == "headArea":
		teleporting = true
		teleport_random()
		if addEat:
			Global.foodEaten += 1
