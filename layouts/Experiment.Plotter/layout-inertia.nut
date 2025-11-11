fe.load_module("inertia")
fe.do_nut("util.nut")

InertiaClass.Initialize()

init_chart({
    width = 220,
    height = 484,
    bounds = [0, 1.6, 1, -0.6],
    inc = 0.001,
    grid = [0.2, 0.2],
    grid_label = false
})

local c = add_chart("Linear", @(x) ease.linear(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Linear | InertiaClass.Mode.Out }, x))

local c = add_chart("Cubic", @(x) ease.out_cubic(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Cubic | InertiaClass.Mode.Out }, x))

local c = add_chart("Quad", @(x) ease.out_quad(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Quad | InertiaClass.Mode.Out }, x))

local c = add_chart("Quart", @(x) ease.out_quart(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Quart | InertiaClass.Mode.Out }, x))

local c = add_chart("Quint", @(x) ease.out_quint(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Quint | InertiaClass.Mode.Out }, x))

local c = add_chart("Sine", @(x) ease.out_sine(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Sine | InertiaClass.Mode.Out }, x))

local c = add_chart("HalfSine", @(x) ease.in_out_sine(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(
    @(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.HalfSine | InertiaClass.Mode.Out }, x)
)

local c = add_chart("Expo", @(x) ease.out_expo2(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Expo | InertiaClass.Mode.Out }, x))

local c = add_chart("Circle", @(x) ease.out_circ(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Circle | InertiaClass.Mode.Out }, x))

local time = 1.0
local tail = 3.0
local c = add_chart("Elastic", @(x) ease.out_elastic2(x, 0, 1, 1, 1.0 / (tail / time)))
c.set_col(200, 0, 0)
c.plot(
    @(x)
        1 - InertiaClass.Tween(
                {
                    mode = InertiaClass.Mode.Elastic | InertiaClass.Mode.Out,
                    time = time,
                    tail = tail
                },
                x * (1.0 + tail / time)
            )
)

local c = add_chart("Back", @(x) ease.out_back2(x, 0, 1, 1))
c.set_col(200, 0, 0)
c.plot(@(x) 1 - InertiaClass.Tween({ mode = InertiaClass.Mode.Back | InertiaClass.Mode.Out }, x))

local time = 1.0
local tail = 2.0
local c = add_chart("Bounce", @(x) ease.out_bounce2(x, 0.0, 1.0, 1.0, 1.0/(tail/time)))
c.set_col(200, 0, 0)
c.plot(
    @(x)
        1 -
            InertiaClass.Tween(
                {
                    mode = InertiaClass.Mode.Bounce | InertiaClass.Mode.Out,
                    timer = time,
                    tail = tail,
                    time = time,
                },
                x*(1.0 + tail / time)
            )
)

local c = add_chart("FullSine")
c.set_col(200, 0, 0)
c.plot(
    @(x)
        1 -
            InertiaClass.Tween(
                { mode = InertiaClass.Mode.FullSine | InertiaClass.Mode.Out, phase = 0 },
                x
            )
)

local c = add_chart("CircleX")
c.set_col(200, 0, 0)
c.plot(
    @(x)
        InertiaClass.Tween(
            { mode = InertiaClass.Mode.CircleX | InertiaClass.Mode.Out, phase = 0 },
            x
        )
)

local c = add_chart("CircleY")
c.set_col(200, 0, 0)
c.plot(
    @(x)
        1 -
            InertiaClass.Tween(
                { mode = InertiaClass.Mode.CircleY | InertiaClass.Mode.Out, phase = 0 },
                x
            )
)