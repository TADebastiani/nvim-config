local ensure_installed = {
    "bashls",
    "beautysh",
    "stylua",
    "lua_ls",
    "tsserver",
    "jdtls",
}

local on_attach = function(client)
    if client.supports_method("textDocument/formatting") then
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        priority = 100,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "mfussenegger/nvim-jdtls",
        },
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")
            local jdtls_settings = require("settings.lsp.jdtls")

            require("mason-lspconfig").setup({
                ensure_installed,
                automatic_installation = true,
                handlers = {
                    function(server)
                        local capabilities = vim.lsp.protocol.make_client_capabilities()
                        capabilities.textDocument.completion.completionItem.snippetSupport = true

                        local config = {
                            capabilities = cmp_lsp.default_capabilities(capabilities),
                        }

                        if server == "jdtls" then
                            config = vim.tbl_deep_extend("keep", config, jdtls_settings.get_config())
                        else
                            config.on_attach = on_attach
                        end

                        lspconfig[server].setup(config)
                    end,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        keys = {
            { "K", vim.lsp.buf.hover },
            { "<leader>ca", vim.lsp.buf.code_action, { "n", "v" } },
            { "<leader>gd", vim.lsp.buf.definition },
            { "<leader>gD", vim.lsp.buf.declaration },
            { "<leader>gi", vim.lsp.buf.implementation },
            { "<leader>rn", vim.lsp.buf.rename },
            { "<leader>e", vim.diagnostic.open_float },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local custom_formatting = require("settings.formatting")
            null_ls.setup({
                debug = true,
                sources = {
                    null_ls.builtins.formatting.stylua,
                    -- Javascript/Typescript
                    --null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.formatting.prettier,
                    custom_formatting.palantir,
                },
                on_attach = on_attach,
            })
        end,
    },
}
