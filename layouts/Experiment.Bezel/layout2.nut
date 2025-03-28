/**
 * Experiment.Bezel Layout
 *
 * @summary Bezel reflection effects, lighten only.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

fe.add_rectangle(0, 0, flw, flh)

local art = fe.add_artwork("snap", flw * 0.5, flh * 0.5, flw * 0.8, flh * 0.8)
art.anchor = Anchor.Centre
art.preserve_aspect_ratio = true
art.mipmap = true
art.shader = fe.add_shader(Shader.Fragment, "bezel.frag")
art.shader.set_param("size", 0.15)
art.shader.set_param("opacity", 1.0)
art.shader.set_param("blur", 0)
art.shader.set_param("lighten", true) // Helps reduce dark reflections
