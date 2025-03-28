/**
 * Ultra Sweep Example
 *
 * @summary Zero asset light sweep effect.
 * @version 0.0.1 2025-03-21
 * @author Chadnaut
 */

local flw = fe.layout.width
local flh = fe.layout.height

// Surface element holds Artwork and Gloss
local surf = fe.add_surface(flw * 0.75, flh * 0.75)
surf.anchor = Anchor.Centre
surf.set_pos(flw * 0.5, flh * 0.5)

// Artwork, uses a snap for this example
local art = surf.add_artwork("snap", 0, 0, surf.width, surf.height)
art.video_flags = Vid.ImagesOnly
art.preserve_aspect_ratio = true
art.file_name = art.file_name

// This Layer gets resized to match the Artwork so the gloss aligns
local layer = surf.add_surface(surf.width, surf.height)
layer.blend_mode = BlendMode.Add
layer.alpha = 150
layer.anchor = Anchor.Centre
layer.set_pos(surf.width * 0.5, surf.height * 0.5, art.width, art.height)

// The gloss element, uses a surface for this example - could be another image
local gloss = layer.add_surface(layer.width, layer.height)
local skew = layer.width * -0.25
local rect = gloss.add_rectangle(-skew, 0, gloss.width + skew, gloss.height)
gloss.skew_x = skew

// Animate the gloss element
fe.add_ticks_callback(this, "on_tick")
function on_tick(ttime) {
    local n = (ttime / 800.0) % 2.0
    gloss.x = -gloss.width + (layer.width + gloss.width) * n
}

// Resize layer holding gloss to match artwork
fe.add_transition_callback(this, "on_transition")
function on_transition(ttype, var, ttime) {
    switch (ttype) {
        case Transition.ToNewList:
        case Transition.FromOldSelection:
            local sr = surf.width / surf.height.tofloat()
            local ar = art.texture_width / art.texture_height.tofloat()
            local wr = ar > sr
            layer.width = wr ? surf.width : surf.height * ar
            layer.height = wr ? surf.width / ar : surf.height
            break
    }
}
