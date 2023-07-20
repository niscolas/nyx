local M = {}

M.setup_hl = function()
    local colors = require("aeonia.themes.gruvbox").get_colors()
    local usr_theme_util = require("aeonia.themes.util")
    local get_fg_from = usr_theme_util.get_fg_from

    local hl_groups = {
        NavicIconsArray = {
            fg = get_fg_from("NavicIconsArray", true),
            bg = colors.bg,
        },
    }

    set_hls(hl_groups)
end

return M
