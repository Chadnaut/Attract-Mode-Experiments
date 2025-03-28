/**
 * Experiment.Panorama Layout4
 *
 * @summary A cylinder effect
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local a = fe.add_surface(flw * 0.4, flh)
a.set_pos(flw * 0.5, flh * 0.5)
a.anchor = Anchor.Centre
a.shader = fe.add_shader(Shader.Fragment, "cylinder.frag")
a.shader.set_param("distort", 0.25)
a.shader.set_param("curve1", 0.2)
a.shader.set_param("curve2", -0.2)

local c = a.add_artwork("snap", 0, a.height * 0.1, a.width * 2.0, a.height * 0.8)
c.video_flags = Vid.ImagesOnly
c.repeat = true

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    c.subimg_x += 0.5
}
