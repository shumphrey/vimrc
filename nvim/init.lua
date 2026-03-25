-- source the shared vim/nvim configs
-- shared plugins, mappings, config, theme
vim.cmd('source ~/.vim/vimrc')

vim.g.mapleader = ' '


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
    enabled = false,
    auto_trigger = false,
  },
  panel = {
    enabled = false,
    auto_refresh = false,
  },
})

require("copilot_cmp").setup()

local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    completion = {
      winhighlight = "Normal:Pmenu",
      -- col_offset = -3,
      -- side_padding = 0,
    },
    documentation = {
      border = "single",
      -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      winhighlight = "Normal:Pmenu",
      -- col_offset = -3,
      -- side_padding = 100,
    }
  },
  mapping = cmp.mapping.preset.insert({
    -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  formatting = {
    format = lspkind.cmp_format(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp', group_index = 2 },
    { name = "copilot", group_index = 2 },
    -- random words from the buffer
    -- { name = 'buffer', group_index = 2 },
  }),
})


-- lspkind.lua
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})


-- Stop copilot from suggesting things whilst I have the completion menu opened
cmp.event:on("menu_opened", function()
    vim.b.copilot_suggestion_hidden = true
end)
cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

-- set the Copilot type string to be a different colour
-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})

vim.api.nvim_set_hl(0, "Pmenu", { bg = "#586e75", fg = "#eee8d5" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#2aa198", fg = "#073642" })

vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#839496" })

-- Make LSP hover be more visible
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#586e75" })
