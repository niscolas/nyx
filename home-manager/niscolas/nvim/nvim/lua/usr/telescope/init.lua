local M = {}

M.setup = function()
    local telescope = require("telescope")
    telescope.setup {
        extensions = {
            fzf = {
                fuzzy = true, -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true, -- override the file sorter
                case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        },
    }
    require("telescope").load_extension("fzf")

    -- local usr_telescope_core = require("usr.telescope.core")
    --
    -- telescope.setup(usr_telescope_core.setup_opts)
    --
    -- require("usr.telescope.commands")
    -- require("usr.telescope.keymap").load_core_keymap()
    --
    -- telescope.load_extension("fzf")
    --
    -- require("usr.telescope.keymap").load_extensions_keymap()
    --
    -- require("usr.lsp.handlers").add_post_on_attach_callback(
    --     require("usr.telescope.keymap").setup_lsp_on_attach_keymap
    -- )
end

return M
