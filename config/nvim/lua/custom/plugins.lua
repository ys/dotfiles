return function(use)
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  use 'reedes/vim-colors-pencil'
  use 'subnut/vim-iawriter'
  -- testing
  use "vim-test/vim-test"
  use "tpope/vim-dispatch"
  -- golang
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- github copilot
  use "github/copilot.vim"
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use {'edluffy/hologram.nvim' }
  use 'hashivim/vim-terraform'
end
