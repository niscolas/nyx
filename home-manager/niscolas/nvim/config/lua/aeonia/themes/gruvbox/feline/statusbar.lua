local feline_theme = require("aeonia.themes.gruvbox.feline")
local file_info_component = require("aeonia.feline.components.core.file_info")
local git_component = require("aeonia.feline.components.core.git")
local lsp_component = require("aeonia.feline.components.core.lsp")
local mode_component = require("aeonia.feline.components.core.mode")
local noice_component = require("aeonia.feline.components.core.noice")
local spacer_component = require("aeonia.feline.components.core.spacer")
local navic_component = require("aeonia.feline.components.core.navic")

local M = {}

M.components = {
    active = {
        {
            join_tables_forced(mode_component, feline_theme.default_seps),

            spacer_component,

            join_tables_forced(
                git_component.branch,
                feline_theme.default_seps,
                {

                    hl = {
                        bg = "yellow",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(git_component.diff_added, {
                hl = {
                    fg = "green",
                    style = "bold",
                },
            }),

            join_tables_forced(git_component.diff_changed, {
                hl = {
                    fg = "aqua",
                    style = "bold",
                },
            }),

            join_tables_forced(git_component.diff_removed, {
                hl = {
                    fg = "red",
                    style = "bold",
                },
            }),

            {
                provider = feline_theme.default_right_sep.str,
                enabled = git_component.branch.enabled,
                hl = {
                    bg = "yellow",
                    fg = "bg",
                },
            },

            {
                provider = feline_theme.default_right_sep.str,
                enabled = git_component.branch.enabled,
                hl = {
                    fg = "yellow",
                },
            },

            spacer_component,

            join_tables_forced(
                lsp_component.client_names,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "purple",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(lsp_component.diagnostic_errors, {
                hl = {
                    fg = "red",
                    style = "bold",
                },
            }),

            join_tables_forced(lsp_component.diagnostic_warnings, {
                hl = {
                    fg = "yellow",
                    style = "bold",
                },
            }),

            join_tables_forced(lsp_component.diagnostic_info, {
                hl = {
                    fg = "blue",
                    style = "bold",
                },
            }),

            join_tables_forced(lsp_component.diagnostic_hints, {
                hl = {
                    fg = "aqua",
                    style = "bold",
                },
            }),

            {
                provider = feline_theme.default_right_sep.str,
                enabled = lsp_component.client_names.enabled,
                hl = {
                    bg = "purple",
                    fg = "bg",
                },
            },

            {
                provider = feline_theme.default_right_sep.str,
                enabled = lsp_component.client_names.enabled,
                hl = {
                    fg = "purple",
                },
            },

            join_tables_forced(spacer_component, {
                enabled = lsp_component.client_names.enabled,
            }),

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
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(spacer_component, {
                enabled = noice_component.search.enabled,
            }),

            spacer_component,

            join_tables_forced(
                file_info_component,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "orange",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),
        },
    },
    inactive = {},
}

return M
