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

vim.keymap.set("n", "<leader>ac", ":ClaudeCode<CR>", { desc = "Toggle Claude Code" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

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

-- Exit terminal mode with Escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Navigate between nvim splits with Ctrl+hjkl (also from terminal)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move to left split" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move to top split" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move to right split" })

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
