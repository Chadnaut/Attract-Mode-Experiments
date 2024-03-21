#version 120

uniform sampler2D texture;
uniform float mosaic = 0.01; // larger = more blocky
uniform float midpoint = 0.5; // lightness midpoint

void main() {
    vec4 pixel = texture2D(texture, floor(gl_TexCoord[0].xy / mosaic) * mosaic);
    float lightness = dot(pixel.rgb, vec3(0.412453, 0.357580, 0.180423));
    gl_FragColor = gl_Color;
    gl_FragColor.a *= step(midpoint, pixel.a) * step(lightness, midpoint);
}