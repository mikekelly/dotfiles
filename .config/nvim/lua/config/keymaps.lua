-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Everything here preserves bindings from the pre-LazyVim config.

local map = vim.keymap.set

-- LazyVim defaults that shadow plain vim / vim-unimpaired behaviour
for _, lhs in ipairs({ "H", "L", "n", "N" }) do
  pcall(vim.keymap.del, { "n", "x", "o" }, lhs)
end
map("n", "[b", "<Plug>(unimpaired-bprevious)", { desc = "Previous buffer" })
map("n", "]b", "<Plug>(unimpaired-bnext)", { desc = "Next buffer" })
map("n", "[q", "<Plug>(unimpaired-cprevious)", { desc = "Previous quickfix" })
map("n", "]q", "<Plug>(unimpaired-cnext)", { desc = "Next quickfix" })
map("n", "[e", "<Plug>(unimpaired-move-up)", { desc = "Move line up" })
map("n", "]e", "<Plug>(unimpaired-move-down)", { desc = "Move line down" })

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

map("n", "\\n", function()
  close_overwatch()
  vim.cmd("Neotree toggle")
end, { silent = true, desc = "Toggle Neo-tree" })

map("n", "\\o", function()
  close_neotree()
  vim.cmd("Overwatch")
end, { silent = true, desc = "Toggle Overwatch" })

map({ "n", "v" }, "\\/", ":Commentary<CR>", { silent = true, desc = "Toggle comment" })

if vim.fn.has("mac") == 1 then
  map("n", "\\t", function()
    vim.fn.system({ "open", "-a", "Typora", vim.fn.expand("%:p") })
  end, { silent = true, desc = "Open in Typora" })
end

map("n", "<C-S-^>", "<C-^>", { desc = "Toggle alternate buffer" })

-- Global fallbacks for buffers without gitsigns (e.g. Overwatch's own buffers)
map("n", "]h", function() require("overwatch.navigation").next_hunk() end, { desc = "Next hunk" })
map("n", "[h", function() require("overwatch.navigation").previous_hunk() end, { desc = "Previous hunk" })

-- LSP
map("n", "<C-]>", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
