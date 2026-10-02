-- Apply Fade-In / Fade-Out using time selection (corrected logic)
-- Author: Reaper DAW Ultimate Assistant

reaper.Undo_BeginBlock()

local ts_start, ts_end = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
if ts_start == ts_end then
  reaper.ShowMessageBox("No time selection set.", "Error", 0)
  return
end

local item_count = reaper.CountSelectedMediaItems(0)
if item_count == 0 then
  reaper.ShowMessageBox("No items selected.", "Error", 0)
  return
end

for i = 0, item_count - 1 do
  local item = reaper.GetSelectedMediaItem(0, i)

  local item_pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
  local item_len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
  local item_end = item_pos + item_len

  -- FADE-IN
  -- Only if item start is BEFORE or EQUAL to time selection start
  if item_pos <= ts_start then
    local fade_in_end = math.min(ts_end, item_end)
    local fade_in_len = fade_in_end - item_pos
    if fade_in_len > 0 then
      reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fade_in_len)
    end
  end

  -- FADE-OUT
  -- Only if item end is BEFORE or EQUAL to time selection end
  if item_end <= ts_end then
    local fade_out_start = math.max(ts_start, item_pos)
    local fade_out_len = item_end - fade_out_start
    if fade_out_len > 0 then
      reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fade_out_len)
    end
  end

  reaper.UpdateItemInProject(item)
end

reaper.Undo_EndBlock("Apply fades using time selection (corrected)", -1)

