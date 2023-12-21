local M = {}

M.setup_done = false
M.disabled_plugins = nil

M.setup = function()
    local has_neoconf, neoconf = pcall(require, "neoconf")
    if not has_neoconf then
        return true
    end

    if not M.setup_done then
        neoconf.setup()
        M.setup_done = true
    end

    if M.disabled_plugins == nil then
        M.disabled_plugins = neoconf.get("plugins.disabled", {})
    end
end

return M
