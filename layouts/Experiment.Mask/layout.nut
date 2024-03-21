// a basic cutout mask uses white + transparency
local mask = fe.add_image("mask.png");
mask.visible = false;

local art = fe.add_artwork("snap", 50, 50, 400, 400);
art.video_flags = Vid.ImagesOnly;

art.shader = ::fe.add_shader(Shader.Fragment, "mask.frag");
art.shader.set_texture_param("mask", mask);

// --------------------------------------

// a colour filtering mask uses rgb + transparency
local mask2 = fe.add_image("mask2.png");
mask2.visible = false;

local art2 = fe.add_artwork("snap", 500, 50, 400, 400);
art2.video_flags = Vid.ImagesOnly;

art2.shader = ::fe.add_shader(Shader.Fragment, "mask.frag");
art2.shader.set_texture_param("mask", mask2);

// --------------------------------------

// text on a surface - the shader applies to the entire surface
// keep it a similar size to the text inside
local surface = fe.add_surface(400, 100);
surface.set_pos(50, 500);
local text = surface.add_text("Sample", 0, 0, surface.width, surface.height);
text.char_size = 100;

surface.shader = ::fe.add_shader(Shader.Fragment, "mask.frag");
surface.shader.set_texture_param("mask", mask2); // <-- reuses the mask above
surface.shader.set_param("mirror", false, true); // <-- mirror y for surface