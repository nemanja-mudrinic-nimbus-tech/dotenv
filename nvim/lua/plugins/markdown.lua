return {
  -- Toggle inline rendering (render-markdown.nvim comes from the markdown extra)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: toggle inline render" },
    },
  },

  -- Preview with images, mermaid and math (headless Chrome via node). On demand only:
  -- <leader>mv toggles a side split, <leader>mz toggles full-screen reading.
  {
    "blackhat-7/vellum.nvim",
    ft = "markdown",
    opts = {},
    keys = {
      {
        "<leader>mv",
        function()
          if require("config.markdown-zen").node_ok() then
            vim.cmd("Vellum")
          end
        end,
        desc = "Markdown: toggle preview (split)",
      },
      {
        "<leader>mz",
        function()
          if require("config.markdown-zen").node_ok() then
            require("config.markdown-zen").toggle()
          end
        end,
        desc = "Markdown: toggle full-screen reading",
      },
    },
  },
}
