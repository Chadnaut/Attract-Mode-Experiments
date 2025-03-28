/**
    Bumpmap Shader

    @summary Use the texture as a bumpmap for simple specular effects.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform vec2 texture_size = vec2(320.0, 240.0); // texture_width, texture_height
uniform float depth = 5.0; // bump depth

uniform vec3 light1_pos = vec3(0.5, 0.5, 0.5); // x, y, size
uniform vec4 light1_rgba = vec4(1.0, 1.0, 1.0, 0.5); // rgba
uniform float light1_type = 0.0; // 0 = point, 1 = horz, 2 = vert

uniform vec3 light2_pos = vec3(0.5, 0.5, 0.5);
uniform vec4 light2_rgba = vec4(1.0, 1.0, 1.0, 0.0);
uniform float light2_type = 0.0;

float lightness(vec3 c) {
    return dot(c, vec3(0.412453, 0.357580, 0.180423));
}

vec3 normal(vec2 uv) {
    vec2 px = vec2(1.0) / texture_size;
    float r = abs(lightness(texture2D(texture, uv + vec2(px.x, 0.0)).rgb));
    float l = abs(lightness(texture2D(texture, uv + vec2(-px.x, 0.0)).rgb));
    float d = abs(lightness(texture2D(texture, uv + vec2(0.0, px.y)).rgb));
    float u = abs(lightness(texture2D(texture, uv + vec2(0.0, -px.y)).rgb));
    return normalize(vec3((l-r)/2.0, (u-d)/2.0, 1.0/depth));
}

float specular(vec2 uv, vec3 n, vec3 spec, float type) {
    if (type == 1.0) spec.x = uv.x;
    if (type == 2.0) spec.y = uv.y;
    return pow(clamp(dot(
        normalize(reflect(spec - vec3(uv, 0.0), n)),
        vec3(0.0, 0.0, -1.0)
    ), 0.0, 1.0), 16.0);
}

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec4 col = texture2D(texture, uv);
    vec3 n = normal(uv);

    if (light1_rgba.a != 0.0) col.rgb += specular(uv, n, light1_pos, light1_type) * light1_rgba.rgb * light1_rgba.a;
    if (light2_rgba.a != 0.0) col.rgb += specular(uv, n, light2_pos, light2_type) * light2_rgba.rgb * light2_rgba.a;

    gl_FragColor = gl_Color * col;
    // gl_FragColor = vec4(n, 1.0); // show bump map
}