local sand = [0, 0, 255];
local sand_gen = [0, 0, 250];
local fire = [255, 255, 0];
local fire_gen = [255, 255, 0];
local brick = [250, 250, 250];

function apply_rgb(target, rgb) {
    target.set_rgb(rgb[0], rgb[1], rgb[2]);
}

local a = ::fe.add_surface(fe.layout.width, fe.layout.height);

// text
local sd = a.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20);
sd.align = Align.BottomLeft;
apply_rgb(sd, brick);

local title = a.add_text("Fire Shader", 0, fe.layout.height * 0.3, fe.layout.width, fe.layout.height / 5.5);
apply_rgb(title, brick);

local subtitle = a.add_text("Click to change paddle state", 0, fe.layout.height * 0.55, fe.layout.width, fe.layout.height / 15);
apply_rgb(subtitle, brick);

local layout = a.add_text(split(fe.script_file, ".")[0], 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20);
layout.align = Align.BottomRight;
apply_rgb(layout, brick);

// sand
local sand_obj = a.add_rectangle(0, 0, a.width, 1);
apply_rgb(sand_obj, sand_gen);

// paddle
local paddle = a.add_rectangle(100, 100, fe.layout.width / 5, fe.layout.height / 40);
apply_rgb(paddle, brick);
paddle.set_anchor(0.5, 0);

// floor
local floor = a.add_rectangle(0, fe.layout.height-1, fe.layout.width, 1);
apply_rgb(floor, brick);

// feedback loop
local b = ::fe.add_surface(a.width, a.height);
b.mipmap = true;
local c = b.add_clone(a);
local d = a.add_clone(b);
d.zorder = -2147483647;
d.shader = ::fe.add_shader(Shader.Fragment, "sand2.frag")
d.shader.set_texture_param("texture2", a);
d.shader.set_param("size", d.width, d.height);
c.set_pos(0, 0);
b.visible = false;
a.blend_mode = BlendMode.Alpha;

local random = @(min, max) min + rand() * (max - min) / RAND_MAX;
local click = false;
local state = 0;
local states = [
    brick,
    sand_gen,
    fire_gen
];

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    d.shader.set_param("rand_seed", random(0.0, 1.0));
    paddle.set_pos(fe.get_input_pos("Mouse Left"), fe.get_input_pos("Mouse Up"));

    local press = fe.get_input_state("Mouse LeftButton");
    if (press && !click) apply_rgb(paddle, states[++state % states.len()]);
    click = press;
}