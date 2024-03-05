local neoai_config = require("aeonia.ai.neoai")

return {
    {
        "Bryley/neoai.nvim",
        cmd = {
            "NeoAI",
            "NeoAIClose",
            "NeoAIContext",
            "NeoAIContextClose",
            "NeoAIContextOpen",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
            "NeoAIOpen",
            "NeoAIToggle",
            "NeoAIShortcut",
        },
        config = neoai_config.setup,
        cond = function()
            -- require("aeonia.core.util").check_is_personal_setup,
            print("neoai cond")
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        keys = neoai_config.lazy_keys,
    },
    {
        "Exafunction/codeium.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup {}
        end,
    },
    {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        cond = require("aeonia.core.util").check_is_personal_setup,
        config = function()
            local tabnine = require("cmp_tabnine.config")

            tabnine:setup {
                max_lines = 1000,
                max_num_results = 20,
                sort = true,
                run_on_every_keystroke = true,
                snippet_placeholder = "..",
                ignored_file_types = {
                    -- default is not to ignore
                    -- uncomment to ignore in lua:
                    -- lua = true
                },
                show_prediction_strength = false,
            }
        end,
        enabled = false,
    },
}
