/**
 * Experiment.Pitcher Layout
 *
 * @summary Demo showing sound pitch and volume effects.
 * @version 0.0.1 2025-04-08
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Experiments
 */

local flw = fe.layout.width
local flh = fe.layout.height

local tone = "tone.wav"
local pitchStart = 0.5
local pitchEnd = 1.0
local keys = [
    ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
    ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
    ["Z", "X", "C", "V", "B", "N", "M"]
]

class Bar {
    _key = ""
    _bar = 0
    value = 0
    pressed = false
    sound = null
    rect = null

    constructor(key, filename, pitch, x, y, w, h) {
        _key = key
        _bar = h - w
        local txt = fe.add_text(key, x, y + _bar, w, w)
        txt.char_size = w * 0.5
        rect = fe.add_rectangle(x + 1, y + _bar, w - 2, _bar)
        rect.anchor = Anchor.BottomLeft
        rect.set_rgb(255, 0, 0)
        sound = fe.add_sound(filename)
        sound.loop = true
        sound.pitch = pitch
    }

    function getState() {
        local next = fe.get_input_state(_key)
        local restart = next && !pressed
        pressed = next

        if (value > 0.0) value -= 0.01
        if (value < 0.0) value = 0.0
        if (pressed) value = 1.0

        if (restart) sound.playing = true
        sound.volume = value * 100
        if (sound.playing && !value) sound.playing = false

        rect.height = value * _bar
        rect.red = 127 + value * 128
        return pressed
    }
}

local m = keys[0].len()
local w = flw / m
local h = flh / keys.len()
local bars = []
local total = 0
foreach (row in keys) total += row.len()

local i = 0.0
foreach (y, row in keys) {
    local n = row.len()
    local b = (m - n) * 0.5 * w
    foreach (x, key in row) {
        local p = pitchStart + (i++ / total) * (pitchEnd - pitchStart)
        bars.push(Bar(key, tone, p, x * w + b, y * h, w, h))
    }
}

local pressed = 0
fe.add_ticks_callback(this, "on_tick")
function on_tick(ttime) {
    if (pressed) pressed--
    foreach (bar in bars) if (bar.getState()) pressed = 30
}

fe.add_signal_handler(this, "on_signal")
function on_signal(signal) {
    if (pressed) return true
}
