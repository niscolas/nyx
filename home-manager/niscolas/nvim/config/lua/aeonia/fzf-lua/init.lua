local M = {}

local setup_keymap = function()
    local keymap = require("aeonia.fzf-lua.keymap")
    keymap._setup_core_keymap()
    require("aeonia.lsp.handlers").add_post_on_attach_callback(
        keymap._setup_lsp_keymap
    )
end

local get_fzf_colors = function()
    local result =
        require("aeonia.themes").call_from_theme("fzf_lua_get_fzf_colors")
    return result
end

local get_hl = function()
    local result = require("aeonia.themes").call_from_theme("fzf_lua_get_hl")
    return result
end

M.init = function()
    setup_keymap()
end

M.setup = function()
    local fzf_colors = get_fzf_colors()
    local hl = get_hl()

    require("fzf-lua").setup {
        fzf_colors = fzf_colors,
        keymap = {
            fzf = {
                ["tab"] = "down",
                ["shift-tab"] = "up",
                ["ctrl-n"] = "toggle+down",
                ["ctrl-p"] = "toggle+up",
            },
        },
        winopts = {
            hl = hl,
        },
    }

    require("fzf-lua").register_ui_select()
end

return M
