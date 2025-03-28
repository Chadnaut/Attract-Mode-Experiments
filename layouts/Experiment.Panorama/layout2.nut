/**
 * Experiment.Panorama Layout2
 *
 * @summary A rounder panoramic screen.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local bg = fe.add_artwork("snap", 0, 0, flw, flh)
bg.alpha = 50

local surf = fe.add_surface(flw, flh)
surf.shader = fe.add_shader(Shader.Fragment, "panorama2.frag")
surf.shader.set_param("distort", 0.25)
surf.shader.set_param("curve", 0.5)

local art = surf.add_artwork("snap", 0, flh * 0.25, flw, flh * 0.5)
