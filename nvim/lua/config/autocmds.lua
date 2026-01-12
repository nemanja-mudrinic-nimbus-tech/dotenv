-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Disable default spell autocmd
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

-- =====================
-- Auto-save Configuration
-- =====================
-- Note: Removed InsertLeavePre to avoid blocking mode transitions
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedP", "InsertLeave" }, {
  callback = function()
    if vim.bo.modifiable and not vim.bo.readonly then
      vim.cmd("silent! update")
    end
  end,
})

-- =====================
-- Window Dimming Configuration
-- =====================
local ACTIVE_WINDOW_DIM_FACTOR = 0.85

local function set_window_highlights()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  if normal_hl.bg then
    local bg = normal_hl.bg
    local r = math.floor(bg / 65536)
    local g = math.floor((bg % 65536) / 256)
    local b = bg % 256

    r = math.floor(r * ACTIVE_WINDOW_DIM_FACTOR)
    g = math.floor(g * ACTIVE_WINDOW_DIM_FACTOR)
    b = math.floor(b * ACTIVE_WINDOW_DIM_FACTOR)

    local dimmed_bg = r * 65536 + g * 256 + b
    vim.api.nvim_set_hl(0, "ActiveWindow", { bg = dimmed_bg })
  else
    vim.api.nvim_set_hl(0, "ActiveWindow", { bg = "#0d0d0d" })
  end

  vim.api.nvim_set_hl(0, "InactiveWindow", { bg = normal_hl.bg })
end

-- Apply highlights on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_window_highlights,
})

-- Set initial highlight groups
set_window_highlights()

-- Apply window highlighting on focus change
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    -- Skip diff windows to preserve diff highlighting
    if vim.wo.diff then
      return
    end
    vim.wo.winhl = "Normal:ActiveWindow"
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    -- Skip diff windows to preserve diff highlighting
    if vim.wo.diff then
      return
    end
    vim.wo.winhl = "Normal:InactiveWindow"
  end,
})

-- =====================
-- Prettier/ESLint Auto-format Configuration
-- =====================
-- Auto-format JS/TS files when exiting insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    -- Use async formatting to avoid blocking the editor
    require("conform").format({ async = true })
  end,
})

-- =====================
-- Terminal Configuration
-- =====================
-- Disable auto-entering terminal mode when navigating to terminal buffers
-- Remove LazyVim's default terminal autocmd that auto-enters insert mode
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_terminal")

-- Configure terminal buffers to have cleaner UI
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- =====================
-- LSP Configuration
-- =====================
-- Disable Ruff hover in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- =====================
-- Ruff Auto-fix on InsertLeave (Python)
-- =====================
-- Toggle: set vim.g.ruff_auto_fix_insertleave = false in your init.lua to disable.
vim.g.ruff_auto_fix_insertleave = vim.g.ruff_auto_fix_insertleave ~= false

-- Throttle to avoid multiple quick triggers when leaving Insert mode repeatedly
local ruff_last_fix = 0
local RUFF_FIX_DEBOUNCE_MS = 800

local function ruff_auto_fix(bufnr)
  if not vim.g.ruff_auto_fix_insertleave then
    return
  end
  if vim.bo[bufnr].filetype ~= 'python' then
    return
  end
  -- Only run if buffer is modifiable and not read-only
  if not (vim.bo[bufnr].modifiable and not vim.bo[bufnr].readonly) then
    return
  end
  local now = vim.loop.hrtime() / 1e6
  if (now - ruff_last_fix) < RUFF_FIX_DEBOUNCE_MS then
    return
  end
  ruff_last_fix = now

  -- Prefer Conform since it's configured with ruff_fix, ruff_format, ruff_organize_imports
  local ok_conform, conform = pcall(require, 'conform')
  if ok_conform then
    conform.format({ async = true, lsp_fallback = true, bufnr = bufnr })
    return
  end

  -- Fallback: try LSP code action 'source.fixAll.ruff'
  local params = {
    context = { only = { 'source.fixAll.ruff' } },
  }
  vim.lsp.buf.code_action(params)
end

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*.py',
  callback = function(args)
    ruff_auto_fix(args.buf)
  end,
  desc = 'Ruff: auto-fix (ruff_fix/format/imports) when leaving insert mode',
})

