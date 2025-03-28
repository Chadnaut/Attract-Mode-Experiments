/**
 * Experiment.BumpMap Layout3
 *
 * @summary Using bumpmap with the cylinder shader.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 *
 * `cylinder.frag` is from https://github.com/Chadnaut/Attract-Mode-Experiments/Cylinder
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

local b = a.add_surface(a.width, a.height * 0.8)
b.set_pos(0, a.height * 0.1)
b.shader = fe.add_shader(Shader.Fragment, "bump.frag")

b.shader.set_param("light1_pos", 0, 0, 0.75)
b.shader.set_param("light1_rgba", 1, 1, 1, 1.0)
b.shader.set_param("light1_type", 2)

b.shader.set_param("light2_pos", 1, 0, 0.75)
b.shader.set_param("light2_rgba", 1, 0, 0, 1.0)
b.shader.set_param("light2_type", 2)

local c = b.add_artwork("snap", 0, 0, b.width * 2.0, b.height)
c.video_flags = Vid.ImagesOnly
c.repeat = true

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    c.subimg_x += 0.5
}
