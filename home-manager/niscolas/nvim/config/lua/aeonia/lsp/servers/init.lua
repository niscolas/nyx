local M = {}

local process_enabled_servers = function()
    local servers = require("neoconf").get("lsp.servers", {})

    for server_name, server_settings in pairs(servers) do
        if server_settings.enabled then
            M.settings[server_name] = server_settings
        end
    end
end

local process_ensure_installed_servers = function()
    for server_name, server_settings in pairs(M.settings) do
        if server_settings.ensure_installed then
            table.insert(M.ensure_installed_servers_settings, server_name)
        end
    end
end

M.ensure_installed_servers_settings = {}
M.install_path = fn.stdpath("data") .. "/mason/packages"
M.settings = {}

M.setup = function()
    process_enabled_servers()
    process_ensure_installed_servers()
end

return M
