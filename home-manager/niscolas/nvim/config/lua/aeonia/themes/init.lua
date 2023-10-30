local M = {}

M.theme_module = nil

M.force_background_transparency = function()
    if not niscolas.theme.use_transparency then
        return
    end

    set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
    set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
    set_hl(0, "NormalNC", { bg = "none", ctermbg = "none" })
end

M.get_from_theme = function(field_name, default_value)
    if not M.theme_module then
        return nil
    end

    local result = M.theme_module[field_name]
    if result == nil then
        return default_value
    end

    return result
end

M.call_from_theme = function(function_name)
    if not M.theme_module then
        return nil
    end

    local result = M.theme_module[function_name]
    if result ~= nil then
        return result()
    end

    return false
end

return M
