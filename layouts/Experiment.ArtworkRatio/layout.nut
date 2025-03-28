/**
 * Experiment.AspectRatio
 *
 * @summary Match an Artworks aspect ratio.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 */

local flw = fe.layout.width
local flh = fe.layout.height

local art1 = fe.add_artwork("snap")
art1.set_pos(flw * 0.02, flh * 0.03)

local art2 = fe.add_artwork("snap")
art2.set_pos(flw * 0.52, flh * 0.03, flw * 0.46, flh * 0.97)
art2.preserve_aspect_ratio = true

local border1 = fe.add_rectangle(0, 0, 0, 0)
border1.outline = 5
border1.alpha = 0

local border2 = fe.add_rectangle(0, 0, 0, 0)
border2.outline = 5
border2.alpha = 0

/**
 * Move and size the target element to match the given source artwork
 * - Fits to artwork aspect ratio, as well as auto-sized images
 */
function match_size(src, tgt) {
    local aw = src.width.tofloat()
    local ah = src.height.tofloat()
    local tw = src.texture_width.tofloat()
    local th = src.texture_height.tofloat()
    local w = aw || tw
    local h = ah || th
    local aar = w / h
    local tar = (tw / th) * src.sample_aspect_ratio

    tgt.width = aw ? (tar < aar ? h * tar : w) : w
    tgt.height = ah ? (tar > aar ? w / tar : h) : h
    tgt.x = src.x + (w - tgt.width) * 0.5
    tgt.y = src.y + (h - tgt.height) * 0.5
}

fe.add_transition_callback(this, "on_transition")
function on_transition(ttype, var, ttime) {
    switch (ttype) {
        case Transition.ToNewList:
        case Transition.FromOldSelection:
            match_size(art1, border1)
            match_size(art2, border2)
            break
    }
}
