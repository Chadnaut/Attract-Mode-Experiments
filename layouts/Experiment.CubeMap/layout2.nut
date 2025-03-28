/**
 * Experiment.CubeMap Layout2
 *
 * @summary Cubemap distortion effects with extreme curvature.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local img = fe.add_artwork("snap", flw * 0.5, flh * 0.5, flw * 0.75, flh * 0.75)
img.anchor = Anchor.Centre
img.shader = fe.add_shader(Shader.Fragment, "cubemap.frag")
img.shader.set_param("strength", 0.75)
