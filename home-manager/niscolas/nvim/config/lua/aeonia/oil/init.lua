local M = {}

M.keymap = {
    open = {
        mode = "n",
        lhs = "<Leader>e",
        rhs = function()
            require("oil").open()
        end,
        opts = { desc = "Open Oil ([E]xplorer)" },
    },
}

M.setup_keymap = function()
    require("aeonia.core.keymap.util").new_keymap_from_keymap_spec(
        M.keymap.open
    )
end

M.setup = function()
    require("oil").setup {
        columns = {
            "mtime",
            "icon",
            -- "permissions",
            -- "size",
        },
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-s>"] = "actions.select_split",
            ["<C-j>"] = "actions.preview",
            ["<C-c>"] = "actions.close",
            ["<C-l>"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
            ["+"] = {
                callback = function()
                    local oil = require("oil")
                    local file_path = oil.get_current_dir()
                        .. "/"
                        .. oil.get_cursor_entry().name

                    if fn.executable("mimeo") then
                        fn.system { "mimeo", file_path, " &" }
                    elseif fn.executable("xdg-open") then
                        fn.system { "xdg-open", file_path, " &" }
                    end
                end,
            },
        },
        use_default_keymaps = false,
        view_options = {
            show_hidden = true,
        },
    }

    M.setup_keymap()
end

return M
