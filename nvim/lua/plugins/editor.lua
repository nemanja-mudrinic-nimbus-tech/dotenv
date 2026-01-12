return {
  -- Dashboard configuration
  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[
 _   _ _           _                 _____         _
| \ | (_)         | |               |_   _|       | |
|  \| |_ _ __ ___ | |__  _   _ ___    | | ___  ___| |__
| . ` | | '_ ` _ \| '_ \| | | / __|   | |/ _ \/ __| '_ \
| |\  | | | | | | | |_) | |_| \__ \   | |  __/ (__| | | |
\_| \_/_|_| |_| |_|_.__/ \__,_|___/   \_/\___|\___|_| |_|
      ]]

      logo = string.rep("\n", 2) .. logo .. "\n"
      opts.config.header = vim.split(logo, "\n")
      opts.config.header_hl = "DashboardLogo"
      vim.api.nvim_set_hl(0, "DashboardLogo", { fg = "#ffffff" })
      opts.config.footer = function()
        return {}
      end
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, {
        { "<leader>a", group = "ai", icon = "󰧑" },
      })
    end,
  },

  -- Gitsigns configuration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 300,
      },
    },
  },
}
