return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    integrations = {
      harpoon = true,
    },
  },
  config = function(_, opts)
    vim.cmd.colorscheme("catppuccin")
    require("catppuccin").setup(opts)
  end,
}
