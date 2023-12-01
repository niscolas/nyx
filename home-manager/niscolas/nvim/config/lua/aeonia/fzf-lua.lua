local M = {}

local setup_core_keymap = function()
    new_keymap(
        "n",
        "<C-p>",
        require("fzf-lua").files,
        { desc = "Fzf-Lua [P]roject Files" }
    )

    new_keymap(
        "n",
        "<C-b>",
        require("fzf-lua").buffers,
        { desc = "Fzf-Lua [B]uffers" }
    )

    new_keymap(
        "n",
        "<C-f>",
        require("fzf-lua").grep,
        { desc = "Fzf-Lua Grep ([F]ind)" }
    )

    new_keymap(
        "n",
        "<Leader>fr",
        require("fzf-lua").resume,
        { desc = "Fzf-Lua [F]ind [R]esume" }
    )

    new_keymap(
        "n",
        "<Leader>fo",
        require("fzf-lua").oldfiles,
        { desc = "Fzf-Lua [F]ind [O]ld Files" }
    )
end

local setup_lsp_keymap = function()
    new_keymap("n", "gd", function()
        require("fzf-lua").lsp_definitions { jump_to_single_result = true }
    end, { desc = "Fzf-Lua [G]o to [D]efinition" })

    new_keymap(
        "n",
        "<Leader>fs",
        require("fzf-lua").lsp_document_symbols,
        { desc = "[F]ind [S]ymbols" }
    )

    new_keymap("n", "<Leader>fu", function()
        require("fzf-lua").lsp_references {
            jump_to_single_result = true,
            ignore_current_line = true,
        }
    end, { desc = "Fzf-Lua [F]ind [U]sages / References" })

    new_keymap(
        "n",
        "<Leader>fi",
        require("fzf-lua").lsp_implementations,
        { desc = "Fzf-Lua [F]ind [I]mplementations" }
    )
end
local setup_keymap = function()
    setup_core_keymap()

    new_autocmd("LspAttach", {
        callback = function()
            setup_lsp_keymap()
        end,
    })
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
        winopts = {
            hl = hl,
        },
    }

    require("fzf-lua").register_ui_select()
end

return M
