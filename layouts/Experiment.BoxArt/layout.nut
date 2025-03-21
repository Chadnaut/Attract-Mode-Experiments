/**
 * BoxArt Demo
 *
 * @summary How to use the BoxArt shader.
 * @version 0.1.0 2025-03-21
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_rectangle(0, 0, flw, flh)
bg.set_rgb(255, 0, 0)

local im1 = fe.add_image("samsho2.png")
im1.set_pos(flw * 0.175, flh * 0.55, flw * 0.6, flh * 0.6)
im1.preserve_aspect_ratio = true
im1.anchor = Anchor.Centre
im1.shader = fe.add_shader(Shader.Fragment, "boxart.frag")
im1.shader.set_param("mirror_p1", 0.0, 0.968)
im1.shader.set_param("mirror_p2", 0.18, 0.996)
im1.shader.set_param("mirror_p3", 1.0, 0.900)
im1.shader.set_param("mirror_opacity", 0.5, -1.0)
im1.shader.set_param("mirror_scale", 0.75)
im1.shader.set_param("scale", 0.8)

local im2 = fe.add_image("scramble.png")
im2.set_pos(flw * 0.5, flh * 0.5, flw * 0.9, flh * 0.9)
im2.preserve_aspect_ratio = true
im2.anchor = Anchor.Centre
im2.shader = fe.add_shader(Shader.Fragment, "boxart.frag")
im2.shader.set_param("mirror_p1", 0.0, 0.968)
im2.shader.set_param("mirror_p2", 0.18, 0.996)
im2.shader.set_param("mirror_p3", 1.0, 0.900)
im2.shader.set_param("mirror_opacity", 0.5, -1.0)
im2.shader.set_param("mirror_scale", 0.75)
im2.shader.set_param("scale", 0.8)

local im3 = fe.add_image("bubsymphu.png")
im3.set_pos(flw * 0.825, flh * 0.55, flw * 0.6, flh * 0.6)
im3.preserve_aspect_ratio = true
im3.anchor = Anchor.Centre
im3.shader = fe.add_shader(Shader.Fragment, "boxart.frag")
im3.shader.set_param("mirror_p1", 0.0, 0.968)
im3.shader.set_param("mirror_p2", 0.18, 0.996)
im3.shader.set_param("mirror_p3", 1.0, 0.900)
im3.shader.set_param("mirror_opacity", 0.5, -1.0)
im3.shader.set_param("mirror_scale", 0.75)
im3.shader.set_param("scale", 0.8)
