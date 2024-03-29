#version 120

uniform sampler2D texture;
uniform vec2 blur = vec2(0.0, 6.0);

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    gl_FragColor = gl_Color * texture2D(texture, uv, mix(blur.s, blur.t, uv.y));
}