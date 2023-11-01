local feline_theme = require("aeonia.themes.gruvbox.feline")
local git_component = require("aeonia.feline.components.core.git")
local lsp_component = require("aeonia.feline.components.core.lsp")
local noice_component = require("aeonia.feline.components.core.noice")
local spacer_component = require("aeonia.feline.components.core.spacer")
local navic_component = require("aeonia.feline.components.core.navic")

local M = {}

M.components = {
    active = {
        {

            {
                provider = "  ",
                hl = function()
                    return {
                        fg = "bg",
                        bg = require("feline.providers.vi_mode").get_mode_color(),
                    }
                end,
                right_sep = feline_theme.default_right_sep,
            },

            spacer_component,

            navic_component,

            spacer_component,
        },

        {
            noice_component.mode,

            join_tables_forced(spacer_component, {
                enabled = noice_component.mode.enabled,
            }),

            join_tables_forced(
                noice_component.search,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "red",
                        fg = "bg",
                    },
                }
            ),

            join_tables_forced(spacer_component, {
                enabled = noice_component.search.enabled,
            }),

            spacer_component,

            {
                icon = niscolas.icons.branch .. " ",
                provider = git_component.branch.provider,
                enabled = git_component.branch.enabled,
                hl = {
                    fg = "yellow",
                },
            },

            spacer_component,

            {
                provider = niscolas.icons.gear .. " ",
                enabled = lsp_component.any_diagnostic.enabled,
                left_sep = feline_theme.default_left_sep,
                hl = {
                    bg = "purple",
                    fg = "bg",
                },
            },

            {
                provider = lsp_component.diagnostic_errors.provider,
                enabled = lsp_component.diagnostic_errors.enabled,
                hl = {
                    fg = "red",
                },
            },

            {
                provider = lsp_component.diagnostic_warnings.provider,
                enabled = lsp_component.diagnostic_warnings.enabled,
                hl = {
                    fg = "yellow",
                },
            },

            {
                provider = lsp_component.diagnostic_info.provider,
                enabled = lsp_component.diagnostic_info.enabled,
                hl = {
                    fg = "blue",
                },
            },

            {
                provider = lsp_component.diagnostic_hints.provider,
                enabled = lsp_component.diagnostic_hints.enabled,
                hl = {
                    fg = "aqua",
                },
            },

            {
                provider = spacer_component.provider,
                enabled = lsp_component.client_names.enabled,
            },

            {
                icon = niscolas.icons.file,
                provider = " ",
                left_sep = feline_theme.default_left_sep,
                hl = {
                    bg = "orange",
                    fg = "bg",
                },
            },

            spacer_component,

            {
                provider = "file_format",
                hl = {
                    fg = "orange",
                },
            },

            spacer_component,

            {
                provider = "file_encoding",
                hl = {
                    fg = "orange",
                },
            },

            spacer_component,

            {
                provider = "position",
                hl = {
                    fg = "orange",
                },
            },

            spacer_component,
        },
    },
    inactive = {},
}

return M
