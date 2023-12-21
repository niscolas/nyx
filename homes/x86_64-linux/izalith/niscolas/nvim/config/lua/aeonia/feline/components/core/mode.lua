local vi_mode_provider = require("feline.providers.vi_mode")

return {
    provider = function()
        local mode = vi_mode_provider.get_vim_mode()
        return mode
    end,
    hl = function()
        return {
            name = vi_mode_provider.get_mode_highlight_name(),
            bg = vi_mode_provider.get_mode_color(),
            fg = "bg",
        }
    end,
}
