-- Reading mode: grow the vellum preview to fill the tab and park the cursor in
-- it. The source window is shrunk rather than closed, because vellum's BufHidden
-- handler tears the preview down once no window shows the markdown buffer.
local M = {}

local node_usable

-- mermaid 12 and marked 18 need node >= 22.12; an .nvmrc pinning an older
-- version would otherwise give a blank pane with no explanation
function M.node_ok()
  if node_usable ~= nil then
    return node_usable
  end
  local ran, r = pcall(function()
    return vim.system({ "node", "--version" }, { text = true }):wait()
  end)
  local major, minor
  if ran and r.code == 0 then
    major, minor = r.stdout:match("v(%d+)%.(%d+)")
  end
  node_usable = major ~= nil and (tonumber(major) > 22 or (tonumber(major) == 22 and tonumber(minor) >= 12))
  if not node_usable then
    vim.notify(
      "vellum: preview off, needs node >= 22.12 (found "
        .. (major and ("v" .. major .. "." .. minor) or "no node on PATH")
        .. "). Run `nvm use --lts`, then restart nvim.",
      vim.log.levels.WARN
    )
  end
  return node_usable
end

local layout, origin, minwidth

local function preview_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if name:match("vellum://preview$") then
      return win
    end
  end
end

function M.toggle()
  if layout then
    pcall(vim.cmd, layout)
    if origin and vim.api.nvim_win_is_valid(origin) then
      vim.api.nvim_set_current_win(origin)
    end
    vim.o.winminwidth = minwidth
    layout, origin, minwidth = nil, nil, nil
    return
  end

  local win = preview_win()
  if not win then
    if vim.bo.filetype ~= "markdown" then
      return vim.notify("Not a markdown file", vim.log.levels.WARN)
    end
    require("vellum").open()
    win = preview_win()
    if not win then
      return vim.notify("vellum: preview did not open", vim.log.levels.WARN)
    end
  end

  layout = vim.fn.winrestcmd()
  origin = vim.api.nvim_get_current_win()
  minwidth = vim.o.winminwidth
  vim.o.winminwidth = 0
  vim.api.nvim_set_current_win(win)
  vim.cmd("wincmd |")
end

return M
