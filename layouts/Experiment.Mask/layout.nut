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
