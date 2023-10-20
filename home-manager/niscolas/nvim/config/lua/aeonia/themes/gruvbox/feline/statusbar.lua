local feline_theme = require("aeonia.themes.gruvbox.feline")
local usr_dir_path_component = require("aeonia.feline.components.core.dir_path")
local usr_feline_util = require("aeonia.feline.util")
local usr_file_info_component =
    require("aeonia.feline.components.core.file_info")
local usr_git_component = require("aeonia.feline.components.core.git")
local usr_lsp_component = require("aeonia.feline.components.core.lsp")
local usr_mode_component = require("aeonia.feline.components.core.mode")
local usr_noice_component = require("aeonia.feline.components.core.noice")
local usr_spacer_component = require("aeonia.feline.components.core.spacer")

local M = {}

M.components = {
    active = {
        {
            join_tables_forced(usr_mode_component, feline_theme.default_seps),

            usr_spacer_component,

            join_tables_forced(
                usr_git_component.branch,
                feline_theme.default_seps,
                {

                    hl = {
                        bg = "yellow",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(usr_git_component.diff_added, {
                hl = {
                    fg = "green",
                    style = "bold",
                },
            }),

            join_tables_forced(usr_git_component.diff_changed, {
                hl = {
                    fg = "aqua",
                    style = "bold",
                },
            }),

            join_tables_forced(usr_git_component.diff_removed, {
                hl = {
                    fg = "red",
                    style = "bold",
                },
            }),

            {
                provider = feline_theme.default_right_sep.str,
                enabled = usr_git_component.branch.enabled,
                hl = {
                    bg = "yellow",
                    fg = "bg",
                },
            },

            {
                provider = feline_theme.default_right_sep.str,
                enabled = usr_git_component.branch.enabled,
                hl = {
                    fg = "yellow",
                },
            },

            usr_spacer_component,

            join_tables_forced(
                usr_lsp_component.client_names,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "purple",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(usr_lsp_component.diagnostic_errors, {
                hl = {
                    fg = "red",
                    style = "bold",
                },
            }),

            join_tables_forced(usr_lsp_component.diagnostic_warnings, {
                hl = {
                    fg = "yellow",
                    style = "bold",
                },
            }),

            join_tables_forced(usr_lsp_component.diagnostic_info, {
                hl = {
                    fg = "blue",
                    style = "bold",
                },
            }),

            join_tables_forced(usr_lsp_component.diagnostic_hints, {
                hl = {
                    fg = "aqua",
                    style = "bold",
                },
            }),

            {
                provider = feline_theme.default_right_sep.str,
                enabled = usr_lsp_component.client_names.enabled,
                hl = {
                    bg = "purple",
                    fg = "bg",
                },
            },

            {
                provider = feline_theme.default_right_sep.str,
                enabled = usr_lsp_component.client_names.enabled,
                hl = {
                    fg = "purple",
                },
            },

            join_tables_forced(usr_spacer_component, {
                enabled = usr_lsp_component.client_names.enabled,
            }),
        },

        {
            usr_noice_component.mode,

            join_tables_forced(usr_spacer_component, {
                enabled = usr_noice_component.mode.enabled,
            }),

            join_tables_forced(
                usr_noice_component.search,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "red",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            join_tables_forced(usr_spacer_component, {
                enabled = usr_noice_component.search.enabled,
            }),

            join_tables_forced(
                usr_dir_path_component,
                feline_theme.default_seps,
                {
                    hl = {
                        bg = "aqua",
                        fg = "bg",
                        style = "bold",
                    },
                }
            ),

            usr_spacer_component,

            join_tables_forced(
                usr_file_info_component,
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
