/**
    Panorama Shader

    @summary A cosine style warping to create a panoramic effect.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform float strength = 0.5;
uniform float dir = 0.5;

#define PI 3.14159

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    float c = cos(abs(uv.x - 0.5) * PI) * strength;
    uv.y = uv.y * (1.0 + c) - (c * dir);
    float a = step(0.0, uv.y) * step(uv.y, 1.0);
    gl_FragColor = a * gl_Color * texture2D(texture, uv);
}