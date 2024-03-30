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

vec4 empty = vec4(0,0,0,0);
vec4 sand = vec4(0,0,1,1);
vec4 sand_gen = vec4(0,0,250.0/255.0,1);
vec4 fire_gen = vec4(1,1,0,1);
vec4 fire = vec4(1,1,0,1);

bool is_empty(vec4 c) {
    return c.a <= 0.0;
}

bool is_sand_gen(vec4 c) {
    return c.r == 0.0 && c.g == 0.0 && c.b > 0.0;
}

bool is_sand(vec4 c) {
    return c == sand;
}

bool is_fire_gen(vec4 c) {
    return c == fire_gen;
}

bool is_fire(vec4 c) {
    return c.r > 0.0 && c.b == 0.0 && c.a > 0.0;
}

vec4 update_fire(vec4 c) {
    c.a -= 0.005;
    c.g -= 0.02;
    return c;
}

vec4 start_fire(vec2 uv) {
    vec4 col = fire;
    col.a = rand(uv);
    return update_fire(col);
}

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

    float r = rand(uv);

    if (is_empty(c[4])) {
        if (is_sand_gen(c[1]) && r < 0.1) {
            col = sand;
        }

        if (is_sand(c[1])) {
            col = sand;
        }

        if ((is_sand(c[5]) && is_sand(c[2])) || (is_sand(c[3]) && is_sand(c[0]))) {
            col = sand;
        }

        if (is_fire_gen(c[7])) {
            col = start_fire(uv);
        }

        if (is_fire(c[7])) {
            col = update_fire(c[7]);
        }

        if (r < 0.1) {
            if (is_fire(c[6])) {
                col = update_fire(c[6]);
            }
            if (is_fire(c[8])) {
                col = update_fire(c[8]);
            }
        }
    }

    if (is_sand(c[4])) {
        if (!is_empty(c[7])) {
            if (is_sand(c[7])) {
                if (is_empty(c[6]) || is_empty(c[8])) {
                    col = empty;
                } else {
                    col = sand;
                }
            } else {
                col = sand;
            }
        }
        if (
            is_fire(c[0])
            // || is_fire(c[1])
            || is_fire(c[2])
            || is_fire(c[3])
            || is_fire(c[5])
            || is_fire(c[6])
            || is_fire(c[7])
            || is_fire(c[8])
        ) {
            col = start_fire(uv);
        }
    }

    if (is_fire(c[7])) {
        if (r < 0.05) {
            col = empty;
        }
    }

    gl_FragColor = gl_Color * col;
}