class Chart {
    /** @type {feSurface} */
    surf = null
    /** @type {feText} */
    label = null
    bd = null
    bw = 0.0
    bh = 0.0
    sw = 0.0
    sh = 0.0
    ps = 5
    rgb = null
    inc = 1

    constructor(x, y, w, h) {
        surf = fe.add_surface(x, y, w, h)
        local bg = surf.add_rectangle(0, 0, w, h)
        bg.alpha = 20
        label = surf.add_text("", 0, h - 25, w, 19)
        label.align = Align.MiddleRight
        label.alpha = 100
        set_bounds(0, 0, 100, 100)
        set_col(255, 255, 255)
    }

    function set_bounds(left, top, right, bottom) {
        bd = { left = left, top = top, right = right, bottom = bottom }
        bw = bd.right - bd.left
        bh = bd.bottom - bd.top
        sw = surf.width.tofloat() / bw
        sh = surf.height.tofloat() / bh
    }

    function gx(x) {
        return (x - bd.left) * sw
    }

    function gy(y) {
        return (y - bd.top) * sh
    }

    function gw(w) {
        return w * sw
    }

    function gh(h) {
        return h * sh
    }

    function draw_rect(x, y, w, h) {
        local r = surf.add_rectangle(gx(x), gy(y), gw(w), gh(h))
        return r
    }

    function draw_point(x, y) {
        local r = surf.add_rectangle(gx(x), gy(y), ps, ps)
        r.set_anchor(floor(ps / 2) / ps, floor(ps / 2) / ps)
        r.set_rgb(rgb[0], rgb[1], rgb[2])
        r.alpha = rgb[3]
        r.blend_mode = BlendMode.Add
        return r
    }

    function draw_text(msg, x, y, w, h) {
        local t = surf.add_text(msg, gx(x), gy(y), gw(w), gh(h))
        t.align = Align.TopLeft
        return t
    }

    function set_grid(w, h, units = true) {
        local x0 = min(bd.left, bd.right)
        local x1 = max(bd.left, bd.right)
        local y0 = min(bd.top, bd.bottom)
        local y1 = max(bd.top, bd.bottom)
        local precision = w < 1.0 ? "%.2f" : "%d"

        for (local x = x0 - (x0 % w); x <= x1 + (x1 % w); x += w) {
            local r = draw_rect(x, bd.top, 1 / sw, bh)
            r.alpha = 20
            if (units) {
                local t = draw_text(format(precision, x), x, 0, 100 / sw, 18 / sh)
                t.alpha = 50
            }
        }

        for (local y = y0 - (y0 % h); y <= y1 + (y1 % h); y += h) {
            local r = draw_rect(bd.left, y, bw, 1 / sh)
            r.alpha = 20
            if (y == 0) continue
            if (units) {
                local t = draw_text(format(precision, y), 0, y, 100 / sw, 18 / sh)
                t.alpha = 50
            }
        }

        local r = draw_rect(bd.left, 0, bw, 1 / sh)
        r.alpha = 30
        local r = draw_rect(0, bd.top, 1 / sw, bh)
        r.alpha = 30
    }

    function set_point_size(s) {
        ps = s
    }

    function set_col(r, g, b, a = 255) {
        rgb = [r, g, b, a]
    }

    function set_inc(inc) {
        this.inc = inc
    }

    function set_label(msg) {
        label.msg = msg
    }

    function plot(func) {
        // ensure we hit zero exactly
        local xn = bw / inc
        for (local i = 0; i <= xn; i++) {
            local x = bd.left + i * inc
            local y = func(x)
            // fe.log(x + " = " + y)
            draw_point(x, y)
        }
    }
}

// -------------------------------------------------------------------------------------

local chart_x = 0
local chart_y = 0
local chart_opt = {
    pad = 10,
    bounds = [0, 10, 10, 0],
    grid = [1, 1],
    grid_label = true,
    col = [0, 255, 0],
    inc = 0.01
}

function init_chart(opt) {
    chart_x = 0
    chart_y = 0
    foreach (k,v in opt) chart_opt[k] <- v
}

function add_chart(label, func = null, opt = null) {
    if (opt == null) opt = {};
    foreach (k, v in chart_opt) if (!(k in opt)) opt[k] <- chart_opt[k]

    local c = Chart(
        opt.pad + chart_x * (opt.width + opt.pad),
        opt.pad + chart_y * (opt.height + opt.pad),
        opt.width,
        opt.height
    )

    chart_x++
    if (opt.pad + (chart_x+1) * (opt.width + opt.pad) > fe.layout.width) add_row();

    // c.set_bounds(0, 1 + over, 1, 0 - over)
    c.set_bounds(opt.bounds[0],opt.bounds[1],opt.bounds[2],opt.bounds[3])
    c.set_grid(opt.grid[0], opt.grid[1], opt.grid_label)
    c.set_inc(opt.inc)
    c.set_point_size(3)
    c.set_label(label)
    c.set_col(opt.col[0], opt.col[1], opt.col[2])
    try {
        if (func) c.plot(func)
    } catch (err) {}
    return c
}

function add_row() {
    chart_x = 0
    chart_y++
}
