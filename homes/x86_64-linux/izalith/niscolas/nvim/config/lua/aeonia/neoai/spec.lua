local config = require("aeonia.neoai")

return {
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
    config = config.setup,
    cond = require("aeonia.core.util").check_is_personal_setup,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    keys = {
        {
            config.shortcuts_config.gitcommit.keys,
            desc = config.shortcuts_config.gitcommit.desc,
        },
        {
            config.shortcuts_config.summarize_text.keys,
            desc = config.shortcuts_config.summarize_text.desc,
        },
    },
}
