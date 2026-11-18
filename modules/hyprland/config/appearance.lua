-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        border_size = 2,
        gaps_in  = 4,
        gaps_out = 4,

        no_focus_fallback = true,
        resize_on_border = false,
        allow_tearing = false,

        layout = "scrolling",

        col = {
            -- active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            active_border   = { colors = {"rgba(d8dee9ee)"}},
            inactive_border = "rgba(59595900)",
        },

        snap = {
            enabled = true,
            respect_gaps = true,
            monitor_gap = 50,
            window_gap = 50,
        },

    },

    decoration = {
        rounding       = 12,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = false,
            range        = 40,
            render_power = 4,
            sharp        = false,
            color        = 0xaa0a0a0a,
            offset       = {4, 4},
            scale        = 1.0,
        },

        wobble = {
            enabled = true,
            mesh = 10,
            stiffness = 1000,
            damping = 20,
            mass = 1,
            value_epsilon = 2,
            velocity_epsilon = 20,
        },

        blur = {
            enabled      = true,
            variant      = "haze",
            haze = { intensity = 0.9, iridescence = 0.2 },
            ripple = { duration = 2.0 },
            aurora = { speed = 3.0 },
            glass = { size = 40.0 },
            size              = 3,
            passes            = 3,
            noise             = 0.02,
            brightness        = 0.35,
            contrast          = 1.7,
            ignore_opacity    = false,
            vibrancy          = 0,
            vibrancy_darkness = 0,
        },
    },

    animations = {
        enabled = true,
    },

})

hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 2.79, bezier = "quick" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 2,    bezier = "almostLinear",        style = "slide bottom" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2,    bezier = "almostLinear",        style = "slide" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = false,
        follow_min_visible = 0.01,
        wrap_focus = false,
        wrap_swapcol = false,
    },
})
