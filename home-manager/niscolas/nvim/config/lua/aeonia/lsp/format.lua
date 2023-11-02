local M = {}

M.formatters = {}

M.create_format_fn = function()
    return function(bufnr)
        require("aeonia.core.util").call_multi_function(
            M.formatters,
            vim.lsp.buf.format,
            bufnr
        )
    end
end

return M
