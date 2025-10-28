/**
 * Experiment.Playground Layout
 *
 * @summary Test Artwork properties using a realtime editor.
 * @version 0.0.1 2025-10-28
 * @author Chadnaut
 * @url https://github.com/Chadnaut/Attract-Mode-Modules
 *
 * @requires
 * @artwork snap
 *
 * Overview
 * - Properties are stored in NV and will persist between sessions
 * - Presets can be used to store property sets for comparisons
 * - Should work on older AM+ versions
 *
 * Controls
 * - Home / End = Select a preset
 * - Up / Down = Select an option
 * - Next Page / Prev Page = Scroll by 10 options
 * - Left / Right / Select = Adjust an option
 * - Right-Click = Toggle zoom
 * - Hold Shift = Control pass-thru (ie: game select)
 *
 * Interface
 * - Yellow = Common settings
 * - Grey = Readonly or unavailable
 * - Red = Overridden by another property
 */

//--------------------------------------------------------------------------------------------------
// Helpers

min <- @(a, b) a < b ? a : b
max <- @(a, b) a > b ? a : b
round <- @(x) floor(x + 0.5)
is_number <- @(v) typeof v == "integer" || typeof v == "float"

range <- function (from, to, step, precision = 0.001) {
    local arr = []
    if (from == to || !step) return arr
    for (local i = from; i <= to; i += step) arr.push(round(i / precision) * precision)
    return arr
}

//--------------------------------------------------------------------------------------------------
// User-data

fe.layout.mouse_pointer = true
local nv = "playground"
if (!(nv in fe.nv)) fe.nv[nv] <- {}
// fe.nv[nv] <- {} // un-comment to reset NV data
local data = fe.nv[nv]
local data_default = {
    zoom_scale = 0,
    show_grid = true,
    show_frame = true,
    show_fit = true,
    show_anchors = true,
    prop_index = 0,
    preset = 0,
    presets = []
}
foreach (k, v in data) if (!(k in data_default)) delete data[k]
foreach (k, v in data_default) if (!(k in data)) data[k] <- v
while (data.presets.len() < 10) data.presets.push({})
local props = []
local inputs = []
local is_legacy = false

try {
    getconsttable().Fit
} catch (err) {
    is_legacy = true
}

//--------------------------------------------------------------------------------------------------
// Elements

local flw = fe.layout.width
local flh = fe.layout.height
local g_size = 100
local cw = 300
local opt_height = 24
local margin = 50
local root = fe.add_surface(flw, flh)
local zoom = fe.add_surface(g_size * 4, g_size * 4)

local container = root.add_surface(flw, flh)

local window = container.add_surface(flw, flh)
local overlay = container.add_surface(flw, flh)
local sidebar = container.add_surface(cw, floor((flh - margin * 2) / opt_height) * opt_height)
sidebar.set_pos(margin, margin)

local bg = window.add_rectangle(0, 0, flw, flh)
local info_top = window.add_text("", margin, margin, flw - margin * 2, flh - margin * 2)
local info_bottom = window.add_text("", margin, margin, flw - margin * 2, flh - margin * 2)
local art = window.add_artwork("snap", margin * 2 + cw + g_size, g_size * 2, g_size * 3, g_size * 4)
local grid = window.add_surface(g_size, g_size)

info_top.align = Align.TopRight

info_bottom.msg = "Up / Down = Select\nLeft / Right = Adjust\nRight-Click = Zoom"
info_bottom.align = Align.BottomRight
info_bottom.word_wrap = info_top.word_wrap = true
info_bottom.char_size = info_top.char_size = 20
info_bottom.alpha = info_top.alpha = 100
info_bottom.margin = info_top.margin = 0

bg.set_rgb(20, 20, 20)

local sidebar_inner = sidebar.add_surface(sidebar.width, flh * 2)
sidebar.alpha = 240

local scrollbar = sidebar.add_rectangle(cw, 0, 5, 0)
scrollbar.zorder = 1
scrollbar.anchor = Anchor.TopRight
scrollbar.alpha = 100

local grid_cell = grid.add_rectangle(0, 0, g_size + 2, g_size + 2)
grid_cell.alpha = 0
grid_cell.outline = -1
grid_cell.set_outline_rgb(255, 255, 255)
grid.set_pos(0, 0, window.width, window.height)
grid.subimg_width = window.width
grid.subimg_height = window.height
grid.repeat = true
grid.alpha = 50

for (local i = 0; i < flw; i += g_size) {
    local grid_label = window.add_text(i, i, 0, g_size, 30)
    grid_label.align = Align.MiddleLeft
    grid_label.alpha = grid.alpha
    grid_label.char_size = 15

    if (!i) continue
    local grid_label = window.add_text(i, 0, i, g_size, 30)
    grid_label.align = Align.MiddleLeft
    grid_label.alpha = grid.alpha
    grid_label.char_size = 15
}

local frame = overlay.add_rectangle(0, 0, 0, 0)
frame.outline = -1 // inside
frame.alpha = 0

local frame_fit = overlay.add_rectangle(0, 0, 0, 0)
frame_fit.outline = -1 // inside
frame_fit.set_outline_rgb(255, 0, 0)
frame_fit.alpha = 0

local anchor_rad = 9

local r = anchor_rad + 8
local rot_origin = overlay.add_rectangle(0, 0, r, r)
rot_origin.set_anchor(floor(r / 2) / r, floor(r / 2) / r)
rot_origin.set_rgb(255, 255, 0)

local r = anchor_rad + 4
local origin = overlay.add_rectangle(0, 0, r, r)
origin.set_anchor(floor(r / 2) / r, floor(r / 2) / r)
origin.set_rgb(0, 255, 255)

local r = anchor_rad
local anchor = overlay.add_rectangle(0, 0, r, r)
anchor.set_anchor(floor(r / 2) / r, floor(r / 2) / r)
anchor.set_rgb(255, 0, 0)

local r = anchor_rad - 4
local fit_anchor = overlay.add_rectangle(0, 0, r, r)
fit_anchor.set_anchor(floor(r / 2) / r, floor(r / 2) / r)
fit_anchor.set_rgb(0, 255, 0)

local zoom_mask = zoom.add_rectangle(0, 0, zoom.width, zoom.height)

local zoom_window = zoom.add_clone(container)
zoom_window.smooth = false
zoom_window.blend_mode = BlendMode.Multiply

local zoom_rect = zoom.add_rectangle(0, 0, zoom.width, zoom.height)
zoom_rect.alpha = 0
zoom_rect.outline = -1.5
zoom.anchor = Anchor.Centre

try {
    zoom_rect.corner_ratio = zoom_mask.corner_ratio = 0.5
    zoom_rect.corner_points = zoom_mask.corner_points = 32
} catch (err) {}

//--------------------------------------------------------------------------------------------------
// Exclusive Props

local mutually_exclusive_props = []

function add_mutually_exclusive_prop(a, b, overrides = false) {
    mutually_exclusive_props.push([a, b, overrides])
}

function refresh_mutually_exclusive_props(name) {
    foreach (exclusive in mutually_exclusive_props) {
        local a = exclusive[0]
        local b = exclusive[1]
        local overrides = exclusive[2]

        if (overrides) {
            if (a.find(name) != null) {
                // a locks b until cleared
                local valid = true
                foreach (n in b) {
                    local prop = get_prop_by_name(n)
                    prop.valid = true
                    prop.locked.clear()
                }
                foreach (n in a) {
                    if (get_value(n)) {
                        foreach (n2 in b) {
                            local prop = get_prop_by_name(n2)
                            prop.valid = false
                            prop.locked.push(n)
                        }
                    }
                }
                return
            }
        } else {
            if (a.find(name) != null) {
                // a overrides b when set
                foreach (n in a) get_prop_by_name(n).valid = true
                foreach (n in b) get_prop_by_name(n).valid = false
                return
            }
            if (b.find(name) != null) {
                // b overrides a when set
                foreach (n in b) get_prop_by_name(n).valid = true
                foreach (n in a) get_prop_by_name(n).valid = false
                return
            }
        }
    }
    get_prop_by_name(name).valid = true
}

//--------------------------------------------------------------------------------------------------
// Hacks

function set_hack(name) {
    if (!is_legacy) return
    if (name == "video_flags") {
        // reload legacy artwork when changing video_flags
        art.index_offset--
        art.index_offset++
    }
}

//--------------------------------------------------------------------------------------------------
// Artwork value

function get_value(name) {
    try {
        return art[name]
    } catch (err) {
        return name in data ? data[name] : null
    }
}

function set_value(name, value) {
    if (name in data_default) {
        data[name] = value
        return
    }
    try {
        art[name] = value
        set_hack(name)
        if (value != null) refresh_mutually_exclusive_props(name)
    } catch (err) {}
}

//--------------------------------------------------------------------------------------------------
// Presets

function save_preset() {
    local preset = data.presets[data.preset]
    foreach (prop in props) {
        if (prop.name in data_default) continue
        preset[prop.name] <- prop.valid ? get_value(prop.name) : null
    }
}

function load_preset() {
    local preset = data.presets[data.preset]
    foreach (prop in props) {
        if (prop.name in data_default) continue
        if (!(prop.name in preset)) continue
        set_value(prop.name, preset[prop.name])
    }
}

//--------------------------------------------------------------------------------------------------
// Props

function add_prop(name, options = [], func = null) {
    local i = props.len()
    local h = opt_height
    local x = 0
    local y = i * h
    local label = sidebar_inner.add_text("", x, y, sidebar.width, h)
    local value = sidebar_inner.add_text("", x, y, sidebar.width, h)
    label.char_size = value.char_size = h * 0.8
    label.align = Align.MiddleLeft
    value.align = Align.MiddleRight

    props.push({
        index = i,
        name = name,
        options = options,
        admin = func != null,
        func = func ? func : save_preset,
        label = label,
        value = value,
        valid = true,
        locked = []
    })
}

function get_prop_index(name) {
    foreach (i, prop in props) if (prop.name == name) return i
    return -1
}

function get_prop_by_name(name) {
    local i = get_prop_index(name)
    return i >= 0 ? props[i] : null
}

function get_prop_options(prop) {
    local opts = typeof prop.options == "function" ? prop.options() : prop.options

    local options = []
    if (typeof opts == "array") {
        foreach (v in opts) options.push({ label = v.tostring(), value = v })
    } else if (typeof opts == "table") {
        foreach (k, v in opts) options.push({ label = k.tostring(), value = v })
    }

    return options
}

function refresh_prop(prop) {
    local selected = prop.index == data.prop_index
    local val = get_value(prop.name)
    local unavailable = val == null
    local value = unavailable ? "" : val.tostring()
    local options = get_prop_options(prop)
    local readonly = !options.len()
    foreach (option in options) if (option.value == val) value = option.label

    local icon = is_legacy ? " -" : " 🏷"
    prop.label.msg = prop.name
    if (prop.locked.len()) prop.label.msg += icon + prop.locked.reduce(@(p, v) p + icon + v)
    prop.value.msg = value

    prop.label.alpha = unavailable || readonly ? 128 : 255
    prop.value.alpha = readonly ? 128 : 255

    if (prop.admin) prop.label.set_rgb(255, 255, 150)
    else if (!prop.valid && !unavailable) prop.label.set_rgb(255, 150, 150)
    else prop.label.set_rgb(255, 255, 255)

    if (selected) prop.label.set_bg_rgb(0, 100, 255)
    else if (prop.admin) prop.label.set_bg_rgb(70, 70, 50)
    else if (unavailable) prop.label.set_bg_rgb(40, 40, 40)
    else prop.label.set_bg_rgb(50, 50, 50)
}

//--------------------------------------------------------------------------------------------------
// Sidebar

function refresh_sidebar() {
    foreach (prop in props) refresh_prop(prop)

    local h = sidebar.height
    local top = data.prop_index * opt_height
    if (sidebar_inner.y + top <= 0) {
        sidebar_inner.y = -top
    } else if (sidebar_inner.y + top + opt_height >= h) {
        sidebar_inner.y = h - (top + opt_height)
    }

    local len = props.len()
    local sh = (h / opt_height / len) * h
    scrollbar.visible = h / opt_height < len
    scrollbar.height = sh
    scrollbar.y = (data.prop_index.tofloat() / (len - 1)) * (h - sh)
}

function inc_index(inc, repeat) {
    local n = props.len()
    local i = data.prop_index + inc
    data.prop_index <- repeat ? min(n - 1, max(0, i)) : (i + n) % n
}

function get_option_index(options, value) {
    local diff = null
    local closest = 0
    foreach (i, option in options) {
        if (is_number(option.value) && is_number(value)) {
            local next_diff = fabs(round(option.value * 10000) - round(value * 10000))
            if (next_diff == 0) return i
            if (diff == null || next_diff < diff) {
                diff = next_diff
                closest = i
            }
        }
        if (option.value == value) return i
    }
    return closest
}

function inc_option(index, inc) {
    local prop = props[index]
    local options = get_prop_options(prop)
    local n = options.len()
    if (!n) return
    local val = get_value(prop.name)
    local i = get_option_index(options, val)
    i = (i + inc + n) % n
    set_value(prop.name, options[i].value)
    prop.func()
}

//--------------------------------------------------------------------------------------------------
// Overlay

function refresh_overlay() {
    grid.visible = data.show_grid
    frame.visible = data.show_frame
    frame_fit.visible = data.show_fit

    overlay.rotation = art.rotation
    overlay.set_rotation_origin(
        (art.x + (art.rotation_origin_x - art.anchor_x) * art.width) / overlay.width,
        (art.y + (art.rotation_origin_y - art.anchor_y) * art.height) / overlay.height
    )

    frame.set_pos(art.x - art.origin_x, art.y - art.origin_y, art.width, art.height)
    frame.set_anchor(art.anchor_x, art.anchor_y)

    anchor.visible = data.show_anchors
    anchor.set_pos(art.x, art.y)

    origin.visible = data.show_anchors
    origin.set_pos(art.x - art.anchor_x * art.width, art.y - art.anchor_y * art.height)

    rot_origin.visible = data.show_anchors
    rot_origin.set_pos(
        art.x + (art.rotation_origin_x - art.anchor_x) * art.width,
        art.y + (art.rotation_origin_y - art.anchor_y) * art.height
    )

    try {
        frame_fit.set_pos(art.x + art.fit_x, art.y + art.fit_y, art.fit_width, art.fit_height)

        fit_anchor.visible = data.show_anchors
        fit_anchor.set_pos(
            art.x + (art.fit_anchor_x - art.anchor_x) * art.width - art.origin_x,
            art.y + (art.fit_anchor_y - art.anchor_y) * art.height - art.origin_y
        )
    } catch (err) {}
}

//--------------------------------------------------------------------------------------------------
// Info

function refresh_info() {
    info_top.msg = format(
        "[Title]\n%s\n%d x %d @ %.3f\n%d of %d",
        art.file_name != "" ? art.file_name : "<none>",
        art.texture_width,
        art.texture_height,
        art.sample_aspect_ratio,
        art.video_time,
        art.video_duration
    )
}

//--------------------------------------------------------------------------------------------------
// Inputs

function is_shifted() {
    return fe.get_input_state("LShift") || fe.get_input_state("RShift")
}

function add_input(signal, callback) {
    inputs.push({ signal = signal, callback = callback })
}

function refresh_inputs() {
    if (is_shifted()) return
    local now = clock()
    foreach (input in inputs) {
        local next_state = fe.get_input_state(input.signal)
        local last_state = "state" in input ? input.state : false
        input.state <- next_state

        if (next_state && next_state != last_state) {
            input.time <- now
            input.repeat <- 0.4
            input.callback(false)
        }

        if (next_state && now - input.time >= input.repeat) {
            input.time <- now
            input.repeat <- 0.04
            input.callback(true)
        }
    }
}

//--------------------------------------------------------------------------------------------------
// Zoom

function refresh_zoom() {
    zoom.visible = !!data.zoom_scale
    if (!zoom.visible) return
    local x = fe.get_input_pos("Mouse Left")
    local y = fe.get_input_pos("Mouse Top")
    zoom.set_pos(x, y)
    zoom_window.set_pos(
        -x * data.zoom_scale + zoom.width * 0.5,
        -y * data.zoom_scale + zoom.height * 0.5,
        zoom_window.texture_width * data.zoom_scale,
        zoom_window.texture_height * data.zoom_scale
    )
}

//--------------------------------------------------------------------------------------------------
// Events

local tick = 0
fe.add_ticks_callback(this, "on_tick")
function on_tick(ttime) {
    refresh_inputs()
    refresh_overlay()
    refresh_info()
    refresh_sidebar()
    refresh_zoom()
}

fe.add_signal_handler(this, "on_signal")
function on_signal(signal) {
    if (is_shifted()) return false
    foreach (input in inputs) if (signal == input.signal) return true
    return false
}

//--------------------------------------------------------------------------------------------------
// Setup

local ct = getconsttable()
local bool_options = is_legacy
    ? { ["NO"] = false, ["YES"] = true }
    : { ["☐"] = false, ["☒"] = true }
local blend_options = ct.BlendMode
local vid_options = ct.Vid
local fit_options = []
try {
    fit_options = ct.Fit
} catch (err) {}

add_input("up", @(rep) inc_index(-1, rep))
add_input("down", @(rep) inc_index(1, rep))
add_input("prev_page", @(rep) inc_index(-10, rep))
add_input("next_page", @(rep) inc_index(10, rep))
add_input("Home", @(rep) inc_option(get_prop_index("preset"), -1))
add_input("End", @(rep) inc_option(get_prop_index("preset"), 1))
add_input("left", @(rep) inc_option(data.prop_index, -1))
add_input("right", @(rep) inc_option(data.prop_index, 1))
add_input("select", @(rep) inc_option(data.prop_index, 1))
add_input("Mouse RightButton", @(rep) inc_option(get_prop_index("zoom_scale"), 1))

add_mutually_exclusive_prop(["auto_width"], ["width"], true)
add_mutually_exclusive_prop(["auto_height"], ["height"], true)
add_mutually_exclusive_prop(["transform_origin_x"], ["anchor_x", "rotation_origin_x"])
add_mutually_exclusive_prop(["transform_origin_y"], ["anchor_y", "rotation_origin_y"])
add_mutually_exclusive_prop(
    ["border_left", "border_right", "border_top", "border_bottom"],
    ["pinch_x", "pinch_y", "fit", "crop"],
    true
)

add_prop("show_grid", bool_options, @() true)
add_prop("show_frame", bool_options, @() true)
add_prop("show_fit", bool_options, @() true)
add_prop("show_anchors", bool_options, @() true)
add_prop("zoom_scale", [0, 4, 8], @() true)
add_prop("preset", range(0, data.presets.len() - 1, 1), load_preset)

add_prop("x", range(0, 1000, 50))
add_prop("y", range(0, 1000, 50))
add_prop("width", range(-1000, 1000, 25))
add_prop("height", range(-1000, 1000, 25))
add_prop("rotation", range(0, 345, 15))
add_prop("origin_x", range(-200, 200, 25))
add_prop("origin_y", range(-200, 200, 25))
add_prop("transform_origin_x", range(-1.0, 2.0, 0.1))
add_prop("transform_origin_y", range(-1.0, 2.0, 0.1))
add_prop("anchor_x", range(-1.0, 2.0, 0.1))
add_prop("anchor_y", range(-1.0, 2.0, 0.1))
add_prop("rotation_origin_x", range(-1.0, 2.0, 0.1))
add_prop("rotation_origin_y", range(-1.0, 2.0, 0.1))
add_prop("auto_width", bool_options)
add_prop("auto_height", bool_options)
add_prop("preserve_aspect_ratio", bool_options)
add_prop("force_aspect_ratio", [0, 0.75, 1.0, 1.333])
add_prop("fit_anchor_x", range(-1.0, 2.0, 0.1))
add_prop("fit_anchor_y", range(-1.0, 2.0, 0.1))
add_prop("fit", fit_options)
add_prop("crop", bool_options)
add_prop("smooth", bool_options)
add_prop("mipmap", bool_options)
add_prop("repeat", bool_options)
add_prop("subimg_x", @() range(-art.texture_width, art.texture_width, art.texture_width / 8))
add_prop("subimg_y", @() range(-art.texture_height, art.texture_height, art.texture_height / 8))
add_prop("subimg_width", @() range(0, art.texture_width * 4, art.texture_width / 4))
add_prop("subimg_height", @() range(0, art.texture_height * 4, art.texture_height / 4))
add_prop("pinch_x", range(-100, 100, 10))
add_prop("pinch_y", range(-100, 100, 10))
add_prop("skew_x", range(-100, 100, 10))
add_prop("skew_y", range(-100, 100, 10))
add_prop("border_scale", range(0.0, 2.0, 0.1))
add_prop("border_left", range(0, 200, 25))
add_prop("border_top", range(0, 200, 25))
add_prop("border_right", range(0, 200, 25))
add_prop("border_bottom", range(0, 200, 25))
add_prop("padding_left", range(-100, 100, 25))
add_prop("padding_top", range(-100, 100, 25))
add_prop("padding_right", range(-100, 100, 25))
add_prop("padding_bottom", range(-100, 100, 25))
add_prop("index_offset", range(-10, 10, 1))
add_prop("filter_offset", range(-10, 10, 1))
add_prop("visible", bool_options)
add_prop("blend_mode", blend_options)
add_prop("red", range(0, 255, 15))
add_prop("green", range(0, 255, 15))
add_prop("blue", range(0, 255, 15))
add_prop("alpha", range(0, 255, 15))
add_prop("volume", range(0, 100, 10))
add_prop("video_flags", vid_options)
add_prop("video_playing", bool_options)

load_preset()
