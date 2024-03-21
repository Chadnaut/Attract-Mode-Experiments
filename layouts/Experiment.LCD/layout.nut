// source
local a = fe.add_artwork("wheel", 0, 0, fe.layout.width / 3, fe.layout.width / 3);

// background
local bg = fe.add_text("", a.width, 0, a.width, a.height);
bg.set_bg_rgb(79, 103, 87);

// lcd
local b = fe.add_artwork("wheel", bg.x, bg.y, bg.width, bg.height);
b.video_flags = Vid.ImagesOnly;
b.set_rgb(61, 71, 112);
b.shader = fe.add_shader(Shader.Fragment, "lcd.frag");
b.shader.set_param("mosaic", 0.02);
b.shader.set_param("midpoint", 0.7);