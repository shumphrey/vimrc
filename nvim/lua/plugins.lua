return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- vim9 style popup for descriptions
  use 'ncm2/float-preview.nvim'

  -- convenience pre-configured lsp configs
  use 'neovim/nvim-lspconfig'
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- colourscheme
  -- use 'vim-airline/vim-airline'
  -- use 'vim-airline/vim-airline-themes'
  -- use {
  --     'lifepillar/vim-solarized8', branch = 'neovim'
  -- }

  use 'tjdevries/colorbuddy.nvim'
  use 'svrana/neosolarized.nvim'



  use 'tpope/vim-scriptease'

  -- Post-install/update hook with neovim command
  -- use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

end)
