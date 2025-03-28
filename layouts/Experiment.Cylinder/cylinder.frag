/**
    Cylinder Shader

    @summary Cylindrical texture distortion.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform float distort = 0.0;
uniform float curve1 = 0.0;
uniform float curve2 = 0.0;

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    float c = mix(curve1, curve2, uv.y);
    float y = sqrt(uv.x - (uv.x * uv.x));
    float x = (uv.x < 0.5) ? y : 1.0 - y;
    vec2 dp = vec2(mix(uv.x, x, distort), mix(uv.y, uv.y + y, c) - (c * 0.25));
    float a = step(0.0, dp.y) * step(dp.y, 1.0);
    gl_FragColor = gl_Color * texture2D(texture, dp) * a;
}