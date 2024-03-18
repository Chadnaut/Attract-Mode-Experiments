// surface contains artwork
local s = fe.add_surface(fe.layout.width, fe.layout.height * 0.6);
s.mipmap = true; // <-- required for LOD blur

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

// the reflection surface
local r = fe.add_surface(s.width, fe.layout.height - s.height);
r.y = s.height;
r.shader = ::fe.add_shader(Shader.Fragment, "shader.frag");
r.shader.set_texture_param("source", s); // <-- pass in the artwork surface
r.shader.set_param("blur", 0.0, 4.0); // from & to blur strength

// floor overlay for effect
local f = fe.add_image("floor.png", r.x, r.y, r.width, r.height);