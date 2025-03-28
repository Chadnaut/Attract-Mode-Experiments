/**
 * Experiment.BumpMap Layout
 *
 * @summary Animated bumpmap spot-lights
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local art = fe.add_artwork("snap", 0, 0, flw, flh)
art.video_flags = Vid.ImagesOnly
art.preserve_aspect_ratio = true

art.shader = fe.add_shader(Shader.Fragment, "bump.frag")
art.shader.set_param("depth", 5.0)
art.shader.set_param("light1_rgba", 1.0, 0.0, 0.0, 1.0)
art.shader.set_param("light2_rgba", 0.0, 1.0, 0.0, 0.5)

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    local t = ttime / 1000.0

    art.shader.set_param(
        "light1_pos",
        0.5 + 0.5 * cos(t),
        0.5 + 0.5 * sin(t),
        0.5
    )

    art.shader.set_param(
        "light2_pos",
        0.5 + 0.5 * cos(t + PI),
        0.5 + 0.5 * sin(t + PI),
        0.5
    )
}

fe.add_transition_callback("on_transition")
function on_transition(ttype, var, ttime) {
    switch (ttype) {
        case Transition.ToNewList:
        case Transition.FromOldSelection:
            local w = art.texture_width
            local h = art.texture_height
            art.shader.set_param("texture_size", w, h)
            break
    }
}
