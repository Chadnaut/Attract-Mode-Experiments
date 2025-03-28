/**
    Cubemap Shader

    @summary Cubemap texture distortion.
    @version 0.0.1 2025-03-27
    @author Chadnaut
    @url https://github.com/Chadnaut/Attract-Mode-Experiments
*/

#version 120

uniform sampler2D texture;
uniform float strength = 0.5;
uniform vec2 center = vec2(0.5);

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec4 col = vec4(0.0);

    if (strength == 0) {
	    col = texture2D(texture, uv);
    } else {
        vec2 cn = 4.0 * (uv - center) * strength;
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
            q = q * (1.25 - 0.25 * q * q) / strength;

            vec2 s = center + 0.5 * q;
            if (s.x >= 0.0 && s.x <= 1.0 && s.y >= 0.0 && s.y <= 1.0) {
                col = texture2D(texture, s);
            }
        }
    }

	gl_FragColor = gl_Color * col;
}