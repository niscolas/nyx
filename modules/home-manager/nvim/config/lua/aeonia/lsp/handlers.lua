local M = {}

local process_capabilities = function()
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

M.capabilities = nil
M.post_on_attach_callbacks = {}

M.setup = function()
    M.capabilities = process_capabilities()
end

M.on_attach = function(client, bufnr)
    require("aeonia.lsp.keymap").setup(client, bufnr)
end

return M
