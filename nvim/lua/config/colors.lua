-- Terminal color scheme (moss, same as ghostty/themes/moss)
local M = {}

function M.setup()
  vim.g.terminal_color_0 = "#1f2225" -- Ansi 0 (Background)
  vim.g.terminal_color_1 = "#f07a6f" -- Ansi 1 (Red)
  vim.g.terminal_color_2 = "#3fd468" -- Ansi 2 (Green)
  vim.g.terminal_color_3 = "#e6c07b" -- Ansi 3 (Yellow)
  vim.g.terminal_color_4 = "#a8c4b4" -- Ansi 4 (Blue)
  vim.g.terminal_color_5 = "#d3a6e0" -- Ansi 5 (Magenta)
  vim.g.terminal_color_6 = "#74d0b8" -- Ansi 6 (Cyan)
  vim.g.terminal_color_7 = "#e2e5df" -- Ansi 7 (White)
  vim.g.terminal_color_8 = "#50574f" -- Ansi 8 (Bright Black)
  vim.g.terminal_color_9 = "#f69b92" -- Ansi 9 (Bright Red)
  vim.g.terminal_color_10 = "#6fe08a" -- Ansi 10 (Bright Green)
  vim.g.terminal_color_11 = "#f0d39b" -- Ansi 11 (Bright Yellow)
  vim.g.terminal_color_12 = "#c0d6c9" -- Ansi 12 (Bright Blue)
  vim.g.terminal_color_13 = "#e2c2ec" -- Ansi 13 (Bright Magenta)
  vim.g.terminal_color_14 = "#98e0cd" -- Ansi 14 (Bright Cyan)
  vim.g.terminal_color_15 = "#f3f5f1" -- Ansi 15 (Bright White)
end

return M
