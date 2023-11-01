local M = {}

M.keymap = {
    toggle = {
        mode = "n",
        lhs = "<Leader>u",
        rhs = function()
            cmd("UndotreeToggle")
        end,
        opts = { desc = "[U]ndo Tree Toggle" },
    },
}

M.setup = function()
    require("aeonia.core.keymap.util").new_keymap_from_keymap_spec(
        M.keymap.toggle
    )
end

return M
