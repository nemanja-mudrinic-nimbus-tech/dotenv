-- Keymaps are automatically loaded on the VeryLazy event
-- 
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Execute shell command silently
vim.keymap.set("n", "<leader>xs", function()
  local cmd = vim.fn.input("Command: ")
  if cmd ~= "" then
    vim.fn.system(cmd)
  end
end, { desc = "Execute shell command" })

vim.keymap.set("n", "<leader>bp", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>bn", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })

-- Override terminal keybindings
vim.keymap.set("n", "<leader>ft", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local target_dir = (vim.v.shell_error == 0 and git_root ~= "") and git_root or vim.fn.getcwd()
  vim.cmd("terminal")
  vim.cmd("startinsert")
  vim.fn.chansend(vim.b.terminal_job_id, "cd " .. vim.fn.shellescape(target_dir) .. "\n")
end, { desc = "Terminal (project root)" })
vim.keymap.set("n", "<leader>fT", ":terminal<CR>", { desc = "Terminal (current buffer)" })

-- Copy current file path to clipboard
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied absolute path" })
end, { desc = "Yank file path (absolute)" })
vim.keymap.set("n", "<leader>fY", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify(path, vim.log.levels.INFO, { title = "Copied relative path" })
end, { desc = "Yank file path (relative to cwd)" })

-- Exit terminal mode with Escape; lazygit keeps Esc for its own back/cancel
vim.keymap.set("t", "<Esc>", function()
  if vim.api.nvim_buf_get_name(0):match("lazygit") then
    return "<Esc>"
  end
  return "<C-\\><C-n>"
end, { expr = true, desc = "Exit terminal mode" })

-- ── Splits ──────────────────────────────────────────────
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>s-", "<cmd>split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "Close split" })
vim.keymap.set("n", "<leader>so", "<cmd>only<CR>", { desc = "Close other splits" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })

-- Ctrl+hjkl navigation (nvim splits + tmux panes) is handled by vim-tmux-navigator.
-- Window resize uses LazyVim defaults: <C-Up/Down/Left/Right>.

-- Use jk to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x')

-- Paste without yanking (visual mode)
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down half screen" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up half screen" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search previous and center" })

-- Octo (GitHub) keymaps
vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "List Issues" })
vim.keymap.set("n", "<leader>oI", "<cmd>Octo issue create<CR>", { desc = "Create Issue" })
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<CR>", { desc = "List PRs" })
vim.keymap.set("n", "<leader>oP", "<cmd>Octo pr create<CR>", { desc = "Create PR" })
vim.keymap.set("n", "<leader>or", "<cmd>Octo review start<CR>", { desc = "Start Review" })

-- Diffview keymaps
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File History" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Branch History" })

-- ── Ops: cheatsheet, brain (second brain), later: ship, db ──
local function ops_float(cmd)
  require("snacks").terminal(cmd, { win = { style = "float", width = 0.8, height = 0.6, border = "rounded" }, interactive = false })
end
vim.keymap.set("n", "<leader>oc", function()
  vim.cmd("tabnew " .. vim.fn.fnameescape(vim.fn.expand("~/.dotfiles/cheatsheet.md")))
  vim.bo.readonly = true
end, { desc = "Cheatsheet (new tab)" })
vim.keymap.set("n", "<leader>ob", function()
  ops_float(vim.fn.expand("~/.dotfiles/bin/brain") .. " update .")
end, { desc = "Brain: update graph for this project" })
vim.keymap.set("n", "<leader>oB", function()
  ops_float(vim.fn.expand("~/.dotfiles/bin/brain") .. " status")
end, { desc = "Brain: status of all projects" })
