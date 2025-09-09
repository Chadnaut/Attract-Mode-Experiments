/**
 * Experiment.Segmental Layout
 *
 * @summary A Clock made with Rectangle segments.
 * @version 0.0.1 2025-09-09
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 *
 * Not recommended for production
 * This uses a LOT of rectangles for a very simple effect
 * Probably better to use image sprites
 */

tween <- @(a, b, p) a * (1.0 - p) + b * p
random <- @() rand() / RAND_MAX.tofloat()

class Segment {
    rect = null
    width = 0.0
    state = false

    constructor(target, x, y, w, h, r, g) {
        rect = target.add_rectangle(x, y, w - g * 2.0, h - g * 2.0)
        rect.anchor = Anchor.Centre
        rect.rotation_origin = Origin.Centre
        rect.rotation = r
        rect.corner_radius = w / 2.0
        rect.corner_points = 2
        width = w - g * 2.0
    }

    function draw() {
        rect.width = state
            ? tween(rect.width, width, 0.125)
            : tween(rect.width, 0, 0.25)
    }
}

class Colon {
    segments = null

    constructor(target, x, y, w, h, s, g) {
        segments = [
            Segment(target, x + w * 0.5, y + h * 0.25 + s * 0.25, s, s, 0, g),
            Segment(target, x + w * 0.5, y + h * 0.75 - s * 0.25, s, s, 0, g)
        ]
    }

    function update(state) {
        foreach (i, s in segments) s.state = state
    }

    function draw() {
        foreach (s in segments) s.draw()
    }
}

class Digit {
    segments = null
    patterns = [
        [1, 0, 1, 1, 1, 1, 1], // 0
        [0, 0, 0, 0, 0, 1, 1], // 1
        [1, 1, 1, 0, 1, 1, 0], // 2
        [1, 1, 1, 0, 0, 1, 1], // 3
        [0, 1, 0, 1, 0, 1, 1], // 4
        [1, 1, 1, 1, 0, 0, 1], // 5
        [1, 1, 1, 1, 1, 0, 1], // 6
        [1, 0, 0, 0, 0, 1, 1], // 7
        [1, 1, 1, 1, 1, 1, 1], // 8
        [1, 1, 1, 1, 0, 1, 1] // 9
    ]

    constructor(target, x, y, w, h, s, g) {
        local sx = [s * 0.5, w * 0.5, w - s * 0.5]
        local sy = [s * 0.5, (h + s) * 0.25, h * 0.5, h * 0.75 - s * 0.25, h - s * 0.5]
        local sh = [w - s, (h - s) * 0.5]
        segments = [
            Segment(target, x + sx[1], y + sy[0], s, sh[0], 90, g), // top
            Segment(target, x + sx[1], y + sy[2], s, sh[0], 90, g), // mid
            Segment(target, x + sx[1], y + sy[4], s, sh[0], 90, g), // bottom
            Segment(target, x + sx[0], y + sy[1], s, sh[1], 0, g), // tl
            Segment(target, x + sx[0], y + sy[3], s, sh[1], 0, g), // bl
            Segment(target, x + sx[2], y + sy[1], s, sh[1], 0, g), // tr
            Segment(target, x + sx[2], y + sy[3], s, sh[1], 0, g) // br
        ]
    }

    function update(p) {
        foreach (i, s in segments) s.state = patterns[p][i]
    }

    function draw() {
        foreach (s in segments) s.draw()
    }
}

class Clock {
    surf = null
    chars = null

    constructor(target, x, y, w, h, s, g) {
        surf = target.add_surface(x, y, w, h)
        local padW = s / w
        local colonW = padW * 5.0
        local digitW = colonW * 3.0
        local totalW = digitW * 6.0 + colonW * 2.0 + padW * 7.0

        local dw = floor((w / totalW) * digitW)
        local cw = floor((w / totalW) * colonW)
        local dx = floor((w / totalW) * (digitW + padW))
        local cx = floor((w / totalW) * (colonW + padW))
        local xp = 0

        chars = [
            Digit(surf, xp, 0, dw, h, s, g),
            Digit(surf, (xp += dx), 0, dw, h, s, g),
            Colon(surf, (xp += dx), 0, cw, h, s, g),
            Digit(surf, (xp += cx), 0, dw, h, s, g),
            Digit(surf, (xp += dx), 0, dw, h, s, g),
            Colon(surf, (xp += dx), 0, cw, h, s, g),
            Digit(surf, (xp += cx), 0, dw, h, s, g),
            Digit(surf, (xp += dx), 0, dw, h, s, g)
        ]
    }

    function update(value) {
        foreach (i, c in chars) c.update(value[i])
    }

    function draw() {
        foreach (i, c in chars) c.draw()
    }
}

local w = fe.layout.width
local h = fe.layout.height

// Usage: Clock(surf, x, y, width, height, thickness, gap)
local clock1 = Clock(fe, w * 0.5, h * 0.25, w * 0.7, h * 0.2, h * 0.035, h * 0.005)
clock1.surf.anchor = Anchor.Centre
clock1.surf.set_rgb(255, 0, 0)
clock1.surf.skew_x = clock1.surf.height * -0.1
clock1.surf.x += clock1.surf.skew_x * -0.5

local clock2 = Clock(fe, w * 0.5, h * 0.5, w * 0.7, h * 0.2, h * 0.015, h * 0.00)
clock2.surf.anchor = Anchor.Centre
clock2.surf.set_rgb(0, 255, 0)
clock2.surf.skew_x = clock2.surf.height * -0.1
clock2.surf.x += clock2.surf.skew_x * -0.5

local clock3 = Clock(fe, w * 0.5, h * 0.75, w * 0.7, h * 0.2, h * 0.055, h * 0.002)
clock3.surf.anchor = Anchor.Centre
clock3.surf.set_rgb(255, 255, 0)
clock3.surf.skew_x = clock3.surf.height * -0.1
clock3.surf.x += clock3.surf.skew_x * -0.5

local prev
fe.add_ticks_callback(this, "on_tick")
function on_tick(ttime) {
    local d = date()
    local h = d.hour % 12
    local m = d.min
    local s = d.sec
    local next = h + ":" + m + ":" + s
    if (prev != next) {
        prev = next
        local t = [h / 10, h % 10, true, m / 10, m % 10, true, s / 10, s % 10]

        // Force the clock to show a specific value
        // t = [0, 1, true, 2, 3, true, 4, 5]

        // Show random values instead
        // if (ttime < 3000) {
        //     local r = @() random() * 9
        //     t = [r(), r(), true, r(), r(), true, r(), r()]
        // }

        clock1.update(t)
        clock2.update(t)
        clock3.update(t)
    }
    clock1.draw()
    clock2.draw()
    clock3.draw()
}
