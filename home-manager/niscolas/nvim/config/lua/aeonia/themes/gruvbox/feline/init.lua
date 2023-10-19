local M = {}

M.vi_mode_colors = {
    NORMAL = "green",
    OP = "green",
    INSERT = "red",
    CONFIRM = "red",
    VISUAL = "blue",
    LINES = "blue",
    BLOCK = "blue",
    REPLACE = "purple",
    ["V-REPLACE"] = "purple",
    ENTER = "aqua",
    MORE = "aqua",
    SELECT = "orange",
    COMMAND = "blue",
    SHELL = "blue",
    TERM = "blue",
    NONE = "yellow",
}

M.default_left_sep = {
    str = "",
}

M.default_right_sep = {
    str = "",
}

M.default_seps = {
    left_sep = M.default_left_sep,
    right_sep = M.default_right_sep,
}

local colors = require("aeonia.themes.gruvbox").get_colors()
local themes_util = require("aeonia.themes.util")

local theme = {}
for color_name, color_decimal_hex in pairs(colors) do
    theme[color_name] = "#"
        .. themes_util.convert_decimal_hex_to_6_digit_hex(color_decimal_hex)
end

M.setup = function()
    local feline = require("feline")

    feline.setup {
        theme = theme,
        vi_mode_colors = M.vi_mode_colors,
        components = require("aeonia.themes.gruvbox.feline.statusbar").components,
        force_inactive = {},
    }

    feline.winbar.setup {
        theme = theme,
        components = require("aeonia.themes.gruvbox.feline.winbar").components,
        force_inactive = {},
    }
end

return M
