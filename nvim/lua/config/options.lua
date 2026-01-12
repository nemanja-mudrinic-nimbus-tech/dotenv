-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable AI in completion menu, use inline ghost text instead
vim.g.ai_cmp = false
vim.opt.spell = false
vim.opt.autowriteall = true -- Auto-save files
vim.opt.background = "dark"

-- Increase timeout for which-key to prevent space key issues
vim.opt.timeoutlen = 400

vim.opt.wrap = true
vim.opt.breakindent = true

-- Neovide settings
if vim.g.neovide then
  -- Load environment from interactive shell (reads .zshrc)
  local shell_env = vim.fn.system("zsh -ic 'printenv'")
  for line in shell_env:gmatch("[^\n]+") do
    local key, value = line:match("^([^=]+)=(.*)$")
    if key and value then
      vim.env[key] = value
    end
  end

  vim.o.guifont = "GeistMono Nerd Font:h13"
  vim.g.neovide_fullscreen = true
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_scroll_animation_length = 0 -- Disable scroll animation to prevent jitter

  -- Cmd+V paste in all modes
  vim.keymap.set({ "n", "v", "i", "c", "t" }, "<D-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { noremap = true, silent = true })
end

-- Load terminal colors
require("config.colors").setup()
