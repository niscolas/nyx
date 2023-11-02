local M = {}

local setup_keymap = function()
    new_keymap("n", "<Leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
end

M.setup = function()
    require("inc_rename").setup()
    print("inc rename")
    setup_keymap()
end

return M
