/**
 * Experiment.Cathode Layout
 *
 * @summary Cubemap, bezel glow, and screen corners.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local art1 = fe.add_artwork("snap", flw * 0.5, flh * 0.5, flw, flh)
art1.anchor = Anchor.Centre
art1.preserve_aspect_ratio = true
art1.mipmap = true
art1.shader = fe.add_shader(Shader.Fragment, "cathode.frag")
art1.shader.set_param("bezel_size", 0.1)
art1.shader.set_param("bezel_opacity", 0.35)
art1.shader.set_param("bezel_blur", 3)
art1.shader.set_param("bezel_corner", 0.1)
art1.shader.set_param("bezel_fade", 1.0)
art1.shader.set_param("screen_corner", 0.05);
art1.shader.set_param("cubemap_strength", 0.5)
