local M = {}

local EASING_CURVES = {
  linear = function(x) return x end,
  easein = function(x) return x ^ 3 end,
  easeout = function(x) return 1 - (1 - x) ^ 3 end,
  easeinoutsine = function(x) return -(math.cos(math.pi * x) - 1) / 2 end,
}

--- Get intermediate value from 0 to 1 according to easing curve
--- @param x number 0-1 progress value
--- @return number eased value
function M.EasingFunc(x)
  local easing_func = (vim.g.footprintsEasingFunction or "easeinoutsine"):lower()
  local curve = EASING_CURVES[easing_func] or EASING_CURVES.easeinoutsine
  return curve(x)
end

return M
