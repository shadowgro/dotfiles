---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "pcmanfm-qt"
local menu        = "noctalia msg panel-toggle launcher"
local browser     = "zen-beta"
local editor      = "zeditor"
local panel       = "noctalia msg panel-toggle session"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(panel))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("move +col"))
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("focus r"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + W",hl.dsp.layout("colresize 1"))
hl.bind(mainMod .. " + S",hl.dsp.layout("colresize 0.5"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + Z",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + X", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Broken in 0.57
-- local switch_layout = hl.dsp.exec_cmd("hyprctl switchxkblayout all next")
-- hl.bind("ALT + SHIFT + SHIFT_L", switch_layout, { release = true })
-- hl.bind("ALT + SHIFT + ALT_L",   switch_layout, { release = true })

-- Layout switch script

local switch_cmd = "hyprctl switchxkblayout all next"

local down  = { shift = {}, alt = {} }
local armed = false

local function both_down()
    return next(down.shift) ~= nil and next(down.alt) ~= nil
end

local function on_press(group, key)
    down[group][key] = true
    if both_down() then armed = true end
end

local function on_release(group, key)
    down[group][key] = nil
    if armed then
        armed = false
        hl.dispatch(hl.dsp.exec_cmd(switch_cmd))
    end

    if next(down.shift) == nil and next(down.alt) == nil then
        armed = false
    end
end

local keys = {
    { key = "Shift_L", group = "shift" },
    { key = "Shift_R", group = "shift" },
    { key = "Alt_L",   group = "alt"   },
    { key = "Alt_R",   group = "alt"   },
}
local mod_names = { "SHIFT", "ALT", "CTRL", "SUPER" }


local function mod_masks()
    local masks = {}
    for bits = 0, (1 << #mod_names) - 1 do
        local m = {}
        for i, name in ipairs(mod_names) do
            if bits & (1 << (i - 1)) ~= 0 then m[#m + 1] = name end
        end
        masks[#masks + 1] = m
    end
    return masks
end

local function spec(mask, key)
    if #mask == 0 then return key end
    return table.concat(mask, " + ") .. " + " .. key
end

for _, mask in ipairs(mod_masks()) do
    for _, k in ipairs(keys) do
        local s = spec(mask, k.key)

        hl.bind(s, function() on_press(k.group, k.key) end,
            { transparent = true, non_consuming = true })

        hl.bind(s, function() on_release(k.group, k.key) end,
            { release = true, transparent = true, non_consuming = true,
              submap_universal = true })
    end
end

local cancel_keys = { "E", "R", "T", "S", "D", "F", "G" }

for _, key in ipairs(cancel_keys) do
    hl.bind("SHIFT + ALT + " .. key, function()
        armed = false
    end, { transparent = true, non_consuming = true })
end
