local M = {}

M.setup_hl = function()
    local colors = require("aeonia.themes.gruvbox").get_colors_decimal()

    local hl_groups = {
        NavicIconsArray = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsBoolean = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsClass = {
            default = false,
            fg = colors.yellow,
            bg = colors.bg,
        },
        NavicIconsConstant = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsConstructor = {
            default = false,
            fg = colors.blue,
            bg = colors.bg,
        },
        NavicIconsEnum = {
            default = false,
            fg = colors.purple,
            bg = colors.bg,
        },
        NavicIconsEnumMember = {
            default = false,
            fg = colors.yellow,
            bg = colors.bg,
        },
        NavicIconsEvent = {
            default = false,
            fg = colors.yellow,
            bg = colors.bg,
        },
        NavicIconsField = {
            default = false,
            fg = colors.purple,
            bg = colors.bg,
        },
        NavicIconsFile = {
            default = false,
            fg = colors.blue,
            bg = colors.bg,
        },
        NavicIconsFunction = {
            default = false,
            fg = colors.blue,
            bg = colors.bg,
        },
        NavicIconsInterface = {
            default = false,
            fg = colors.green,
            bg = colors.bg,
        },
        NavicIconsKey = { default = false, fg = colors.aqua, bg = colors.bg },
        NavicIconsMethod = {
            default = false,
            fg = colors.blue,
            bg = colors.bg,
        },
        NavicIconsModule = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsNamespace = {
            default = false,
            fg = colors.blue,
            bg = colors.bg,
        },
        NavicIconsNull = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsNumber = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsObject = {
            default = false,
            fg = colors.orange,
            bg = colors.bg,
        },
        NavicIconsOperator = {
            default = false,
            fg = colors.red,
            bg = colors.bg,
        },
        NavicIconsPackage = {
            default = false,
            fg = colors.aqua,
            bg = colors.bg,
        },
        NavicIconsProperty = {
            default = false,
            fg = colors.aqua,
            bg = colors.bg,
        },
        NavicIconsString = {
            default = false,
            fg = colors.green,
            bg = colors.bg,
        },
        NavicIconsStruct = {
            default = false,
            fg = colors.purple,
            bg = colors.bg,
        },
        NavicIconsTypeParameter = {
            default = false,
            fg = colors.red,
            bg = colors.bg,
        },
        NavicIconsVariable = {
            default = false,
            fg = colors.purple,
            bg = colors.bg,
        },
        NavicSeparator = {
            default = false,
            fg = colors.fg,
            bg = colors.bg,
        },
        NavicText = {
            default = false,
            fg = colors.fg,
            bg = colors.bg,
        },
    }

    set_hls(hl_groups)
end

return M
