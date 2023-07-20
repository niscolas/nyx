local M = {}

M.setup = function()
    require("substitute").setup()
    require("aeonia.substitute.keymap")
end

return M
