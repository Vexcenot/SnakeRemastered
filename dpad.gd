extends Control
@export var p2 = false

var swipe_start_position: Vector2
var swipe_threshold: float = 50.0  # Minimum distance to register as a swipe

func _ready() -> void:
	# Enable touch/drag events
	set_process_input(true)
	
func _process(_delta: float) -> void:
		if Global.gameStarted:
			if Global.dpadEnabled and !p2:
				visible = Global.gameStarted
			if Global.multiplayerMode:
				if Global.dpadEnabled:
					visible = true
		else:
			visible = false


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Touch started
			swipe_start_position = event.position
		else:
			# Touch ended - check for swipe
			var swipe_end_position = event.position
			var swipe_vector = swipe_end_position - swipe_start_position
			
			# Check if the swipe distance exceeds threshold
			if abs(swipe_vector.x) > swipe_threshold or abs(swipe_vector.y) > swipe_threshold:
				# Determine swipe direction (prioritize the larger movement)
				if abs(swipe_vector.x) > abs(swipe_vector.y):
					# Horizontal swipe
					if swipe_vector.x > 0:
						swipe_right()
					else:
						swipe_left()
				else:
					# Vertical swipe
					if swipe_vector.y > 0:
						swipe_down()
					else:
						swipe_up()
	elif event is InputEventScreenDrag:
		# Optional: Add visual feedback while dragging
		pass

func swipe_up() -> void:
	# Trigger up action
	var press_event = InputEventAction.new()
	press_event.action = "up"
	press_event.pressed = true
	Input.parse_input_event(press_event)
	
	# Immediately release after a short delay (simulate tap)
	await get_tree().create_timer(0.05).timeout
	
	var release_event = InputEventAction.new()
	release_event.action = "up"
	release_event.pressed = false
	Input.parse_input_event(release_event)

func swipe_down() -> void:
	var press_event = InputEventAction.new()
	press_event.action = "down"
	press_event.pressed = true
	Input.parse_input_event(press_event)
	
	await get_tree().create_timer(0.05).timeout
	
	var release_event = InputEventAction.new()
	release_event.action = "down"
	release_event.pressed = false
	Input.parse_input_event(release_event)

func swipe_left() -> void:
	var press_event = InputEventAction.new()
	press_event.action = "left"
	press_event.pressed = true
	Input.parse_input_event(press_event)
	
	await get_tree().create_timer(0.05).timeout
	
	var release_event = InputEventAction.new()
	release_event.action = "left"
	release_event.pressed = false
	Input.parse_input_event(release_event)

func swipe_right() -> void:
	var press_event = InputEventAction.new()
	press_event.action = "right"
	press_event.pressed = true
	Input.parse_input_event(press_event)
	
	await get_tree().create_timer(0.05).timeout
	
	var release_event = InputEventAction.new()
	release_event.action = "right"
	release_event.pressed = false
	Input.parse_input_event(release_event)

# Your existing button handlers remain unchanged
func _on_up_button_down() -> void:
	var event = InputEventAction.new()
	if p2:
		event.action = "up2"
	else:
		event.action = "up"
	event.pressed = true
	Input.parse_input_event(event)

func _on_down_button_down() -> void:
	var event = InputEventAction.new()
	if p2:
		event.action = "down2"
	else:
		event.action = "down"
	event.pressed = true
	Input.parse_input_event(event)

func _on_left_button_down() -> void:
	var event = InputEventAction.new()
	if p2:
		event.action = "left2"
	else:
		event.action = "left"
	event.pressed = true
	Input.parse_input_event(event)

func _on_right_button_down() -> void:
	var event = InputEventAction.new()
	if p2:
		event.action = "right2"
	else:
		event.action = "right"
	event.pressed = true
	Input.parse_input_event(event)

func _on_up_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "up"
	event.pressed = false
	Input.parse_input_event(event)

func _on_down_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "down"
	event.pressed = false
	Input.parse_input_event(event)

func _on_left_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "left"
	event.pressed = false
	Input.parse_input_event(event)

func _on_right_button_up() -> void:
	var event = InputEventAction.new()
	event.action = "right"
	event.pressed = false
	Input.parse_input_event(event)
