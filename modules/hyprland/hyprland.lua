require("./config/*")



-- if hl.plugin.dynamic_cursors
--     then
--     hl.config ({
--         plugin = {
--             dynamic_cursors = {
--                 enabled = true,
--                 mode = "tilt",
--                 threshold = 2,
--                 tilt = {
--                     -- controls how powerful the tilt is, the lower, the more power
--                     -- this value controls at which speed (px/s) the full tilt is reached
--                     limit = 5000,
--                     -- relationship between speed and tilt, supports these values:
--                     -- linear             - a linear function is used
--                     -- quadratic          - a quadratic function is used (most realistic to actual air drag)
--                     -- negative_quadratic - negative version of the quadratic one, feels more aggressive
--                     -- see `activation` in `src/mode/utils.cpp` for how exactly the calculation is done
--                     activation = "negative_quadratic",
--                     -- time window (ms) over which the speed is calculated
--                     -- higher values will make slow motions smoother but more delayed
--                     window = 100,
--                     -- full tilt for each side (°)
--                     full = 60,
--                 },
--             }
--         }
--     })
-- end
