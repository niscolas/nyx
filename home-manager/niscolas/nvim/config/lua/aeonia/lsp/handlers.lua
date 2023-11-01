local M = {}

local get_capabilities = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local result = cmp_nvim_lsp.default_capabilities()
    result = join_tables_forced(result or {}, {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    })
    result.offsetEncoding = { "utf-16" }

    return result
end

M.post_on_attach_callbacks = {}
M._capabilities = nil

M.setup = function()
    M._capabilities = get_capabilities()
end

M.add_post_on_attach_callback = function(callback)
    table.insert(M.post_on_attach_callbacks, callback)
end

M._on_attach = function(client, bufnr)
    require("aeonia.lsp.keymap")._setup { bufnr = bufnr }

    for _, callback in ipairs(M.post_on_attach_callbacks) do
        callback(client, bufnr)
    end
end

return M
