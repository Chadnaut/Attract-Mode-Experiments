#version 120

uniform sampler2D texture;
uniform sampler2D texture2;
uniform vec2 size = vec2(0, 0);
uniform float rand_seed = 0.0;
uniform float phase = 0.0;

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

vec4 empty = vec4(0, 0, 0, 0);
vec4 brick = vec4(1, 1, 1, 1);

vec4 sand_gen = vec4(0, 0, 1, 1);
vec4 sand = vec4(0, 0, 0.98, 1);
vec4 sand2 = vec4(0.35, 0.35, 0.99, 1);

vec4 fire_gen = vec4(1, 1, 0, 1);
vec4 fire = vec4(1, 0, 0, 0);
vec4 fire2 = vec4(1, 1, 0.5, 1);
float fire_shift_chance = 0.1;

vec4 earth = vec4(0, 0.3, 0.0, 1);
vec4 earth2 = vec4(0, 1.0, 0.25, 1);

//===================================================

bool between(vec4 a, vec4 b, vec4 c) {
    if (a.r < b.r || a.r > c.r) return false;
    if (a.g < b.g || a.g > c.g) return false;
    if (a.b < b.b || a.b > c.b) return false;
    if (a.a < b.a || a.a > c.a) return false;
    return true;
}

bool is_empty(vec4 c) {
    return c.a <= 0.0;
}

bool is_sand_gen(vec4 c) {
    return c == sand_gen;
}

bool is_sand(vec4 c) {
    return between(c, sand, sand2);
}

bool is_fire_gen(vec4 c) {
    return c == fire_gen;
}

bool is_fire(vec4 c) {
    return between(c, fire, fire2);
}

bool is_earth(vec4 c) {
    return between(vec4(c.rgb, 1), earth, earth2);
}

vec4 convert_sand(float m) {
    return mix(sand, sand2, m);
}

vec4 start_sand() {
    return convert_sand(phase);
}

vec4 update_fire(vec4 c) {
    float a = c.a - 0.005;
    c = mix(fire, fire2, a*a);
    c.a = a;
    return c;
}

vec4 start_fire(float r) {
    vec4 col = fire;
    col.a = 0.25 + (r * 0.75);
    return update_fire(col);
}

vec4 start_earth(vec2 uv) {
    float p = phase * 2.0;
    return mix(earth, earth2, p > 1.0 ? 2.0 - p : p);
}

vec4 get_pixel(vec2 p) {
    if (p.x < 0.0 || p.x > 1.0 || p.y < 0.0 || p.y > 1.0) return brick;
    return texture2D(texture, vec2(p.x, 1.0 - p.y));
}

void main() {
    vec2 uv = gl_TexCoord[0].xy;
    vec4 col = texture2D(texture2, uv);
    vec2 px = 1.0 / size;
    uv.y = 1.0 - uv.y;

    // 5x5 points
    vec2 p2[25] = vec2[](
        uv + px*vec2(-2,-2), uv + px*vec2(-1,-2), uv + px*vec2(0,-2), uv + px*vec2(1,-2), uv + px*vec2(2,-2),
        uv + px*vec2(-2,-1), uv + px*vec2(-1,-1), uv + px*vec2(0,-1), uv + px*vec2(1,-1), uv + px*vec2(2,-1),
        uv + px*vec2(-2, 0), uv + px*vec2(-1, 0), uv + px*vec2(0, 0), uv + px*vec2(1, 0), uv + px*vec2(2, 0),
        uv + px*vec2(-2, 1), uv + px*vec2(-1, 1), uv + px*vec2(0, 1), uv + px*vec2(1, 1), uv + px*vec2(2, 1),
        uv + px*vec2(-2, 2), uv + px*vec2(-1, 2), uv + px*vec2(0, 2), uv + px*vec2(1, 2), uv + px*vec2(2, 2)
    );

    // 5x5 pixels
    vec4 c2[25] = vec4[](
        get_pixel(p2[0]),  get_pixel(p2[1]),  get_pixel(p2[2]),  get_pixel(p2[3]),  get_pixel(p2[4]),
        get_pixel(p2[5]),  get_pixel(p2[6]),  get_pixel(p2[7]),  get_pixel(p2[8]),  get_pixel(p2[9]),
        get_pixel(p2[10]), get_pixel(p2[11]), get_pixel(p2[12]), get_pixel(p2[13]), get_pixel(p2[14]),
        get_pixel(p2[15]), get_pixel(p2[16]), get_pixel(p2[17]), get_pixel(p2[18]), get_pixel(p2[19]),
        get_pixel(p2[20]), get_pixel(p2[21]), get_pixel(p2[22]), get_pixel(p2[23]), get_pixel(p2[24])
    );

    /*
    0  1  2  3  4
    5  6  7  8  9
    10 11 12 13 14
    15 16 17 18 19
    20 21 22 23 24
    */

    // random for this point
    float r = rand(uv);

    // current is empty
    if (is_empty(c2[12])) {
        // sand gen above creates new sand below
        if (is_sand_gen(c2[7]) && (r < 0.1)) {
            col = start_sand();
        }

        // sand falling from above
        if (is_sand(c2[7])) {
            col = c2[7];
        }

        // sliding sand
        bool slide_from_left = is_sand(c2[6]) && !is_empty(c2[11]) && !is_empty(c2[10]);
        bool slide_from_right = is_sand(c2[8]) && !is_empty(c2[13]) && !is_empty(c2[14]);
        if (slide_from_left && slide_from_right) {
            col = (r < 0.5) ? c2[6] : c2[8];
        } else if (slide_from_left) {
            col = c2[6];
        } else if (slide_from_right) {
            col = c2[8];
        }

        // fire gen below creates new fire above
        if (is_fire_gen(c2[17])) {
            col = start_fire(r);
        } else
        // fire below, rising fire
        if (is_fire(c2[17]) && r >= (fire_shift_chance * 2.0)) {
            col = update_fire(c2[17]);
        } else
        // fire random shift right
        if (is_fire(c2[16]) && r >= fire_shift_chance && r < (fire_shift_chance * 2.0)) {
            col = update_fire(c2[16]);
        } else
        // fire random shift left
        if (is_fire(c2[18]) && r >= 0.0 && r < fire_shift_chance) {
            col = update_fire(c2[18]);
        }

        // earth created in diagonals
        if ((r < 0.14) && (
            (is_earth(c2[0]) && is_earth(c2[6]))
            || (is_earth(c2[4]) && is_earth(c2[8]))
            || (is_earth(c2[20]) && is_earth(c2[16]))
            || (is_earth(c2[24]) && is_earth(c2[18]))
        )) {
            col = start_earth(uv);
        }
    }

    if (is_sand(c2[12])) {
        if (!is_empty(c2[17])) {
            // sand blocked from below
            col = c2[12];

            // sand slid to left
            if (is_empty(c2[16]) && (!is_empty(c2[18]))) {
                col = empty;
            } else
            // sand slid to right
            if (is_empty(c2[18]) && (!is_empty(c2[16]))) {
                col = empty;
            }
        } else {
            // sand fell into empty space
            col = empty;

            // sand blocked by slide from left
            if (is_sand(c2[11]) && !is_empty(c2[16]) && (!is_empty(c2[15]))) {
                col = c2[12];
            }
            // sand blocked by slide from right
            if (is_sand(c2[13]) && !is_empty(c2[18]) && (!is_empty(c2[19]))) {
                col = c2[12];
            }
        }

        // sand catch on fire
        if (
            is_fire(c2[6])
            || is_fire(c2[7])
            || is_fire(c2[8])
            || is_fire(c2[11])
            || is_fire(c2[13])
            || is_fire(c2[16])
            || is_fire(c2[17])
            || is_fire(c2[18])

            || is_fire(c2[10])
            || is_fire(c2[15])

            || is_fire(c2[14])
            || is_fire(c2[19])

            || is_fire(c2[21])
            || is_fire(c2[22])
            || is_fire(c2[23])

        ) {
            col = start_fire(r);
        }
    }

    if (is_earth(c2[12])) {
        if (
            is_sand(c2[0])
            || is_sand(c2[1])
            || is_sand(c2[2])
            || is_sand(c2[3])
            || is_sand(c2[4])

            || is_sand(c2[6])
            || is_sand(c2[7])
            || is_sand(c2[8])

            || is_sand(c2[11])
            || is_sand(c2[13])

            || is_sand(c2[16])
            || is_sand(c2[17])
            || is_sand(c2[18])
        ) {
            col = empty;
        } else {
            col = c2[12];

            if (col.a > 0.45) {
                col.a -= 0.0025;
            } else {
                // dip before sandify
                if (phase > 0.90 && col.a > 0.01) {
                    col.a -= 0.01;
                }
                if (phase > 0.99) {
                    if ((mod(floor(p2[12].x * size.x), 2.0) == 0.0)) {
                        col = convert_sand(col.g);
                    }
                }
            }
        }

        // force sand gen over earth
        if (is_sand_gen(c2[7])) {
            col = start_sand();
        }
    }

    // if (!is_empty(c2[12]) && is_fire(c2[12])) {
    //     col = update_fire(c2[12]);
    // }

    if (
        is_fire(c2[12])
        || is_fire(c2[7])
        || is_fire(c2[11])
        || is_fire(c2[13])
        || is_fire(c2[17])
    ) {
        if (
            is_earth(c2[7])
            || is_earth(c2[11])
            || is_earth(c2[13])
            || is_earth(c2[17])
        ) {
            col = start_earth(uv);
        }
    }

    gl_FragColor = gl_Color * col;
}