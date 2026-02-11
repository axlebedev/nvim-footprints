local ClearHighlights = require("helpers.clearhighlights")
local DeclareHighlights = require("helpers.declarehighlights")
local GetChangesList = require("helpers.getchangeslist")
local UpdateMatches = require("helpers.updatematches")

local M = {}
local is_enabled = false
local group_name = "FootprintsStep"

local function get_is_enabled()
  return vim.b.isEnabled ~= nil and vim.b.isEnabled or is_enabled
end

local function should_update_matches()
  return get_is_enabled() 
    and vim.bo.modifiable 
    and not vim.wo.diff 
    and not vim.tbl_contains(vim.g.footprintsExcludeFiletypes, vim.bo.filetype)
end

local function run_update_matches()
  UpdateMatches.UpdateMatches(
    group_name,
    vim.api.nvim_get_current_buf(),
    GetChangesList.GetChangesLinenumbersList(vim.g.footprintsHistoryDepth),
    vim.g.footprintsHistoryDepth
  )
end

local function footprints_inner(bufnr)
  if not should_update_matches() then
    ClearHighlights.ClearHighlights(group_name)
    return
  end
  GetChangesList.ClearChangesList()
  run_update_matches()
end

function M.FootprintsInit()
  DeclareHighlights.DeclareHighlights(group_name, vim.g.footprintsColor, vim.g.footprintsTermColor, vim.g.footprintsHistoryDepth)
  is_enabled = vim.g.footprintsEnabledByDefault
end

function M.SetColor(color)
  vim.g.footprintsColor = color
  DeclareHighlights.DeclareHighlights(group_name, vim.g.footprintsColor, vim.g.footprintsTermColor, vim.g.footprintsHistoryDepth)
end

function M.SetTermColor(color)
  vim.g.footprintsTermColor = color
  DeclareHighlights.DeclareHighlights(group_name, vim.g.footprintsColor, vim.g.footprintsTermColor, vim.g.footprintsHistoryDepth)
end

function M.Footprints()
  footprints_inner(vim.api.nvim_get_current_buf())
end

function M.OnBufEnter()
  ClearHighlights.ClearHighlights(group_name)
  footprints_inner(vim.api.nvim_get_current_buf())
end

function M.OnFiletypeSet()
  ClearHighlights.ClearHighlights(group_name)
  footprints_inner(vim.api.nvim_get_current_buf())
end

function M.OnCursorMove()
  if not should_update_matches() or vim.g.footprintsOnCurrentLine then
    return
  end
  run_update_matches()
end

function M.FootprintsDisable(is_buf_local)
  if is_buf_local then
    vim.b.isEnabled = false
  else
    is_enabled = false
  end
  ClearHighlights.ClearHighlightsInAllBuffers(group_name)
end

function M.FootprintsEnable(is_buf_local)
  if is_buf_local then
    vim.b.isEnabled = true
  else
    is_enabled = true
  end
  local tabpage = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.api.nvim_buf_call(bufnr, function() footprints_inner(bufnr) end)
  end
end

function M.FootprintsToggle(is_buf_local)
  if get_is_enabled() then
    M.FootprintsDisable(is_buf_local)
  else
    M.FootprintsEnable(is_buf_local)
  end
end

function M.FootprintsEnableCurrentLine()
  vim.g.footprintsOnCurrentLine = true
  run_update_matches()
end

function M.FootprintsDisableCurrentLine()
  vim.g.footprintsOnCurrentLine = false
  run_update_matches()
end

function M.FootprintsToggleCurrentLine()
  if vim.g.footprintsOnCurrentLine then
    M.FootprintsDisableCurrentLine()
  else
    M.FootprintsEnableCurrentLine()
  end
end

function M.SetHistoryDepth(new_depth)
  vim.g.footprintsHistoryDepth = new_depth
  DeclareHighlights.DeclareHighlights(group_name, vim.g.footprintsColor, vim.g.footprintsTermColor, vim.g.footprintsHistoryDepth)
  run_update_matches()
end

return M
