local M = {}
local changes_list_store = 0

local function get_changes_list()
  local saved_more = vim.o.more
  vim.o.more = false
  
  vim.cmd("redir => result")
  vim.cmd("silent changes")
  vim.cmd("redir END")
  local result = vim.fn.eval("result")
  
  vim.o.more = saved_more
  return result
end

local function get_changes_linenumbers_list_inner(history_depth)
  local changes_list = get_changes_list()
  local lines = vim.split(changes_list, "\n")
  
  -- Remove header and prompt lines
  if #lines > 2 then
    lines = vim.list_slice(lines, 3, #lines - 1)
  else
    lines = {}
  end
  
  -- Limit history depth
  if #lines > history_depth then
    lines = vim.list_slice(lines, #lines - history_depth + 1, #lines)
  end
  
  local line_numbers = {}
  for _, line in ipairs(lines) do
    local parts = vim.split(line, "%s+") -- split on whitespace
    if #parts > 1 then
      table.insert(line_numbers, tonumber(parts[3]))
    end
  end
  
  return line_numbers
end

--- Get recent changes line numbers (cached)
function M.GetChangesLinenumbersList(history_depth)
  if changes_list_store ~= 0 then
    return { changes_list_store }
  end
  return get_changes_linenumbers_list_inner(history_depth)
end

--- Clear cached changes list
function M.ClearChangesList()
  changes_list_store = 0
  return true
end

return M
