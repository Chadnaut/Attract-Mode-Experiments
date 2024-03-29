#version 120

uniform sampler2D texture;
uniform sampler2D texture2;
uniform vec2 size = vec2(0, 0);
uniform float rand_seed = 0.0;

//===================================================

#define TWO_PI 6.283185307179586476925286766559
const float RAND_X = 12.9898;
const float RAND_Y = 78.233;
const float RAND_Z = 43758.5453123;

float rand(float v) {  return fract(sin(mod(rand_seed + v, TWO_PI)) * RAND_Z); }
float rand(vec2 v) {   return rand(dot(v, vec2(RAND_X, RAND_Y))); }
float rand(vec3 v) {   return rand(dot(v, vec3(RAND_X, RAND_Y, RAND_X))); }
float rand(vec4 v) {   return rand(dot(v, vec4(RAND_X, RAND_Y, RAND_X, RAND_Y))); }

//===================================================

vec4 red = vec4(1,0,0,1); // sand
vec4 blue = vec4(0,0,1,1); // generator
vec4 black = vec4(0,0,0,0); // bg

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec4 col = texture2D(texture2, uv);
    vec2 px = 1.0 / size;
    uv.y = 1.0 - uv.y;

    /*
    0 1 2
    3 4 5
    6 7 8
    */

    vec2 p[9] = vec2[](
        uv + px * vec2(-1, -1),
        uv + px * vec2(0, -1),
        uv + px * vec2(1, -1),
        uv + px * vec2(-1 ,0),
        uv + px * vec2(0, 0),
        uv + px * vec2(1, 0),
        uv + px * vec2(-1, 1),
        uv + px * vec2(0, 1),
        uv + px * vec2(1, 1)
    );

    vec4 c[9] = vec4[](
        texture2D(texture, vec2(p[0].x, 1.0 - p[0].y)),
        texture2D(texture, vec2(p[1].x, 1.0 - p[1].y)),
        texture2D(texture, vec2(p[2].x, 1.0 - p[2].y)),
        texture2D(texture, vec2(p[3].x, 1.0 - p[3].y)),
        texture2D(texture, vec2(p[4].x, 1.0 - p[4].y)),
        texture2D(texture, vec2(p[5].x, 1.0 - p[5].y)),
        texture2D(texture, vec2(p[6].x, 1.0 - p[6].y)),
        texture2D(texture, vec2(p[7].x, 1.0 - p[7].y)),
        texture2D(texture, vec2(p[8].x, 1.0 - p[8].y))
    );

    if (c[4] == black) {
        if (c[1] == blue && rand(uv) < 0.1) {
            col = red;
        }

        if (c[1] == red) {
            col = red;
        }

        if ((c[5] == red && c[2] == red) || (c[3] == red && c[0] == red)) {
            col = red;
        }
    }

    if (c[4] == red) {
        if (c[7] != black) {
            if (c[7] == red) {
                if (c[6] == black || c[8] == black) {
                    col = black;
                } else {
                    col = red;
                }
            } else {
                col = red;
            }
        }
    }

    gl_FragColor = gl_Color * col;
}