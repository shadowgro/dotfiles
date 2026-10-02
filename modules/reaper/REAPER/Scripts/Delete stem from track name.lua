-- @description Remove the word "stem" from selected track names
-- @version 1.0
-- @author ChatGPT
-- @about
--   This script removes the word "stem" (case-insensitive) from the names of all selected tracks.

function main()
  local num_tracks = reaper.CountSelectedTracks(0)
  if num_tracks == 0 then
    reaper.ShowMessageBox("No tracks selected!", "Info", 0)
    return
  end

  reaper.Undo_BeginBlock()
  
  for i = 0, num_tracks - 1 do
    local track = reaper.GetSelectedTrack(0, i)
    local retval, name = reaper.GetTrackName(track, "")
    
    -- Remove "stem" (case-insensitive, with or without surrounding spaces)
    local new_name = name:gsub("[-][ ]*[Ss][Tt][Ee][Mm][ ]*", "")
    
    -- Trim leading/trailing spaces after removal
    new_name = new_name:match("^%s*(.-)%s*$")
    
    if new_name ~= name then
      reaper.GetSetMediaTrackInfo_String(track, "P_NAME", new_name, true)
    end
  end
  
  reaper.Undo_EndBlock("Remove 'stem' from selected track names", -1)
end

main()

