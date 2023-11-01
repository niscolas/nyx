local M = {}

M.ensure_installed_servers = {}
M.install_path = fn.stdpath("data") .. "/mason/packages"
M.settings = require("neoconf").get("lsp.servers")

return M
