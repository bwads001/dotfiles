-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Navigation and search
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols (Document)" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Symbols (Workspace)" })

-- LSP
map("n", "ga", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "gr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Goto Type" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Diagnostics (Buffer)" })

-- Refactor
map({ "n", "x" }, "<leader>rr", function()
  require("refactoring").select_refactor()
end, { desc = "Refactor" })

-- Harpoon
map("n", "<leader>a", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon Add" })
map("n", "<leader>H", function()
  require("harpoon"):list():toggle_quick_menu()
end, { desc = "Harpoon Menu" })
map("n", "<leader>1", function()
  require("harpoon"):list():select(1)
end, { desc = "Harpoon 1" })
map("n", "<leader>2", function()
  require("harpoon"):list():select(2)
end, { desc = "Harpoon 2" })
map("n", "<leader>3", function()
  require("harpoon"):list():select(3)
end, { desc = "Harpoon 3" })
map("n", "<leader>4", function()
  require("harpoon"):list():select(4)
end, { desc = "Harpoon 4" })
