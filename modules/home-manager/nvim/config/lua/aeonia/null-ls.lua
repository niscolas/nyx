local M = {}

local null_ls_format = function(bufnr)
    vim.lsp.buf.format {
        filter = function(client)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    }
end

local on_attach = function(client, bufnr, augroup)
    if not client.supports_method("textDocument/formatting") then
        return
    end

    clear_autocmd { group = augroup, buffer = bufnr }
    new_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
            null_ls_format(bufnr)
        end,
    })
end

M.setup = function()
    local null_ls = require("null-ls")
    local cspell = require("cspell")
    local augroup = new_augroup("lsp_formatting", { clear = true })

    null_ls.setup {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr, augroup)
        end,
        sources = {
            cspell.diagnostics.with {
                diagnostics_postprocess = function(diagnostic)
                    diagnostic.severity = vim.diagnostic.severity.HINT
                end,
            },

            cspell.code_actions,

            -- null_ls.builtins.code_actions.cspell,
            -- null_ls.builtins.diagnostics.cspell
            -- c++
            null_ls.builtins.formatting.clang_format,

            -- godot
            null_ls.builtins.formatting.gdformat,

            -- js / ts
            -- null_ls.builtins.diagnostics.xo,
            -- null_ls.builtins.code_actions.xo,
            -- null_ls.builtins.formatting.prettier_standard,

            -- lua
            null_ls.builtins.formatting.stylua,

            -- nix
            null_ls.builtins.diagnostics.deadnix,
            null_ls.builtins.formatting.alejandra,

            -- null_ls.builtins.formatting.csharpier,
        },
    }
    null_ls.register(require("none-ls-shellcheck.diagnostics"))
    null_ls.register(require("none-ls-shellcheck.code_actions"))

    table.insert(require("aeonia.lsp.format").formatters, null_ls_format)
end

return M
