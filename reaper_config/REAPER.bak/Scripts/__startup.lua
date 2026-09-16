-- Start script: Adaptive grid (background process)
local adaptive_grid_cmd = '_RS6a4ecd962e6101f6f55408dd535c25addd8de2e0'
-- reaper.Main_OnCommand(reaper.NamedCommandLookup(adaptive_grid_cmd), 0)

-- Start script: Gridbox
local grid_box_cmd_name = '_RS02de4a63cf12c72510b6da7254c3f3df05dba45c'
-- reaper.Main_OnCommand(reaper.NamedCommandLookup(grid_box_cmd_name), 0)

-- Start script: REAPER Update Utility (check for new versions)
local update_utility_cmd = '_RS852f0872789b997921f7f9d40e6f997553bd5147'
reaper.Main_OnCommand(reaper.NamedCommandLookup(update_utility_cmd), 0)




function StartupScript_Archie()
    ARCHIE_INFO_COUNTER_TIME_PROJECT_AUTORUN_LUA=reaper.Main_OnCommand(reaper.NamedCommandLookup('_RSea6edc0e0d7e7441c62604c361905d60bb5036e8'),0)
end StartupScript_Archie()
