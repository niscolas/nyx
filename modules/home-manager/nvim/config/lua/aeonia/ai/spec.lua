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
        "jcdickinson/codeium.nvim",
        commit = "b1ff0d6c993e3d87a4362d2ccd6c660f7444599f",
        cond = require("aeonia.core.util").check_is_personal_setup,
        config = true,
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",

            {
                "jcdickinson/http.nvim",
                build = "cargo build --workspace --release",
            },
        },
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
