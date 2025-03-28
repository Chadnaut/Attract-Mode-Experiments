/**
    BoxArt Reflection Shader

    @summary Draws a reflection under box art images.
    @version 0.2.0 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments

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

    Note:
    - Artwork scaling uses nearest-neighbor
      - Use `mipmap = true` for smoother results
    - Mirror uses the same LOD as scaled Artwork
      - When `mirror_scale` < 1.0 the reflection will contain nearest-neighbor aliasing
      - Use `mirror_blur` setting for smoother results
    - Anisotropic Filtering will *vastly* improve the `mirror_blur` quality
      - Configure > General > Anisotropic Filter
*/
#version 120

#define DELTA 1e-6

uniform sampler2D texture;

uniform vec2 mirror_p1 = vec2(0.0, 0.75); // Point P1 (x, y)
uniform vec2 mirror_p2 = vec2(0.5, 0.75); // Point P2 (x, y)
uniform vec2 mirror_p3 = vec2(1.0, 0.75); // Point P2 (x, y)

uniform vec2 mirror_opacity = vec2(1.0, 1.0); // Reflection opacity, (top, bottom)
uniform vec2 mirror_blur = vec2(0.0, 0.0); // LOD blur (requires mipmap), (top, bottom)
uniform float mirror_scale = 1.0; // Reflection height

uniform vec2 center = vec2(0.5, 0.0); // Scale center, defaults to centre-top (x, y)
uniform vec2 translate = vec2(0.0, 0.0); // Texture translate (x, y)
uniform float opacity = 1.0; // Texture opacity
uniform float scale = 1.0; // Texture scale

// Resize uv around center, and translate */
vec2 resize(vec2 uv) {
    return (uv - center) / scale + center - translate;
}

// Return the mipmap level used at the given position
float get_mipmap(vec2 uv) {
    vec2 dx = dFdx(uv);
    vec2 dy = dFdy(uv);
    return 0.5 * log2(max(dot(dx, dx), dot(dy, dy)));
}

// Return y position of a line (p1, p2) at xpos
float get_pos(float xpos, vec2 p1, vec2 p2) {
    float w = p2.x - p1.x;
    float h = p2.y - p1.y;
    float x = xpos - p1.x;
    float y = x / w * h;
    return p1.y + y;
}

// Return the y position of line (p1, p2, p3) at uv.x
float get_line(vec2 uv) {
    float a = step(uv.x, mirror_p2.x);
    float b = 1.0 - a;
    vec2 p1 = a * mirror_p1 + b * mirror_p2;
    vec2 p2 = a * mirror_p2 + b * mirror_p3;
    return get_pos(uv.x, p1, p2);
}

// Alpha composite b over a
vec4 composite_alpha(vec4 a, vec4 b) {
    float c = b.a + a.a * (1.0 - b.a) + DELTA; // Delta fixed div/0
    return vec4((b.a * b.rgb + a.a * a.rgb * (1.0 - b.a)) / c, c);
}

// Return a texture sample at the given position, or transparent if out-of-range
vec4 sample(vec2 uv, float bias) {
    float a = step(0.0, uv.x) * step(uv.x, 1.0) * step(0.0, uv.y) * step(uv.y, 1.0);
    return a * texture2D(texture, uv, bias);
}

void main() {
    // scale art to make room for reflection
    vec2 uv = resize(gl_TexCoord[0].xy);
    vec4 col = sample(uv, 0.0);

    // distance from mirror boundary
    float line = get_line(uv);
    float dist = (uv.y - line) / mirror_scale;

    // invert position
    vec2 uv2 = vec2(uv.x, line - dist);
    float bias = mix(mirror_blur.s, mirror_blur.t, dist);

    // offset the bias to sample at the same LOD as the art
    float boff = get_mipmap(uv) - get_mipmap(uv2);
    vec4 col2 = sample(uv2, bias + boff);
    col2.a = min(col2.a, sample(uv2, boff).a); // art LOD alpha prevents mipmap bleed

    // fadeout alpha
    col2.a *= clamp(mix(mirror_opacity.s, mirror_opacity.t, dist), 0.0, 1.0);
    col.a *= opacity;

    // compose image over the reflection
    gl_FragColor = gl_Color * composite_alpha(col2, col);
}