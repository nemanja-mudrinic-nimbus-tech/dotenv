-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    -- stylua: ignore
    local colors = {
      insert_mode_bg   = '#4a90e2',
      visual_mode_bg   = '#f5d142',
      inactive_bg      = '#080808',
      fg               = '#c6c6c6',
      replace_mode_bg  = '#e74c3c',
      normal_mode_bg   = '#2ecc71',
      secondary_bg     = '#303030',
    }

    local bubbles_theme = {
      normal = {
        a = { fg = colors.inactive_bg, bg = colors.normal_mode_bg },
        b = { fg = colors.fg, bg = colors.secondary_bg },
        c = { fg = colors.fg },
      },

      insert = { a = { fg = colors.inactive_bg, bg = colors.insert_mode_bg } },
      visual = { a = { fg = colors.inactive_bg, bg = colors.visual_mode_bg } },
      replace = { a = { fg = colors.inactive_bg, bg = colors.replace_mode_bg } },

      inactive = {
        a = { fg = colors.fg, bg = colors.inactive_bg },
        b = { fg = colors.fg, bg = colors.inactive_bg },
        c = { fg = colors.fg },
      },
    }

    require("lualine").setup({
      options = {
        theme = bubbles_theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = { "filename", "branch" },
        lualine_c = {
          {
            function()
              local gitsigns = vim.b.gitsigns_blame_line
              if gitsigns then
                return gitsigns
              end
              return ""
            end,
            icon = "",
          },
          "%=",
        },
        lualine_x = {},
        lualine_y = { "filetype", "progress" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })
  end,
}
