return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      { name = "vault", path = "~/vault" },
    },
    notes_subdir = "inbox",
    new_notes_location = "notes_subdir",
    legacy_commands = false,
    -- render-markdown.nvim already handles pretty rendering; don't double up.
    ui = { enable = false },
  },
  keys = {
    { "<leader>vo", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: open/jump note" },
    { "<leader>vn", "<cmd>Obsidian new<cr>", desc = "Obsidian: new note" },
    { "<leader>vs", "<cmd>Obsidian search<cr>", desc = "Obsidian: grep vault" },
    { "<leader>vb", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: backlinks" },
    { "<leader>vl", "<cmd>Obsidian links<cr>", desc = "Obsidian: links in note" },
    { "<leader>vf", "<cmd>Obsidian follow_link<cr>", desc = "Obsidian: follow [[link]]" },
    { "<leader>vT", "<cmd>Obsidian tags<cr>", desc = "Obsidian: tags" },
  },
}
