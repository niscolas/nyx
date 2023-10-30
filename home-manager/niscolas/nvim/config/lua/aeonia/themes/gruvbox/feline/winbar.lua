local feline_theme = require("aeonia.themes.gruvbox.feline")
local window_number_component =
    require("aeonia.feline.components.core.windor_number")
local usr_file_path_component =
    require("aeonia.feline.components.core.file_path")
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

            join_tables_forced({
                provider = {
                    name = "file_info",
                    opts = {
                        file_readonly_icon = niscolas.icons.lock .. " ",
                        type = "relative-short",
                    },
                },
            }, feline_theme.default_seps),
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

            join_tables_forced(
                usr_file_path_component.simple,
                feline_theme.default_seps
            ),
        },
        {},
        {},
    },
}

return M
