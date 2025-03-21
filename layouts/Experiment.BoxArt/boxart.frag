/**
    BoxArt Reflection Shader

    @summary Draws a reflection under box art images.
    @version 0.1.0 2025-03-21
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Modules

    Pixels below the P1.P2.P3 boundary will be drawn as a mirror reflection.

    Basic settings for "MAME (Arcade) 3D Boxes Version 2 by Mr. Retrolust 2.9":
        .set_param("mirror_p1", 0.0, 0.968)
        .set_param("mirror_p2", 0.18, 0.996)
        .set_param("mirror_p3", 1.0, 0.900)
         _______
       /|       |
       ||  BOX  |
       ||  ART  |
       ||       |
     P1\|_______|
        P2     P3
*/
#version 120
uniform sampler2D texture;

uniform vec2 mirror_p1 = vec2(0.0); // Point P1
uniform vec2 mirror_p2 = vec2(0.0); // Point P2
uniform vec2 mirror_p3 = vec2(0.0); // Point P2

uniform vec2 mirror_opacity = vec2(1.0, 1.0); // Opacity of the reflection, near to far
uniform vec2 mirror_blur = vec2(0.0, 0.0); // LOD blur (requires mipmap), near to far
uniform float mirror_scale = 1.0; // Height ratio of the reflection
uniform float mirror_over = 0.0; // Layer mirror on top of image, true/false

uniform float scale = 1.0; // Pre-scale image to make room for reflection
uniform vec2 center = vec2(0.5, 0.0); // Scale center, defaults to centre-top

// True if uv is outside 0..1 range
bool is_outside(vec2 uv) {
    return (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0);
}

// Return y position of a line (p1,p2) at xpos
float get_ypos(float xpos, vec2 p1, vec2 p2) {
    float w = p2.x - p1.x;
    float h = p2.y - p1.y;
    float x = xpos - p1.x;
    float y = x / w * h;
    return p1.y + y;
}

// Return y position of line (p1,p2,p3) at uv.x
float get_y(vec2 uv) {
    if (uv.x < mirror_p1.x || uv.x > mirror_p3.x) return 1.0;
    if (uv.x < mirror_p2.x) return get_ypos(uv.x, mirror_p1, mirror_p2);
    return get_ypos(uv.x, mirror_p2, mirror_p3);
}

// Alpha composite b over a
vec4 composite_alpha(vec4 a, vec4 b) {
    float c = b.a + a.a * (1.0 - b.a);
    return vec4(clamp((b.a * b.rgb + a.a * a.rgb * (1.0 - b.a)) / c, 0.0, 1.0), c);
}

void main() {
    // scale image to make room for reflection
    vec2 uv = gl_TexCoord[0].xy;
    uv = (uv - center) / scale + center;
    vec4 col = is_outside(uv) ? vec4(0.0) : texture2D(texture, uv);

    // find mirror boundary
    float y = get_y(uv);
    float d = (uv.y - y) / mirror_scale;

    if (d > 0) {
        // adjust uv if below the line
        uv.y = y - d;
        float lod = mix(mirror_blur.s, mirror_blur.t, d);
        float a = max(0.0, mix(mirror_opacity.s, mirror_opacity.t, d));

        // composite the reflection colour
        if (!is_outside(uv)) {
            vec4 col2 = texture2D(texture, uv, lod) * vec4(vec3(1.0), a);
            col = bool(mirror_over)
                ? composite_alpha(col, col2)
                : composite_alpha(col2, col);
        }
    }

    gl_FragColor = gl_Color * col;
}