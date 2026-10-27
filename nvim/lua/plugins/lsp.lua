return {
  -- Python venv selection with pyenv support (kept; not covered by lang extras)
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      pyenv_path = vim.fn.expand("~/.pyenv/versions"),
    },
  },
}
