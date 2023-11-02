local M = {}

M.extra_ensure_installed = {}

M.setup = function()
    local mason = require("mason")

    mason.setup()

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup {
        ensure_installed = require("aeonia.lsp.servers").ensure_installed_servers_settings,
    }
end

return M
