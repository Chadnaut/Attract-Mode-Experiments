/**
 * Experiment.BumpMap Layout4
 *
 * @summary Using bumpmap with the cubemap shader.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 *
 * `cubemap.frag` is from https://github.com/Chadnaut/Attract-Mode-Experiments/CubeMap
 */

local flw = fe.layout.width
local flh = fe.layout.height
local m = flw < flh ? flw : flh

// Surface with high-strength cubemap shader, turns contents into a sphere
local a = fe.add_surface(m, m)
a.set_pos(flw * 0.5, flh * 0.5)
a.rotation = 23.5
a.anchor = Anchor.Centre
a.rotation_origin = Origin.Centre
a.shader = fe.add_shader(Shader.Fragment, "cubemap.frag")
a.shader.set_param("strength", 1.0)

// Surface with bump shader, lights do not move while the content under them does
local b = a.add_surface(a.width, a.height)
b.shader = fe.add_shader(Shader.Fragment, "bump.frag")

b.shader.set_param("light1_pos", 0.25, 0.5, 0.5)
b.shader.set_param("light1_rgba", 0.0, 1.0, 1.0, 1.0)
b.shader.set_param("light1_type", 0)

b.shader.set_param("light2_pos", 1.0, 0.0, 0.5)
b.shader.set_param("light2_rgba", 1.0, 0.0, 1.0, 1.0)
b.shader.set_param("light2_type", 2)

// Artwork with texture repeat, the subimg is shifted on_tick to make it scroll
local c = b.add_artwork("snap", 0, 0, b.width, b.height)
c.video_flags = Vid.ImagesOnly
c.repeat = true

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    c.subimg_x -= 0.5
}
