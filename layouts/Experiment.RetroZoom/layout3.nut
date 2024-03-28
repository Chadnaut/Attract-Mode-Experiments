fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
fe.add_text(split(fe.script_file, ".")[0], 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomRight;
//===================================================

fe.load_module("retention");

local surf = fe.add_surface(fe.layout.width*0.8, fe.layout.height*0.8);
surf.set_pos(fe.layout.width*0.1, fe.layout.height*0.1);

local wheel = surf.add_artwork("wheel", surf.width/2, surf.height, 0, 0);
wheel.set_anchor(0.5, 1.0);
wheel.preserve_aspect_ratio = true;
wheel.mipmap = true;
wheel.zorder = 2;

local wheel2 = surf.add_clone(wheel);
wheel2.red = 0;
wheel2.green = 0;
wheel2.blue = 0;
wheel2.zorder = 1;

local s2 = Retention(surf);
s2.persistance = 1.0;

local scale = 0.0;
local scale2 = -1.0;
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (scale < 1.0) {
        scale += 0.01;
        wheel.width = surf.width * scale;
        wheel.height = surf.height * scale;
    }
    if (scale2 < 1.0) {
        scale2 += 0.01;
        wheel2.width = surf.width * scale2;
        wheel2.height = surf.height * scale2;
    }
}

fe.add_transition_callback("on_transition");
function on_transition(ttype, var, ttime) {
    switch (ttype) {
        case Transition.ToNewList:
        case Transition.ToNewSelection:
            scale = 0.0;
            scale2 = -1.0;
            break;
    }
}