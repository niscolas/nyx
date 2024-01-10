local M = {}

M.keymap_opts = { silent = true }

M.keymap = {
    del = {
        mode = "n",
        lhs = "<Leader>qq",
        rhs = ":BufDel<CR>",
        opts = M.keymap_opts,
    },
    del_force = {
        mode = "n",
        lhs = "<Leader>qf",
        rhs = ":BufDel!<CR>",
        opts = M.keymap_opts,
    },
    del_all = {
        mode = "n",
        lhs = "<Leader>qaa",
        rhs = ":BufDelAll<CR>",
        opts = M.keymap_opts,
    },
    del_all_force = {
        mode = "n",
        lhs = "<Leader>qaf",
        rhs = ":BufDelAll!<CR>",
        opts = M.keymap_opts,
    },
    del_others = {
        mode = "n",
        lhs = "<Leader>qoo",
        rhs = ":BufDelOthers<CR>",
        opts = M.keymap_opts,
    },
    del_others_force = {
        mode = "n",
        lhs = "<Leader>qof",
        rhs = ":BufDelOthers!<CR>",
        opts = M.keymap_opts,
    },
}

M.setup_keymap = function()
    require("aeonia.core.keymap.util").new_keymaps_from_keymap_spec_list(
        M.keymap
    )
end

M.setup = function()
    require("bufdel").setup()
    M.setup_keymap()
end

return M
