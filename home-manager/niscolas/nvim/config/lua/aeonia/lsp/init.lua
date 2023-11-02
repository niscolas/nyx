local M = {}

M.setup = function()
    require("aeonia.lsp.servers").setup()
    require("aeonia.lsp.diagnostics").setup()
    require("aeonia.lsp.handlers").setup()
    require("aeonia.lsp.lsp_config").setup()
end

return M
