shader_type canvas_item;

/* === SCREEN TEXTURE === */
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

/* === BLUR CONTROLS === */
uniform float blur_radius : hint_range(0.0, 10.0) = 4.0;
uniform int blur_quality : hint_range(1, 12) = 6;

void fragment() {
    vec2 screen_uv = SCREEN_UV;

    ivec2 size = textureSize(SCREEN_TEXTURE, 0);
    vec2 pixel_size = 1.0 / vec2(float(size.x), float(size.y));

    vec4 col = vec4(0.0);
    float total = 0.0;

    for (int x = -blur_quality; x <= blur_quality; x++) {
        for (int y = -blur_quality; y <= blur_quality; y++) {
            vec2 offset = vec2(float(x), float(y)) * pixel_size * blur_radius;
            col += texture(SCREEN_TEXTURE, screen_uv + offset);
            total += 1.0;
        }
    }

    COLOR = col / total;
}
