local M = {}

M.theme_mod = nil

M.force_background_transparency = function()
    if not niscolas.theme.use_transparency then
        return
    end

    set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
    set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
    set_hl(0, "NormalNC", { bg = "none", ctermbg = "none" })
end

M.get_field = function(field_name)
    if not M.theme_mod then
        return nil
    end

    local result = M.theme_mod[field_name]
    return result
end

return M
