return {
    "kevinhwang91/nvim-ufo",
    config = function()
        vim.o.foldcolumn = "0" -- '0' is not bad
        vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local language_servers = require("lspconfig").util.available_servers()
        for _, ls in ipairs(language_servers) do
            require("lspconfig")[ls].setup {
                capabilities = capabilities,
            }
        end

        require("ufo").setup()
    end,
    dependencies = "kevinhwang91/promise-async",
    keys = {
        {
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
        },
        {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
        },
    },
}
