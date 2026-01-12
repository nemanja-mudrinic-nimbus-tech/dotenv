return {
  -- GitHub integration
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = false,
      default_merge_method = "rebase",
      gh_cmd = "/opt/homebrew/bin/gh",
    },
  },
  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
    },
  },
  -- Diffview integration
  { "sindrets/diffview.nvim" },
  -- Claude Code integration
  {
    "greggh/claudecode.nvim",
    enabled = false, -- Enable when ready to use Claude Code inside nvim
    lazy = false,
    config = function()
      require("claudecode").setup({
        split_side = "right",
        split_width_percentage = 0.4,
        diff = {
          enabled = true,
          layout = "vertical",
          auto_close_on_accept = true,
        },
      })
    end,
  },
}
