fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
fe.add_text(split(fe.script_file, ".")[0], 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomRight;
//===================================================

local surf = fe.add_surface(fe.layout.width*0.8, fe.layout.height*0.8);
surf.set_pos(fe.layout.width*0.1, fe.layout.height*0.1);

local wheel = surf.add_artwork("wheel", surf.width/2, surf.height, 0, 0);
wheel.set_anchor(0.5, 1.0);
wheel.preserve_aspect_ratio = true;
wheel.mipmap = true;

local scale = 0.0;
fe.add_ticks_callback("on_tick");
function on_tick(ttime) {
    if (scale > 0.0) surf.clear = false;
    if (scale < 1.0) {
        scale += 0.01;
        wheel.width = surf.width * scale;
        wheel.height = surf.height * scale;
    }
}

fe.add_transition_callback("on_transition");
function on_transition(ttype, var, ttime) {
    switch (ttype) {
        case Transition.ToNewList:
        case Transition.ToNewSelection:
            scale = 0.0;
            surf.clear = true;
            break;
    }
}