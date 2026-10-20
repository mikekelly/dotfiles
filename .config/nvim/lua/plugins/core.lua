-- Plugins carried over from the pre-LazyVim config, plus overrides of
-- LazyVim defaults that would otherwise shadow existing muscle memory.
return {
  -- Kept from the old config
  { "vim-scripts/BufOnly.vim" },
  { "tidalcycles/vim-tidal", ft = "tidal" },
  { "tpope/vim-fugitive" },
  { "easymotion/vim-easymotion" },
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "tpope/vim-unimpaired" },
  { "tpope/vim-abolish" },
  { "godlygeek/tabular" },
  { "mbbill/undotree" },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- Replaced by the plugins above: flash takes s/S, mini.pairs duplicates autopairs
  { "folke/flash.nvim", enabled = false },
  { "nvim-mini/mini.pairs", enabled = false },

  -- Overwatch opens on an empty start instead of the dashboard
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
  {
    "mikekelly/overwatch.nvim",
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
            vim.cmd("Overwatch")
          end
        end,
      })
    end,
  },

  -- Gitsigns sets buffer-local ]h/[h; point them at Overwatch instead
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        if on_attach then
          on_attach(buffer)
        end
        vim.keymap.set("n", "]h", function() require("overwatch.navigation").next_hunk() end, { buffer = buffer, desc = "Next hunk" })
        vim.keymap.set("n", "[h", function() require("overwatch.navigation").previous_hunk() end, { buffer = buffer, desc = "Previous hunk" })
      end
    end,
  },

  -- Old finder bindings; <leader><space> is freed for easymotion's <leader><leader> prefix
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><space>", false },
      { "<C-p>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    },
  },

  -- Treesitter moves would take unimpaired's [a/[f and diff mode's [c
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      opts.move.keys = {}
    end,
  },

  -- Unimpaired owns todo-comments' ]t/[t
  {
    "folke/todo-comments.nvim",
    keys = {
      { "]t", false },
      { "[t", false },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.disabled_filetypes = opts.options.disabled_filetypes or {}
      opts.options.disabled_filetypes.statusline = vim.list_extend(
        opts.options.disabled_filetypes.statusline or {},
        { "neo-tree", "overwatch_tree", "overwatch_hunk" }
      )
      opts.sections.lualine_c = { { "filename", path = 3 } }
    end,
  },
}
