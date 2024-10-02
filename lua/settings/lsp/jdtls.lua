local M = {}

local jdtls = require("jdtls")
local cmp_lsp = require("cmp_nvim_lsp")

local share_dir = os.getenv("HOME") .. "/.local/share"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = share_dir .. "/workspace/" .. project_name

local mason_registry = require("mason-registry")

M.get_config = function()
    -- vim.fn.glob Is needed to set paths using wildcard (*)
    local bundles = {
        -- vim.fn.glob(
        --     mason_registry.get_package("java-debug-adapter"):get_install_path()
        --         .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"
        -- ),
    }

    -- vim.list_extend(
    --     bundles,
    --     vim.split(
    --         vim.fn.glob(mason_registry.get_package("java-test"):get_install_path() .. "/extension/server/*.jar"),
    --         "\n"
    --     )
    -- )

    local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()
    local lombok_path = jdtls_path .. "/lombok.jar"

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    return {
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-javaagent:" .. lombok_path,
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            jdtls_path .. "/config_linux",
            "-data",
            workspace_dir,
        },
        flags = {
            debounce_text_changes = 150,
            allow_incremental_sync = true,
        },
        handlers = {},
        -- on_init = function(client)
        --     if client.config.settings then
        --         client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        --     end
        -- end,

        init_options = {
            provideFormatter = false,
            bundles = {},
        },
        on_attach = function()
            vim.opt.tabstop = 4
            vim.opt.softtabstop = 4
            vim.opt.shiftwidth = 4
            vim.opt.expandtab = true
            -- TODO: not working
            -- require("which-key").register({
            --     ["<leader>de"] = { "<cmd>DapContinue<cr>", "[JDLTS] Show debug configurations" },
            --     ["<leader>ro"] = {
            --         "<cmd>lua require'jdtls'.organize_imports()<cr>",
            --         "[JDLTS] Organize imports",
            --     },
            -- })
            -- jdtls = require("jdtls")
            -- jdtls.setup_dap({ hotcodereplace = "auto" })
            -- jdtls.setup.add_commands()
            -- -- Auto-detect main and setup dap config
            -- require("jdtls.dap").setup_dap_main_class_configs({
            --     config_overrides = {
            --         vmArgs = "-Dspring.profiles.active=local",
            --     },
            -- })
        end,
        settings = {
            java = {
                configuration = {
                    updateBuildConfiguration = "interactive",
                    runtimes = {
                        {
                            name = "JavaSE-1.8",
                            path = "/usr/lib/jvm/java-8-openjdk/",
                        },
                        {
                            name = "JavaSE-17",
                            path = "/usr/lib/jvm/java-17-openjdk/",
                        },
                        {
                            name = "JavaSE-21",
                            path = "/usr/lib/jvm/java-21-openjdk/",
                        },
                    },
                },
                format = {
                    enabled = false,
                },
                signatureHelp = {
                    enabled = true,
                },
                saveActions = {
                    organizeImports = true,
                },
                eclipse = {
                    downloadSources = true,
                },
                maven = {
                    downloadSources = true,
                },
                implementationsCodeLens = {
                    enabled = true,
                },
                referencesCodeLens = {
                    enabled = true,
                },
                references = {
                    includeDecompiledSources = true,
                },
                inlayHints = {
                    parameterNames = {
                        enabled = "all",
                    },
                },
                completion = {
                    maxResults = 20,
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticStarThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    },
                    useBlocks = true,
                },
                trace = {
                    server = "verbose",
                },
            },
        },
    }
end

return M
