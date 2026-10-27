return {
  {
    "2giosangmitom/sqmeow.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    version = "*",
    build = function()
      require("sqmeow").install()
    end,
    opts = {},
    cmd = "Sqmeow",
    keys = {
      { "<leader>Dd", "<cmd>Sqmeow toggle<cr>", desc = "DB: toggle drawer" },
      { "<leader>Da", "<cmd>Sqmeow add<cr>", desc = "DB: add connection" },
      { "<leader>Ds", "<cmd>Sqmeow scratch<cr>", desc = "DB: new scratchpad" },
      { "<leader>Dc", "<cmd>Sqmeow cancel<cr>", desc = "DB: cancel query" },
      { "<leader>Dl", "<cmd>Sqmeow log<cr>", desc = "DB: query log" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { { "<leader>D", group = "database", icon = "" } })
    end,
  },
}
