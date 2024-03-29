fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

local a = ::fe.add_surface(fe.layout.width, fe.layout.height);

a.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
a.add_text("Sand Shader", 0, fe.layout.height * 0.3, fe.layout.width, fe.layout.height / 5);
a.add_text("Move the paddle with your mouse", 0, fe.layout.height * 0.55, fe.layout.width, fe.layout.height / 15);

// generates sand
local sand = a.add_rectangle(0, 0, a.width, 1);
sand.set_rgb(0, 0, 255);

// paddle
local paddle = a.add_rectangle(100, 100, fe.layout.width / 5, fe.layout.height / 40);

// floor
local floor = a.add_rectangle(0, fe.layout.height-1, fe.layout.width, 1);

// feedback loop
local b = ::fe.add_surface(a.width, a.height);
b.mipmap = true;
local c = b.add_clone(a);
local d = a.add_clone(b);
d.zorder = -2147483647;
d.shader = ::fe.add_shader(Shader.Fragment, "sand.frag")
d.shader.set_texture_param("texture2", a);
d.shader.set_param("size", d.width, d.height);
c.set_pos(0, 0);
b.visible = false;

local random = @(min, max) min + rand() * (max - min) / RAND_MAX;
local click = false;

fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    d.shader.set_param("rand_seed", random(0.0, 1.0));
    paddle.set_pos(fe.get_input_pos("Mouse Left"), fe.get_input_pos("Mouse Up"));
}