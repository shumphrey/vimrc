-- -----------------------------------------------------------------
-- See ~/.config/nvim/install_lsp.sh for installing language servers
-- -----------------------------------------------------------------

-- provided by nvim-lspconfig
-- vim.lsp.config("ty", {
--     settings = {
--         ty = {
--         }
--     }
-- })
vim.lsp.enable('ty')


vim.lsp.config('basedpyright', {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        -- typeCheckingMode = "standard", -- "off", "basic", or "strict"
        -- prefer ty for type checking
        -- does this do anything now?
        typeCheckingMode = "off",
      }
    },
  }
})

-- astral/ty for type checking
-- vim.lsp.enable('basedpyright')
-- ruff for linting and formatting
vim.lsp.enable('ruff')

vim.lsp.enable 'bashls'

-- typescript lsp
-- npm install -g typescript-language-server
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
  on_attach = function(client, bufnr)
    -- I don't like the way this mangles my colours
    client.server_capabilities.semanticTokensProvider = nil
  end,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" }
})

-- npm i -g vscode-langservers-extracted
-- nodenv rehash
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
local schemas = {
    {
        description = "NPM configuration file",
        fileMatch = {
            "package.json",
        },
        url = "https://json.schemastore.org/package.json",
    },
    {
        description = "Json schema for properties json file for a GitHub Workflow template",
        fileMatch = {
            ".github/workflow-templates/**.properties.json",
        },
        url = "https://json.schemastore.org/github-workflow-template-properties.json",
    },
    {
        description = "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.",
        fileMatch = {
            "*.cf.json",
            "cloudformation.json",
        },
        url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
    },
    {
        description = "Prettier config",
        fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
        },
        url = "https://json.schemastore.org/prettierrc",
    },
    {
        description = "TypeScript compiler configuration file",
        fileMatch = {
            "tsconfig.json",
            "tsconfig.*.json",
        },
        url = "https://json.schemastore.org/tsconfig.json",
    },
}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.enable('jsonls')
vim.lsp.config('jdtls', {
-- lspconfig.jsonls.setup({
    capabilities = capabilities,
    filetypes = { "json", "jsonc", "json5" },
    settings = {
        json = {
            schemas = schemas,
            single_file_support = true,
        }
    }
})
-- lspconfig.lua_ls.setup{}

--  If you want all the features jdtls has to offer, nvim-jdtls is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions you can keep reading here.
-- lspconfig.jdtls.setup{}
vim.lsp.enable('jdtls')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- usually the import
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- the definition...
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- the implementation, usually the same thing
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.implementation, opts)
    -- type definition
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
