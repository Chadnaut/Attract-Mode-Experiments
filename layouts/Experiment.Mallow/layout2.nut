/**
 * Experiment.Mallow Layout2
 *
 * @summary More happy little marshmallows!
 * @version 0.0.1 2025-04-02
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

local flw = fe.layout.width
local flh = fe.layout.height
local xn = 9
local yn = 9
local w = flw / (xn + 4)
local h = flh / (yn + 4)
local d = 60

function add(x, y) {
    local r = fe.add_rectangle(x, y + h / 2, w, h)
    r.anchor = Anchor.Bottom
    r.corner_ratio_x = 0.2
    r.corner_ratio_y = 0.5
    local e1 = fe.add_rectangle(x, y + h / 2, w / 10, h / 10)
    e1.anchor_x = 2.0
    e1.anchor_y = 8.0
    e1.corner_ratio = 0.5
    e1.set_rgb(0, 0, 0)
    local e2 = fe.add_rectangle(x, y + h / 2, w / 10, h / 10)
    e2.anchor_x = -1.0
    e2.anchor_y = 8.0
    e2.corner_ratio = 0.5
    e2.set_rgb(0, 0, 0)
    return { r = r, e1 = e1, e2 = e2 }
}

function update(rect, t) {
    local n = sin(t * 0.01) * 0.5 + 0.5
    local n2 = sin((t - 50) * 0.01) * 0.5 + 0.5
    local r = rect.r
    local e1 = rect.e1
    local e2 = rect.e2
    r.height = ((1.0 + n) * h) / 2
    r.width = ((3 - n) * h) / 2
    r.corner_ratio_x = 0.2 * (1.0 - n)
    r.green = n * 255
    r.blue = n2 * 255
    e1.anchor_y = e2.anchor_y = 3.0 + n2 * 4.0
    e1.anchor_x = 3.0 - n2 * 0.5
    e2.anchor_x = -2.0 + n2 * 0.5
}

local r = []
for (local y = 0; y < yn; y++) {
    for (local x = 0; x < xn; x++) {
        r.push(add((flw * (x + 1)) / (xn + 1), (flh * (y + 1)) / (yn + 1)))
    }
}

fe.add_ticks_callback("on_tick")
function on_tick(ttime) {
    foreach (i, rect in r) {
        update(rect, ttime + i * d)
    }
}
