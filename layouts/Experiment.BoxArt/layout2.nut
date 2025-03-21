/**
 * BoxArt Demo2
 *
 * @summary How to use the BoxArt shader.
 * @version 0.1.1 2025-03-21
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_rectangle(0, 0, flw, flh)

local im2 = fe.add_image("Wild West Rampage-01.png")
im2.set_pos(flw * 0.5, flh * 0.5, flw * 0.9, flh * 0.9)
im2.set_pos(flw * 0.5, flh * 0.5, flw * 0.9, flh * 0.9)
im2.preserve_aspect_ratio = true
im2.anchor = Anchor.Centre
im2.mipmap = true
im2.shader = fe.add_shader(Shader.Fragment, "boxart.frag")
im2.shader.set_param("mirror_p1", 0.0, 0.853)
im2.shader.set_param("mirror_p2", 0.092, 0.923)
im2.shader.set_param("mirror_p3", 1.0, 0.852)
im2.shader.set_param("mirror_opacity", 1.3, -1.0)
im2.shader.set_param("mirror_scale", 0.75)
im2.shader.set_param("scale", 0.7)
