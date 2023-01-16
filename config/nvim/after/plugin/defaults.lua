local keymap = vim.api.nvim_set_keymap

local function keymaps()
  local opts = { noremap = false, silent = true }
  keymap("n", "<leader>t", "<cmd>TestNearest<CR>", opts)
  keymap("n", "<leader>T", "<cmd>TestFile<CR>", opts)
  keymap("n", "<leader>a", "<cmd>TestSuite<CR>", opts)
  keymap("n", "<leader>l", "<cmd>TestLast<CR>", opts)
  keymap("n", "<leader>g", "<cmd>TestVisit<CR>", opts)
end
keymaps()

vim.g["test#strategy"] = "dispatch"

require('lualine').setup {
  sections = {
    lualine_c = {
      {
        'filename',
        path = 1
      }
    },
  },
}

function Go_Imports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end

  vim.lsp.buf.format()
end

function Format_Code()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == "go" then
    Go_Imports(2000)
  else
    vim.lsp.buf.format()
  end
end

local on_attach = function(_, _)
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
          local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

          if filetype == "go" then
            Go_Imports(2000)
          end
          vim.lsp.buf.format()
        end,
	group = vim.api.nvim_create_augroup("lsp_document_format", {clear = true}),
	buffer = 0
})
end
