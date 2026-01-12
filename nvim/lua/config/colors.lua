-- Terminal color scheme
local M = {}

function M.setup()
  vim.g.terminal_color_0 = "#141414" -- Ansi 0 (Background)
  vim.g.terminal_color_1 = "#bf4040" -- Ansi 1 (Red)
  vim.g.terminal_color_2 = "#a38c8c" -- Ansi 2 (Green)
  vim.g.terminal_color_3 = "#8c8c8c" -- Ansi 3 (Yellow)
  vim.g.terminal_color_4 = "#335050" -- Ansi 4 (Blue)
  vim.g.terminal_color_5 = "#7f5050" -- Ansi 5 (Magenta)
  vim.g.terminal_color_6 = "#8cd0d0" -- Ansi 6 (Cyan)
  vim.g.terminal_color_7 = "#d8d8d8" -- Ansi 7 (White)
  vim.g.terminal_color_8 = "#505050" -- Ansi 8 (Bright Black)
  vim.g.terminal_color_9 = "#336161" -- Ansi 9 (Bright Red)
  vim.g.terminal_color_10 = "#a3cbcb" -- Ansi 10 (Bright Green)
  vim.g.terminal_color_11 = "#8c8c8c" -- Ansi 11 (Bright Yellow)
  vim.g.terminal_color_12 = "#a1a1a1" -- Ansi 12 (Bright Blue)
  vim.g.terminal_color_13 = "#b4b4b4" -- Ansi 13 (Bright Magenta)
  vim.g.terminal_color_14 = "#d0d0d0" -- Ansi 14 (Bright Cyan)
  vim.g.terminal_color_15 = "#ffffff" -- Ansi 15 (Bright White)
end

return M
