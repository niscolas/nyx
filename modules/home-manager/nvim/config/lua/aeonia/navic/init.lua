local M = {}

M.setup = function()
    local navic = require("nvim-navic")
    local themes = require("aeonia.themes")

    local highlight = themes.get_from_theme("navic_should_highlight", true)

    navic.setup {
        highlight = highlight,
        separator = " " .. niscolas.icons.right_arrow .. " ",
        depth_limit = 0,
        depth_limit_indicator = niscolas.icons.three_dots,
        safe_output = true,
        lsp = {
            auto_attach = true,
        },
    }

    themes.call_from_theme("navic_setup_hl")
end

return M
