extends Control

#-------------------------------
# SNAKE GAME IMAGE PROCESSING
# - GDScript front-end for smear shader
#-------------------------------

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

var image_buffer: Array[ImageTexture];
var frame_counter: int = 0;
var prev_tex: ImageTexture;

@export var smear_time: int = 1;
@export var smear_levels: int = 4;

#---------
# _READY
#---------
func _ready() -> void:
	_process_frames();

#---------
# _PROCESS
#---------
func _process(_delta: float) -> void:
	frame_counter += 1;
	if frame_counter > smear_time:
		frame_counter = 0;
		_process_frames();

#---------
# _PROCESS_FRAME
#---------
func _process_frames() -> void:
	# Get subviewport texture, convert to ImageTexture and store it in buffer
	var image: Image = $SubViewportContainer/SubViewport.get_texture().get_image();
	prev_tex = ImageTexture.create_from_image(image);
	image_buffer.push_back(prev_tex);
	
	# Wait for buffer to fill up
	if image_buffer.size() < smear_levels || !is_instance_valid(prev_tex):
		return;
		
	# Pass buffer into shader
	if is_instance_valid(sub_viewport_container) && sub_viewport_container.material is ShaderMaterial:
		sub_viewport_container.material.set_shader_parameter("ready", true);
		sub_viewport_container.material.set_shader_parameter("last_frame", image_buffer);
		image_buffer.pop_front();
