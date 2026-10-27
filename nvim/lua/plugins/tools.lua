return {
  -- GitHub PRs / issues / reviews (plugin comes from the lang.* octo extra)
  {
    "pwntester/octo.nvim",
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = false,
      default_merge_method = "rebase",
      gh_cmd = "/opt/homebrew/bin/gh",
    },
  },
  -- Diff / merge-conflict review (keymaps in config/keymaps.lua)
  { "sindrets/diffview.nvim" },
}
