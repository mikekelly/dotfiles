local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "vim-scripts/BufOnly.vim" },
    { "tidalcycles/vim-tidal" },

    -- Fuzzy + grep
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Git
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim", config = true },

    -- Statusline
    { "nvim-lualine/lualine.nvim", config = true },

    -- Motion / comments / text
    { "easymotion/vim-easymotion" },
    { "tpope/vim-commentary" },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },
    { "tpope/vim-unimpaired" },
    { "tpope/vim-abolish" },
    { "windwp/nvim-autopairs", config = true },
    { "godlygeek/tabular" },

    -- Tree / alt to NERDTree
    -- { "nvim-tree/nvim-tree.lua", config = true },

    -- Diagnostics (syntastic replacement)
    { "folke/trouble.nvim", opts = {} },

    -- Editorconfig
    { "editorconfig/editorconfig-vim" },

    -- Treesitter (languages)
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Quality of life
    { "folke/which-key.nvim", opts = {} },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

    { "mbbill/undotree" },
    { "preservim/nerdtree" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

vim.keymap.set("n", "\\n", ":NERDTreeToggle<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "\\/", ":Commentary<CR>", { silent = true })
vim.keymap.set("v", "\\/", ":Commentary<CR>", { silent = true })

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
