#version 120

uniform sampler2D texture;
uniform sampler2D mask;
uniform vec2 mirror = vec2(0, 0);

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec2 uv2 = vec2(bool(mirror.x) ? 1.0 - uv.x : uv.x, bool(mirror.y) ? 1.0 - uv.y : uv.y);
    gl_FragColor = gl_Color * texture2D(texture, uv) * texture2D(mask, uv2);
}