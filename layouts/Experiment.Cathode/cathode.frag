/**
    Cathode Shader

    @summary Combination of cubemap and bezel shader for CRT style effects.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120
uniform sampler2D texture;

uniform float bezel_size = 0.1; // Radius of bezel [0.0...<0.5]
uniform float bezel_corner = 0.1; // Bezel corners [0.0...1.0]
uniform float bezel_blur = 3.0; // Mipmap level for bezel [0.0...10.0]
uniform float bezel_fade = 1.0; // Fade strength [0.0...1.0]
uniform float bezel_opacity = 0.5; // Opacity of bezel [0.0...1.0]
uniform float bezel_lighten = 0.0; // Adjust opacity by lightness [false=0|true=1]

uniform float screen_corner = 0.025; // Screen corners [0.0...1.0]
uniform float screen_crop = 0.0; // Crop texture instead of shrink [false=0|true=1]

uniform float cubemap_strength = 0.5; // curve amount
uniform vec2 cubemap_center = vec2(0.5); // center

vec2 cubemap(vec2 uv) {
    if (cubemap_strength == 0.0) return uv;
    vec2 cn = 4.0 * (uv - cubemap_center) * cubemap_strength;
    vec3 ro = vec3(0.0, 0.0, 2.0);
    vec3 ww = normalize(-ro);
    vec3 uu = normalize(cross(ww, vec3(0.0, 1.0, 0.0)));
    vec3 vv = normalize(cross(uu, ww));
    vec3 rd = normalize((cn.x * uu) + (cn.y * vv) + (2.5 * ww));
    float b = dot(rd, ro);
    float c = dot(ro, ro) - 1.0;
    float h = b * b - c;

    if (h > 0.0) {
        h = -b - sqrt(h);
        vec3 nor = vec3(normalize(ro + h * rd).xy, 1.0);
        vec2 q = nor.xy / nor.z;
        q = q * (1.25 - 0.25 * q * q) / cubemap_strength;
        vec2 s = cubemap_center + 0.5 * q;
        if (s.x >= 0.0 && s.x <= 1.0 && s.y >= 0.0 && s.y <= 1.0) return s;
    }
    return vec2(-1);
}

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
    // original point
    vec2 uv = gl_TexCoord[0].xy;

    // distort for crt-look
    uv = cubemap(uv);

    // screen corner
    float c = sdRoundBox(uv - 0.5, vec2(0.5), vec4(bezel_size + screen_corner));
    float b = step(c, -bezel_size);

    // alpha for bezel fadeout
    float d = sdRoundBox(uv - 0.5, vec2(0.5), vec4(bezel_corner));
    float a = mix(smoothstep(0.0, -bezel_size, d / bezel_fade) * bezel_opacity, 1.0, b);

    // mirror the bezel edges
    float n = 1.0 - bezel_size * 2.0;
    vec2 r = (uv - bezel_size) / n;
    vec2 m = vec2(mirror(r.x), mirror(r.y));

    // optionally crop the image instead of shrinking it
    if (screen_crop != 0.0) m = m * n + bezel_size;

    // sample the colour from the texture (or mipmap for blur) and apply bezel fadeout alpha
    vec4 col = gl_Color * texture2D(texture, m, (1.0 - b) * bezel_blur) * vec4(1.0, 1.0, 1.0, a);

    // optionally adjust bezel alpha luminance to keep only light colours
    if (bezel_lighten != 0.0 && (b == 0.0) && (r.x < 0.0 || r.x > 1.0 || r.y < 0.0 || r.y > 1.0)) col.a *= luminance(col.rgb);

    // done
    gl_FragColor = col;
}