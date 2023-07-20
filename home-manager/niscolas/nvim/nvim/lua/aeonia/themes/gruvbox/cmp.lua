local M = {}

M.setup_hl = function()
    local colors = require("aeonia.themes.gruvbox").get_colors()

    local hls = {
        CmpItemMenu = { fg = colors.purple, italic = true },
    }

    set_hls(hls)
end

return M
