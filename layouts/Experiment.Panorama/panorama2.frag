/**
    Panorama Shader2

    @summary A more circular style warping to create a panoramic effect.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform float distort = 0.0;
uniform float curve = 0.0;

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    float y = sqrt(uv.x - (uv.x * uv.x));
    float x = (uv.x < 0.5) ? y : 1.0 - y;
    uv.x = mix(uv.x, x, distort);
    uv.y = mix(uv.y, uv.y + y, curve) - (curve * 0.25);
    float a = step(0.0, uv.y) * step(uv.y, 1.0);
    gl_FragColor = a * gl_Color * texture2D(texture, uv);
}