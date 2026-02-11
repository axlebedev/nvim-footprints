local M = {}

local is_error_message_shown = false

--- Update footprint matches with gradient highlights
function M.UpdateMatches(group_name, bufnr, line_numbers, history_depth)
  local current_line = vim.fn.line(".")
  require("helpers.clearhighlights").ClearHighlights(group_name)

  local max_i = math.min(#line_numbers, history_depth)

  -- Show error once if highlights not ready
  if not is_error_message_shown and vim.fn.hlexists(group_name .. (history_depth - 1)) == 0 then
    is_error_message_shown = true
    vim.notify("No highlight group found for g:footprintsHistoryDepth=" .. 
               vim.g.footprintsHistoryDepth .. 
               ". You should call footprints.SetHistoryDepth(" .. vim.g.footprintsHistoryDepth .. ")", 
               vim.log.levels.WARN)
  end

  -- Add matches for each line (newest at top)
  for i = 0, max_i - 1 do
    local line_nr = line_numbers[i + 1]  -- Lua 1-indexed
    if vim.g.footprintsOnCurrentLine or line_nr ~= current_line then
      local highlight_group = group_name .. (max_i - i - 1)
      pcall(vim.fn.matchadd, highlight_group, "\\%" .. line_nr .. "l", -100009)
    end
  end
end

return M
