local M = {}

local function override_server_opts(default_server_opts, server)
    server = "lsp.servers." .. server
    local server_opts = require("aeonia." .. server)

    return join_tables_forced(default_server_opts, server_opts)
end

local function get_default_opts(handlers)
    local result = {
        on_attach = handlers.on_attach,
        capabilities = handlers.capabilities,
    }

    return result
end

local function get_server_custom_opts(server, servers, handlers)
    local default_opts = get_default_opts(handlers)

    if servers[server] then
        default_opts = override_server_opts(default_opts, server)
    end

    return default_opts
end

M.setup = function()
    local lspconfig = require("lspconfig")
    local lsp_servers_mod = require("aeonia.lsp.servers")
    local lsp_handlers_mod = require("aeonia.lsp.handlers")

    for server, config in pairs(lsp_servers_mod.settings) do
        local opts

        if config.has_custom_config then
            opts = get_server_custom_opts(
                server,
                lsp_servers_mod.settings,
                lsp_handlers_mod
            )
        else
            opts = get_default_opts(lsp_handlers_mod)
        end

        lspconfig[server].setup(opts)
    end
end

return M
