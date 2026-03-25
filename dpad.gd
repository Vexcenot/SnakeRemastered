extends Control



func _on_up_button_down() -> void:
	print("fuck")
	Input.action_press("up")


func _on_down_button_down() -> void:
	Input.action_press("down")  


func _on_left_button_down() -> void:
	Input.action_press("left")  


func _on_right_button_down() -> void:
	Input.action_press("right")  
