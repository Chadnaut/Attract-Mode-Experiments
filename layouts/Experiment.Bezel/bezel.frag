/**
    Bezel reflection shader

    @summary Draws a fading reflection around the edges of the texture.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform float size = 0.0;
uniform float opacity = 0.0;
uniform float blur = 0.0;
uniform float crop = 0.0;
uniform float lighten = 0.0;

float mirror(float v) {
    return (mod(floor(v), 2.0) != 0.0) ? 1.0 - mod(v, 1.0) : mod(v, 1.0);
}

float sdRoundBox(vec2 p, vec2 b, vec4 r) {
    r.xy = (p.x > 0.0) ? r.xy : r.zw;
    r.x  = (p.y > 0.0) ? r.x : r.y;
    vec2 q = abs(p) - b + r.x;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r.x;
}

float luminance(vec3 c) {
	return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    float d = sdRoundBox(uv - 0.5, vec2(0.5), vec4(size));
    float a = step(d, -size) + smoothstep(0.0, -size, d) * opacity;
    float n = 1.0 - size * 2.0;
    vec2 r = (uv - size) / n;
    vec2 m = vec2(mirror(r.x), mirror(r.y));
    if (crop != 0.0) m = m * n + size;
    vec4 col = gl_Color * texture2D(texture, m, step(a, 1.0) * blur) * vec4(1.0, 1.0, 1.0, a);
    if (bool(lighten) && (r.x < 0.0 || r.x > 1.0 || r.y < 0.0 || r.y > 1.0)) col.a *= luminance(col.rgb);
    gl_FragColor = col;
}