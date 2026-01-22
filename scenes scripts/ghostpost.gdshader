shader_type canvas_item;

/*
  CRT Ghosting / Motion Trail Shader
  ==================================
  Required Scene Setup:
  1. Control or CanvasLayer (Root)
     └── SubViewportContainer (Stretch: On)
         └── SubViewport (Clear Mode: Never)
             ├── ColorRect (Full Rect, Shader Material Attached)
             └── [Your 2D/3D Scene Content]

  Important: The SubViewport's 'Clear Mode' MUST be set to 'Never' for the trail
  feedback loop to function. This shader should be on a ColorRect that is the
  FIRST child inside the Viewport to act as the persistent background.
*/

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float fade_speed : hint_range(0.01, 2.0) = 1.0;
uniform vec4 tint_color : source_color = vec4(0.1, 0.15, 0.1, 1.0); // Dark calculator background
uniform bool monochrome = true;
uniform float delta = 0.016;

void fragment() {
    // Correctly sample the screen texture
    vec4 screen_color = texture(screen_texture, SCREEN_UV);

    // To create a trail, this shader should be on a ColorRect that covers the screen
    // inside a SubViewport with 'Clear Mode' set to 'Never'.

    // Every frame, we fade the existing pixels towards the background color
    // Using exponential decay: mix_factor = 1.0 - exp(-delta * (3.0 / fade_speed))
    // This makes it reach ~95% of target color in 'fade_speed' seconds.
    float mix_factor = 1.0 - exp(-(delta * 3.0) / fade_speed);
    vec4 faded_color = mix(screen_color, tint_color, mix_factor);

    if (monochrome) {
        float luma = dot(faded_color.rgb, vec3(0.299, 0.587, 0.114));
        float bg_luma = dot(tint_color.rgb, vec3(0.299, 0.587, 0.114));
        float relative_luma = clamp((luma - bg_luma) / (1.0 - bg_luma), 0.0, 1.0);

        // Output a mix between background and a bright phosphor green
        COLOR = mix(tint_color, vec4(0.7, 1.0, 0.7, 1.0), relative_luma);
    } else {
        COLOR = faded_color;
    }
}