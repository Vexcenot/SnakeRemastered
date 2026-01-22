shader_type canvas_item;

const int smear_frames = 4;

/* === SMEAR CONTROLS === */
uniform float mix_factor : hint_range(0.1, 1.0) = 0.5;
uniform vec4 color_mix : source_color = vec4(1.0);
uniform sampler2D last_frame[4];
uniform bool ready = false;

/* === GRID / MASK CONTROLS === */
uniform bool enable_mask = true;
uniform vec2 grid_size = vec2(16.0, 16.0);
uniform float line_thickness : hint_range(0.01, 0.49) = 0.08;
uniform float edge_softness : hint_range(0.0, 0.1) = 0.02;
uniform bool invert_grid = false;

/* === MASK OPACITY === */
uniform vec2 mask_offset = vec2(0.0, 0.0);
uniform float mask_opacity : hint_range(0.0, 1.0) = 1.0;

/* === SHADOW CONTROLS === */
uniform bool enable_shadow = true;
uniform vec4 drop_shadow_color : source_color = vec4(vec3(0.0), 0.5);
uniform vec2 shadow_offset = vec2(0.0, 0.1);

/* === OBJECT OPACITY === */
uniform float object_opacity : hint_range(0.0, 1.0) = 1.0;

/* === HELPERS === */
vec4 sample_texture_safe(sampler2D tex, vec2 uv) {
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		return vec4(0.0);
	}
	return texture(tex, uv);
}

vec4 mixcolor(vec4 base, vec4 over) {
	return vec4(
		base.rgb + over.a * (over.rgb - base.rgb),
		base.a + over.a
	);
}

void fragment() {

	/* === BASE COLOR === */
	vec2 uv = UV;
	vec4 base_tex = sample_texture_safe(TEXTURE, uv);
	base_tex.a *= object_opacity;

	/* === SHADOW (DOES NOT MOVE BASE) === */
	if (enable_shadow) {
		vec4 shadow = vec4(
			drop_shadow_color.rgb,
			sample_texture_safe(TEXTURE, uv - shadow_offset).a * drop_shadow_color.a
		);

		if (shadow.a > 0.0) {
			COLOR = mixcolor(shadow, base_tex);
		} else {
			COLOR = base_tex;
		}
	} else {
		COLOR = base_tex;
	}

	/* === SMEAR ACCUMULATION === */
	vec4 smear_color = vec4(0.0);
	for (int i = 0; i < smear_frames; i++) {
		smear_color = mix(smear_color, texture(last_frame[i], UV), mix_factor);
	}

	vec4 final_color = ready
		? mix(COLOR, smear_color, mix_factor)
		: COLOR;

	final_color *= color_mix;

	/* === GRID MASK === */
	float grid_mask = 1.0;

	if (enable_mask) {
		vec2 mask_uv = UV + mask_offset;
		vec2 grid_uv = fract(mask_uv * grid_size);

		float dist_x = min(grid_uv.x, 1.0 - grid_uv.x);
		float dist_y = min(grid_uv.y, 1.0 - grid_uv.y);
		float dist = min(dist_x, dist_y);

		grid_mask = smoothstep(
			line_thickness,
			line_thickness + edge_softness,
			dist
		);

		if (invert_grid) {
			grid_mask = 1.0 - grid_mask;
		}

		grid_mask = mix(1.0, grid_mask, mask_opacity);
	}

	/* === APPLY MASK === */
	final_color.rgb *= grid_mask;
	final_color.a *= grid_mask;

	COLOR = final_color;
}
