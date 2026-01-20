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
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
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
    {
      "nvim-lualine/lualine.nvim",
      opts = {
        options = {
          disabled_filetypes = {
            statusline = { "neo-tree", "overwatch_tree", "overwatch_hunk" },
          },
        },
        sections = {
          lualine_c = { { "filename", path = 3 } },
        },
      },
    },

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
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "elixir", "heex", "eex" },
          highlight = { enable = true },
        })
      end,
    },

    -- LSP (mason for installing servers)
    {
      "williamboman/mason.nvim",
      config = true,
      build = ":MasonInstall typescript-language-server elixir-ls pyright",
    },

    -- Quality of life
    { "folke/which-key.nvim", opts = {} },
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },

    { "mbbill/undotree" },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      opts = {},
    },

    -- Inline diff viewer (using local dev version)
    { dir = "~/code/overwatch.nvim", opts = {} },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
})

vim.cmd.colorscheme "catppuccin"

-- LSP configuration (nvim 0.11+)
vim.lsp.config.ts_ls = {}
vim.lsp.config.pyright = {}
vim.lsp.config.elixirls = {}
vim.lsp.enable({ "ts_ls", "pyright", "elixirls" })

-- Toggle functions that swap neo-tree and overwatch
local function close_neotree()
  local ok, manager = pcall(require, "neo-tree.sources.manager")
  if ok then
    manager.close_all()
  end
end

local function close_overwatch()
  local ok, state = pcall(require, "overwatch.state")
  if ok and state.is_active() then
    require("overwatch.command").reset()
  end
end

vim.keymap.set("n", "\\n", function()
  close_overwatch()
  vim.cmd("Neotree toggle")
end, { silent = true, noremap = true, desc = "Toggle Neo-tree" })

vim.keymap.set("n", "\\o", function()
  close_neotree()
  vim.cmd("Overwatch")
end, { silent = true, noremap = true, desc = "Toggle Overwatch" })
vim.keymap.set("n", "\\/", ":Commentary<CR>", { silent = true })
vim.keymap.set("n", "\\t", function()
  vim.fn.system({ "open", "-a", "Typora", vim.fn.expand("%:p") })
end, { silent = true, desc = "Open in Typora" })
vim.keymap.set("v", "\\/", ":Commentary<CR>", { silent = true })

-- Telescope keybindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<C-S-^>', '<C-^>', { desc = 'Toggle alternate buffer' })

-- Overwatch hunk navigation
vim.keymap.set('n', ']h', function() require('overwatch.navigation').next_hunk() end, { desc = 'Next hunk' })
vim.keymap.set('n', '[h', function() require('overwatch.navigation').previous_hunk() end, { desc = 'Previous hunk' })

vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

-- LSP keybindings
vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Open Overwatch when nvim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
      vim.cmd("Overwatch")
    end
  end,
})
