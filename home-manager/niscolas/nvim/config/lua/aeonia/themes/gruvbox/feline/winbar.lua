local feline_theme = require("aeonia.themes.gruvbox.feline")
local window_number_component =
    require("aeonia.feline.components.core.windor_number")
local usr_spacer_component = require("aeonia.feline.components.core.spacer")

local M = {}

M.components = {
    active = {
        {
            join_tables_forced(
                window_number_component,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "yellow",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            usr_spacer_component,

            {
                provider = {
                    name = "file_info",
                    opts = {
                        file_readonly_icon = niscolas.icons.lock .. " ",
                        type = "unique",
                    },
                },
            },
        },
        {},
        {},
    },
    inactive = {
        {
            join_tables_forced(
                window_number_component,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "blue",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            usr_spacer_component,

            {
                provider = {
                    name = "file_info",
                    opts = {
                        file_readonly_icon = niscolas.icons.lock .. " ",
                        type = "unique-short",
                    },
                },
            },
        },
        {},
        {},
    },
}

return M
