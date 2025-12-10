/**
 * Test keyboard, mouse, and joystick inputs
 *
 * @summary Test keyboard, mouse, and joystick inputs.
 * @version 1.0.0 2025-12-10
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * - Onscreen names are what you should use with `fe.get_input_state()` and `fe.get_input_pos()`
 * - The `System` key corresponds to the `Windows` or `Command` key
 * - All AM signals will be blocked except `Config`, `Reload Layout`, `Layout Options`, and `Back`
 * - These keys can still be tested but will fire their signal upon release
 *
 * NOTE
 * - AM may report different modifier keys depending on your keyboard/OS
 * - For example: A Logitech keyboard on macOS may return `Alt` instead than `System` (Command)
 */

local flw = fe.layout.width
local flh = fe.layout.height
local cols = 21
local rows = 13
local start_col = 0
local col = 0
local row = 0
local key_w = floor(flw / cols)
local key_h = floor(flh / rows)
local cs = key_w * 0.2
local inputs = []

local keyboard_inputs = [
    "Escape",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "F11",
    "F12",
    null, // Eject? (missing)
    null, // PrintScreen (missing)
    null, // ScrollLock (missing)
    "Pause",
    "F13",
    "F14",
    "F15",
    0,

    "Tilde",
    "Num1",
    "Num2",
    "Num3",
    "Num4",
    "Num5",
    "Num6",
    "Num7",
    "Num8",
    "Num9",
    "Num0",
    "Dash",
    "Equal",
    "Backspace",
    "Insert",
    "Home",
    "PageUp",
    null, // NumLock (missing)
    "Divide",
    "Multiply",
    "Subtract",
    0,

    "Tab",
    "Q",
    "W",
    "E",
    "R",
    "T",
    "Y",
    "U",
    "I",
    "O",
    "P",
    "LBracket",
    "RBracket",
    "Backslash",
    "Delete",
    "End",
    "PageDown",
    "Numpad7",
    "Numpad8",
    "Numpad9",
    "Add:1:2", // Colons:1:2 used for drawing, do not use with `get_input_state`
    0,

    "CapsLock",
    "A",
    "S",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L",
    "Semicolon",
    "Quote",
    "Return:2",
    null,
    null,
    null,
    "Numpad4",
    "Numpad5",
    "Numpad6",
    0,

    "Shift",
    "LShift",
    "Z",
    "X",
    "C",
    "V",
    "B",
    "N",
    "M",
    "Comma",
    "Period",
    "Slash",
    "RShift:2",
    null,
    "Up",
    null,
    "Numpad1",
    "Numpad2",
    "Numpad3",
    "Return:1:2", // Enter is same as Return
    0,

    "Control",
    "LControl",
    "System",
    "LSystem",
    "Alt",
    "LAlt",
    "Space:4",
    "RAlt",
    "RSystem",
    "Menu",
    "RControl",
    "Left",
    "Down",
    "Right",
    "Numpad0:2",
    null // Period (missing)
]

local joystick_inputs = [
    null,
    "Joy0 Up",
    null,
    null,
    null,
    "Joy0 PovYpos",
    null,
    null,
    null,
    "Joy0 Rneg",
    null,
    null,
    null,
    "Joy0 Vneg",
    0,

    "Joy0 Left",
    null,
    "Joy0 Right",
    null,
    "Joy0 PovXneg",
    null,
    "Joy0 PovXpos",
    null,
    "Joy0 Zneg",
    null,
    "Joy0 Zpos",
    null,
    "Joy0 Uneg",
    null,
    "Joy0 Upos",
    0,

    null,
    "Joy0 Down",
    null,
    null,
    null,
    "Joy0 PovYneg",
    null,
    null,
    null,
    "Joy0 Rpos",
    null,
    null,
    null,
    "Joy0 Vpos",
    0,
    0,

    "Joy0 Button0",
    "Joy0 Button1",
    "Joy0 Button2",
    "Joy0 Button3",
    "Joy0 Button4",
    "Joy0 Button5",
    "Joy0 Button6",
    "Joy0 Button7",
    0,

    "Joy0 Button8",
    "Joy0 Button9",
    "Joy0 Button10",
    "Joy0 Button11",
    "Joy0 Button12",
    "Joy0 Button13",
    "Joy0 Button14",
    "Joy0 Button15"
]

local mouse_inputs = [
    null,
    "Mouse Up",
    null,
    null,
    "Mouse WheelUp",
    0,

    "Mouse Left",
    null,
    "Mouse Right",
    null,
    "Mouse WheelDown",
    0,

    null,
    "Mouse Down",
    0,
    0,

    "Mouse LeftButton",
    "Mouse MiddleButton",
    "Mouse RightButton",
    "Mouse ExtraButton1",
    "Mouse ExtraButton2"
]

// Draw a single key
// - if key is null it skips a space
// - if key is 0 it starts a new row
function add_key(key) {
    local id = null
    local txt = null
    local w = 1
    local h = 1

    // new row
    if (key == 0) {
        col = start_col
        row++
        return
    }

    // wrap
    if (col >= cols) {
        col = start_col
        row++
    }

    // draw
    if (key) {
        local x = col * key_w
        local y = row * key_h
        local parts = split(key, ":")
        local label = ""
        if (parts.len() > 0) {
            id = parts[0]
            label = join(split(parts[0], " "), "\n")
            if (parts.len() > 1) w = parts[1].tointeger()
            if (parts.len() > 2) h = parts[2].tointeger()
            if (label != "") {
                txt = fe.add_text(label, x, y, w * key_w - 1, h * key_h - 1)
                txt.char_size = cs
                txt.word_wrap = true
                txt.margin = 0
            }
        }
    }

    // go to next cell
    col += w

    // return text element
    if (txt) {
        return {
            id = id,
            txt = txt,
            msg = txt.msg,
            pos = id.find("Mouse") != null || id.find("Joy") != null
        }
    }
}

// Draw a grid of keys
function draw_inputs(keys, c = 0, r = 0) {
    start_col = c
    col = c
    row = r
    foreach (key in keys) {
        local txt = add_key(key)
        if (txt) inputs.push(txt)
    }
}

// Draw the inputs
draw_inputs(keyboard_inputs)
draw_inputs(joystick_inputs, 0, 7)
draw_inputs(mouse_inputs, 16, 7)

// Update the active keys
fe.add_ticks_callback(this, "on_tick")
function on_tick(ttime) {
    foreach (input in inputs) {
        local id = input.id
        local txt = input.txt

        // Test state for all inputs
        if (fe.get_input_state(id)) {
            txt.set_bg_rgb(0, 128, 255)
        } else {
            txt.set_bg_rgb(50, 50, 50)
        }

        // Test position for some inputs
        if (input.pos) {
            local pos = fe.get_input_pos(id)
            txt.msg = pos != 0 ? input.msg + "\n" + pos : input.msg
        }
    }
}

// Only allow core signals
fe.add_signal_handler(this, "on_signal")
function on_signal(signal) {
    return (
        signal != "configure" &&
        signal != "reload_layout" &&
        signal != "layout_options" &&
        signal != "back"
    )
}
