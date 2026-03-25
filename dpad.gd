extends Control

func _on_up_button_down() -> void:
	var event = InputEventAction.new()
	event.action = "up"
	event.pressed = true
	Input.parse_input_event(event)

func _on_down_button_down() -> void:
	var event = InputEventAction.new()
	event.action = "down"
	event.pressed = true
	Input.parse_input_event(event)

func _on_left_button_down() -> void:
	var event = InputEventAction.new()
	event.action = "left"
	event.pressed = true
	Input.parse_input_event(event)

func _on_right_button_down() -> void:
	var event = InputEventAction.new()
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
