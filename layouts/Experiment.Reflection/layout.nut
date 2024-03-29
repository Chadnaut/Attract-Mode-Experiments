// surface contains artwork
local s = fe.add_surface(fe.layout.width, fe.layout.height * 0.6);
s.mipmap = true; // <-- required for blur shader

// some artwork for the surface
local cols = 4;
local rows = 2;
local w = s.width / cols;
local h = s.height / rows;
local m = s.width * 0.01;
for (local x=0; x<cols+1; x++) {
    for (local y=0; y<rows; y++) {
        local a = s.add_artwork("snap", x * w + (y % 2 * w / -2.0), y * h, w - m, h - m);
        a.index_offset = x + y * cols;
    }
}

// clone the artwork surface
local r = fe.add_clone(s);
r.y = s.height;
r.height = fe.layout.height - s.height;
r.subimg_y = r.subimg_height;
r.subimg_height *= -1;

// shader for blurring only
r.shader = ::fe.add_shader(Shader.Fragment, "reflection.frag");
r.shader.set_param("blur", 0.0, 4.0); // from & to blur strength

// floor overlay for effect
local f = fe.add_image("floor.png", r.x, r.y, r.width, r.height);