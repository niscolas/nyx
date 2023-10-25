local M = {}

M.setup = function()
    local navic = require("nvim-navic")

    navic.setup {
        highlight = true,
        separator = " " .. niscolas.icons.right_arrow .. " ",
        depth_limit = 0,
        depth_limit_indicator = niscolas.icons.three_dots,
        safe_output = true,
        lsp = {
            auto_attach = true,
        },
    }

    local setup_hl = require("aeonia.themes").get_field("navic_setup_hl")
    setup_hl()
end

return M