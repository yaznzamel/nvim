require("yaznzm.plugins-setup")
require("yaznzm.core.options")
require("yaznzm.core.keymaps")
-- require("yaznzm.core.colorscheme")
require("yaznzm.plugins.nvim-tree")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
require("lazy").setup("plugins")
local config = require("nvim-treesitter.configs")
config.setup({
  --ensure_installed = {"lua" , "java" , "javascript" , "python"},
highlight = {enable = true},
indent = {enable = true},
})
require("catppuccin").setup()

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>' , builtin.find_files , {})
vim.keymap.set('n' , '<C-g>' , builtin.live_grep , {})
vim.keymap.set('n' , '<C-t>' , ':Neotree filesystem reveal left<CR>')
vim.cmd.colorscheme "catppuccin"


