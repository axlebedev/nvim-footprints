local M = {}

local function get_normal_bg()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "normal" })
  return normal_hl.bg and string.format("#%06x", normal_hl.bg) or "#000000"
end

local function get_intermediate(
  accentColor --[[ number ]],
  baseColor --[[ number ]],
  step --[[ number ]],
  totalSteps --[[ number ]]
)
  if step <= 0 then return accentColor end
  local t = 1 - step / totalSteps
  return baseColor + (accentColor - baseColor) * require("helpers.easings").EasingFunc(t)
end

local function get_intermediate_color(
  accentColorStr --[[ string ]],
  normalColorStr --[[ string ]],
  step --[[ number ]],
  totalSteps --[[ number ]]
)
  local a_r, a_g, a_b = tonumber(accentColorStr:sub(2,3), 16), tonumber(accentColorStr:sub(4,5), 16), tonumber(accentColorStr:sub(6,7), 16)
  local n_r, n_g, n_b = tonumber(normalColorStr:sub(2,3), 16), tonumber(normalColorStr:sub(4,5), 16), tonumber(normalColorStr:sub(6,7), 16)
  
  local r = math.floor(get_intermediate(a_r, n_r, step, totalSteps) + 0.5)
  local g = math.floor(get_intermediate(a_g, n_g, step, totalSteps) + 0.5)
  local b = math.floor(get_intermediate(a_b, n_b, step, totalSteps) + 0.5)
  
  return string.format("#%02x%02x%02x", r, g, b)
end

--- Declare gradient highlights from accent -> normal background
function M.DeclareHighlights(
  groupName --[[ string ]],
  accentColorStr --[[ string ]],
  accentTermColorStr --[[ string ]],
  totalSteps --[[ number ]]
)
  local normal_bg = get_normal_bg()
  
  -- Create gradient highlights
  for i = 0, totalSteps - 1 do
    local color = get_intermediate_color(accentColorStr, normal_bg, i, totalSteps)
    vim.api.nvim_set_hl(
      0,
      groupName .. i,
      { bg = color, ctermbg = tonumber(accentTermColorStr) }
    )
  end
  
  -- Clear any remaining highlights
  local i = totalSteps
  while vim.fn.hlexists(groupName .. i) == 1 do
    vim.cmd("highlight clear " .. groupName .. i)
    i = i + 1
  end
end

return M
