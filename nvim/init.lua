-- source the shared vim/nvim configs
-- shared plugins, mappings, config
vim.cmd('source ~/.vim/vimrc')

vim.g.mapleader = ' '


-- theme stuff
vim.o.termguicolors = true
require('neosolarized').setup({
  comment_italics = true,
})

-- newer syntax highlighting
require("treesitter")

-- Load lsp
require("lsp")



-- nvim specific settings
-- turn off stuff we don't need
-- makes for a healthy :checkhealth
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- docker popup for completefunc descriptions
-- my bbc.vim jira completions with ctrl-x ctrl-u/tab now have their descriptions
-- much like vim9's set completefunc+=popup
vim.cmd('let g:float_preview#docked = 0')


require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
  },
  panel = {
    enabled = true,
    auto_refresh = false,
  },
})
-- require("copilot").setup({
--   suggestion = { enabled = true },
--   panel = { enabled = false },
-- })

local cmp = require'cmp'
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  formatting = {
    format = lspkind.cmp_format(),
  },
  sources = cmp.config.sources({
    -- lsp?
    { name = 'nvim_lsp', group_index = 2 },
    -- Copilot Source
    -- This doesn't seem to work
    { name = "copilot", group_index = 2, keyword_length = 0 },
    -- random words from the buffer
    -- { name = 'buffer', group_index = 2 },
  })
})
