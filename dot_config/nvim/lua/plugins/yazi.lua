---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    { "<leader>-",  mode = { "n", "v" }, "<cmd>Yazi<CR>",      desc = "Yazi (here)" },
    { "<leader>cw",                           "<cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
    { "<C-Up>",                               "<cmd>Yazi toggle<CR>", desc = "Resume last Yazi" },
  },
  opts = {
    open_for_directories = false,
  },
}
