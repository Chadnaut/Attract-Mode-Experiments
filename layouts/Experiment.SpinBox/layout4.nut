/**
 * Experiment.SpinBox Layout4
 *
 * @summary A fake 3D spinning box, controlled with the keyboard.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * @requires
 * @artwork snap
 * @module perspective 0.6.0 https://github.com/Chadnaut/Attract-Mode-Modules
 */

fe.load_module("perspective")

fe.layout.mouse_pointer = true;
local flw = fe.layout.width
local flh = fe.layout.height
local cx = flw * 0.5
local cy = flh * 0.5
local m = flw < flh ? flw : flh

local art1 = Perspective(fe.add_artwork("snap", cx, cy, 0.1, 0.1))
local art2 = Perspective(fe.add_artwork("snap", cx, cy, 0.1, 0.1))
local art3 = Perspective(fe.add_artwork("snap", cx, cy, 0.1, 0.1))
local art4 = Perspective(fe.add_artwork("snap", cx, cy, 0.1, 0.1))

art1.index_offset = 0
art2.index_offset = 1
art3.index_offset = 2
art4.index_offset = 3

local speed = 1.0 // spin speed
local w = m * 0.35 // width
local h = m * 0.35 // height
local a = 40 // *angle*, must be > 0

local t = -1 // -1.0...1.0 = top amount
local b = 1 // -1.0...1.0 = bottom amount
local f = 1 // 1 or -1 = flip images
local n = 0 // 0.0...0.5 flatness

fe.add_signal_handler(this, "on_signal");
function on_signal(signal) {
    switch (signal) {
        case "up":
        case "down":
        case "left":
        case "right":
            // prevent these keys doing normal AM actions
            return true;
    }
    return false;
}

local mx = 0
local my = h

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    if (fe.get_input_state("Up")) my += -10.0;
    if (fe.get_input_state("Down")) my += 10.0;
    if (fe.get_input_state("Left")) mx += -10.0;
    if (fe.get_input_state("Right")) mx += 10.0;

    local r = (mx / flw) * -2.0 * PI
    local t = (my / flh) * 10.0 - 5.0
    local b = t

    local r1 = r - f * PI * (0.0 - n)
    local r2 = r - f * PI * (0.5 + n)
    local r3 = r - f * PI * (1.0 - n)
    local r4 = r - f * PI * (1.5 + n)

    local x1 = cos(r1) * w
    local x2 = cos(r2) * w
    local x3 = cos(r3) * w
    local x4 = cos(r4) * w

    local y1t = sin(r1) * a * t - h
    local y2t = sin(r2) * a * t - h
    local y3t = sin(r3) * a * t - h
    local y4t = sin(r4) * a * t - h

    local y1b = sin(r1) * a * b + h
    local y2b = sin(r2) * a * b + h
    local y3b = sin(r3) * a * b + h
    local y4b = sin(r4) * a * b + h

    art1.set_offset(x1, y1t, x2, y2t, x1, y1b, x2, y2b)
    art2.set_offset(x2, y2t, x3, y3t, x2, y2b, x3, y3b)
    art3.set_offset(x3, y3t, x4, y4t, x3, y3b, x4, y4b)
    art4.set_offset(x4, y4t, x1, y1t, x4, y4b, x1, y1b)

    art1.zorder = (b > 0.0 ? y1b + y2b : -(y1b + y2b)) / 2
    art2.zorder = (b > 0.0 ? y2b + y3b : -(y2b + y3b)) / 2
    art3.zorder = (b > 0.0 ? y3b + y4b : -(y3b + y4b)) / 2
    art4.zorder = (b > 0.0 ? y4b + y1b : -(y4b + y1b)) / 2
}
