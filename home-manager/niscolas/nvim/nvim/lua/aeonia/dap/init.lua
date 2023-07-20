local M = {}

M.setup = function()
    require("aeonia.dap.core").setup()
    require("aeonia.dap.keymap")
    require("aeonia.dap.virtual_text")
    require("aeonia.dap.dap-ui")
    require("aeonia.dap.core").setup_debuggers()
end

return M
