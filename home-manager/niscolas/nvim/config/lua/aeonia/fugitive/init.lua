local M = {}

M.setup_keymap = function()
    new_user_command("Gt", "Git --paginate t <args>", {})
    new_keymap("n", "<leader>gg", ":Git <CR>")
    new_keymap("n", "<leader>gs", ":Ge :<CR>:Git <CR>")
    new_keymap("n", "<leader>gdh", ":Ghdiffsplit<cr>")
    new_keymap("n", "<leader>gdv", ":Gvdiffsplit<cr>")
    new_keymap("n", "<leader>gd", ":Gvdiffsplit<cr>")
    new_keymap("n", "<leader>gdd", ":Gvdiffsplit<cr>")
    new_keymap("n", "<leader>gt", ":Gt<cr>")
end

M.setup = function()
    M.setup_keymap()
end

return M
