local M = {}

M.setup_hl = function()
    local elements = require("aeonia.navic.util").hl_groups
    local colors = require("aeonia.themes.gruvbox-flat").colors
    local default_hl = get_hl("Function", true)

    for _, element in ipairs(elements) do
        local element_hl_ok, element_hl = pcall(get_hl, element, true)

        if not element_hl_ok then
            element_hl = default_hl
        end

        set_hl(
            0,
            "NavicIcons" .. element,
            { default = true, fg = element_hl.foreground, bg = colors.bg }
        )
    end

    set_hl(0, "NavicText", { default = true, fg = colors.fg, bg = colors.bg })
    set_hl(
        0,
        "NavicSeparator",
        { default = true, fg = colors.fg, bg = colors.bg }
    )
end

return M
