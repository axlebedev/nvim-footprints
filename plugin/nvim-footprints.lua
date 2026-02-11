local augroup = vim.api.nvim_create_augroup("footprints", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function() require("footprints").FootprintsInit() end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function() require("footprints").OnFiletypeSet() end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function() require("footprints").OnBufEnter() end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = augroup,
  callback = function() require("footprints").OnCursorMove() end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "FileType", "BufEnter", "BufLeave" }, {
  group = augroup,
  callback = function() require("footprints").Footprints() end,
})

-- Commands
vim.api.nvim_create_user_command(
    "FootprintsDisable",
    function() require("footprints").FootprintsDisable() end,
    { desc = "Disable footprints globally" }
)

vim.api.nvim_create_user_command(
    "FootprintsEnable",
    function() require("footprints").FootprintsEnable() end,
    { desc = "Enable footprints globally" }
)

vim.api.nvim_create_user_command(
    "FootprintsToggle",
    function() require("footprints").FootprintsToggle() end,
    { desc = "Toggle footprints globally" }
)

vim.api.nvim_create_user_command(
    "FootprintsBufferDisable",
    function() require("footprints").FootprintsDisable(true) end,
    { desc = "Disable footprints for current buffer" }
)

vim.api.nvim_create_user_command(
    "FootprintsBufferEnable",
    function() require("footprints").FootprintsEnable(true) end,
    { desc = "Enable footprints for current buffer" }
)

vim.api.nvim_create_user_command(
    "FootprintsBufferToggle",
    function() require("footprints").FootprintsToggle(true) end,
    { desc = "Toggle footprints for current buffer" }
)

vim.api.nvim_create_user_command(
    "FootprintsDisableCurrentLine",
    function() require("footprints").FootprintsDisableCurrentLine() end,
    { desc = "Disable footprints for current line" }
)

vim.api.nvim_create_user_command(
    "FootprintsEnableCurrentLine",
    function() require("footprints").FootprintsEnableCurrentLine() end,
    { desc = "Enable footprints for current line" }
)

vim.api.nvim_create_user_command(
    "FootprintsToggleCurrentLine",
    function() require("footprints").FootprintsToggleCurrentLine() end,
    { desc = "Toggle footprints for current line" }
)
