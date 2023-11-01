local M = {}

M.formatters = require("aeonia.lsp.format")._formatters

M.get_ensure_installed_servers = function()
    local servers_mod = require("aeonia.lsp.servers")

    for server, config in pairs(servers_mod.settings) do
        if config.ensure_installed then
            table.insert(servers_mod.ensure_installed_servers, server)
        end
    end

    return servers_mod.ensure_installed_servers
end

M.setup = function()
    require("aeonia.lsp.diagnostics").setup()
    require("aeonia.lsp.handlers").setup()
    require("aeonia.lsp.lsp_config").setup()
end

return M
