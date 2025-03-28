/**
 * Experiment.Panorama Layout
 *
 * @summary A panoramic screen example.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height
local cols = 7

local bg = fe.add_artwork("snap", 0, 0, flw, flh)
bg.alpha = 50

local surf = fe.add_surface(flw, flh * 0.45)
surf.y = (flh - surf.height) * 0.5
surf.shader = fe.add_shader(Shader.Fragment, "panorama1.frag")
surf.shader.set_param("strength", 0.5) // amount of curvature [0..1]
surf.shader.set_param("dir", 0.5) // alignment [0..1]

local w = surf.width / cols
local h = surf.height
for (local x = 0; x < cols + 1; x++) {
    local art = surf.add_artwork("snap", x * w, 0, w, h)
    art.index_offset = x - cols / 2
    art.video_flags = Vid.ImagesOnly
}
