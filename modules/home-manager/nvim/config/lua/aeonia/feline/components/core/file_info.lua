local feline_cursor_provider = require("feline.providers.cursor")

return {
    encoding_and_format = {
        provider = function()
            local encoding = vim.bo.fileencoding:upper()
            local format = vim.bo.fileformat:upper()
            local position = feline_cursor_provider.position({}, {})

            return format .. " " .. encoding
        end,
    },
}
