---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_variant = "",
        kb_model   = "",
        -- kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        repeat_rate = 30,
        repeat_delay = 200,

        follow_mouse = 1,
        follow_mouse_shrink = 0,
        follow_mouse_threshold = 100,
        mouse_refocus = false,
        numlock_by_default = true,

        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.3,
        },
    },

    cursor = {
        no_warps = true,
        no_hardware_cursors = true
      },
})

hl.device({
    name        = "xiaomi-xiaomi-wireless-mouse-3-colorful-mouse",
    sensitivity = -0.85,
})

hl.device({
    name        = "elan1200:00-04f3:30f7-touchpad",
    sensitivity = 0.1,
})

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
hl.exec_cmd("noctalia")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "36")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        disable_splash_rendering = true,
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
    },
})
