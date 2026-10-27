return {
  -- Moss: tokyonight's engine with the moss palette (green, no blue)
  {
    "folke/tokyonight.nvim",
    opts = function()
      require("tokyonight.colors").styles.moss = function()
        return vim.deepcopy(require("config.moss"))
      end
      return {
        style = "moss",
        -- Same roles as the palette mockup: keywords green, functions teal, types purple, strings amber
        on_highlights = function(hl, c)
          local keyword = { fg = c.green }
          for _, g in ipairs({ "Keyword", "Statement", "Conditional", "Repeat", "Include", "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional", "@keyword.repeat", "@keyword.import", "@keyword.exception", "@keyword.coroutine", "@keyword.type", "@keyword.modifier", "@keyword.operator", "@keyword.directive" }) do
            hl[g] = keyword
          end
          for _, g in ipairs({ "Function", "@function", "@function.call", "@function.method", "@function.method.call" }) do
            hl[g] = { fg = c.cyan }
          end
          for _, g in ipairs({ "Type", "@type", "@type.builtin", "@type.definition" }) do
            hl[g] = { fg = c.magenta }
          end
          for _, g in ipairs({ "String", "@string" }) do
            hl[g] = { fg = c.yellow }
          end
          hl.SnacksPickerTitle = { fg = c.bg, bg = c.green, bold = true }
          hl.SnacksPickerBoxTitle = { fg = c.bg, bg = c.green, bold = true }
        end,
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
  -- "auto" looks for a lualine theme named after the colorscheme (tokyonight-moss) and falls back to grey
  {
    "nvim-lualine/lualine.nvim",
    opts = { options = { theme = "tokyonight" } },
  },

  -- Snacks: show hidden files in picker/explorer, right-side terminal
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      animate = {},
      picker = {
        sources = {
          files = { hidden = true },
          explorer = { hidden = true, ignored = false },
        },
      },
      explorer = { hidden = true, ignored = false },
      terminal = {
        win = { position = "right", width = 0.3 },
      },
      scroll = {
        -- vellum syncs scroll both ways; an animated scroll looks like a manual one
        -- and the two windows fight (cursor jumps back), so animate only without a preview
        filter = function(buf)
          return vim.g.snacks_scroll ~= false
            and vim.b[buf].snacks_scroll ~= false
            and vim.bo[buf].buftype ~= "terminal"
            and vim.fn.bufexists("vellum://preview") == 0
        end,
      },
      -- open image files (jpg/png/gif/webp/heic/pdf…) in a buffer; images inside markdown are vellum's job
      image = { enabled = true, doc = { enabled = false } },
    },
  },

  -- Diagnostic/git marks in the scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        marks = {
          Error = { text = { "█" } },
          Warn = { text = { "█" } },
          Info = { text = { "█" } },
          Hint = { text = { "█" } },
          Misc = { text = { "█" } },
        },
      })
    end,
  },
}
