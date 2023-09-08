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

require("nvim-tree").setup({
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn",
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = true,
      },
    },
  },
})

vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<CR>", opts)

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]


local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

require("go").setup()

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])

vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])
