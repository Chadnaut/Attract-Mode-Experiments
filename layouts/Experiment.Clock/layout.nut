/**
 * Experiment.Clock Layout
 *
 * @summary A realtime animated clock.
 * @version 0.0.1 2025-03-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

// -------------------------------------------------------------------------------------

// NOTE:
// - the `date` method does not return milliseconds
// - we `zero` the ms when the `sec` property changes
// - this causes the second hand to *jump* when it first occurs
local smooth = true // move all hands smoothly between intervals

// -------------------------------------------------------------------------------------

local flw = fe.layout.width
local flh = fe.layout.height

local cx = flw * 0.5
local cy = flh * 0.5
local sy = (flw < flh ? flw : flh) * 0.5 // max hand length
local sx = sy * 0.02 // hand width

local h = fe.add_rectangle(cx, cy, sx, sy * 0.5)
local m = fe.add_rectangle(cx, cy, sx, sy * 0.8)
local s = fe.add_rectangle(cx, cy, sx, sy * 1.0)

h.set_rgb(150, 150, 150)
m.set_rgb(200, 200, 200)
s.set_rgb(255, 0, 0)

h.set_anchor(0.5, 0.9)
m.set_anchor(0.5, 0.9)
s.set_anchor(0.5, 0.9)

h.set_rotation_origin(0.5, 0.9)
m.set_rotation_origin(0.5, 0.9)
s.set_rotation_origin(0.5, 0.9)

local off = 0
local sec = 0

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    local time = date()
    if (sec != time.sec) {
        sec = time.sec
        off = -ttime
    }
    s.rotation = time.sec * 6.0 + (smooth ? ((ttime + off) / 1000.0) * 6.0 : 0)
    m.rotation = time.min * 6.0 + (smooth ? s.rotation / 60.0 : 0)
    h.rotation = (time.hour % 12) * 30.0 + (smooth ? m.rotation / 12.0 : 0)
}
