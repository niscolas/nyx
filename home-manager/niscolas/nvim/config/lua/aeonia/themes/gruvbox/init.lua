local M = {}

M.contrast = "soft"

M.get_colors = function()
    -- local result = require("gruvbox").palette
    local themes_util = require("aeonia.themes.util")

    local result = {
        bg = themes_util.get_fg_from("GruvboxBg0"),
        fg = themes_util.get_fg_from("GruvboxFg0"),

        aqua = themes_util.get_fg_from("GruvboxAqua"),
        blue = themes_util.get_fg_from("GruvboxBlue"),
        green = themes_util.get_fg_from("GruvboxGreen"),
        orange = themes_util.get_fg_from("GruvboxOrange"),
        purple = themes_util.get_fg_from("GruvboxPurple"),
        red = themes_util.get_fg_from("GruvboxRed"),
        yellow = themes_util.get_fg_from("GruvboxYellow"),
    }

    return result
end

M.setup = function()
    local themes = require("aeonia.themes")
    themes.theme_mod = require("aeonia.themes.gruvbox")

    require("gruvbox").setup {
        contrast = M.contrast,
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
    }

    cmd.colorscheme("gruvbox")

    themes.force_background_transparency()

    local colors = M.get_colors()
    set_hl(0, "FloatBorder", { fg = colors.yellow })
end

M.cmp_setup_hl = function()
    require("aeonia.themes.gruvbox.cmp").setup_hl()
end

M.feline_setup = function()
    require("aeonia.themes.gruvbox.feline").setup()
end

M.fzf_lua_get_fzf_colors = function()
    return require("aeonia.themes.gruvbox.fzf_lua").get_fzf_colors()
end

M.fzf_lua_get_hl = function()
    return require("aeonia.themes.gruvbox.fzf_lua").hl
end

M.navic_setup_hl = function()
    require("aeonia.themes.gruvbox.navic").setup_hl()
end

M.noice_setup_hl = function() end

return M
