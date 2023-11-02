local M = {}

local process_ensure_installed_servers = function()
    for server_name, server_settings in pairs(M.settings) do
        if server_settings.ensure_installed then
            table.insert(M.ensure_installed_servers_settings, server_name)
        end
    end
end

M.ensure_installed_servers_settings = {}
M.install_path = fn.stdpath("data") .. "/mason/packages"
M.settings = require("neoconf").get("lsp.servers")

M.setup = function()
    process_ensure_installed_servers()
end

return M
