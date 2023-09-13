return function(use)
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  use 'reedes/vim-colors-pencil'
  use 'subnut/vim-iawriter'
  -- testing
  use "vim-test/vim-test"
  use "tpope/vim-dispatch"
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- github copilot
  use "github/copilot.vim"
end
