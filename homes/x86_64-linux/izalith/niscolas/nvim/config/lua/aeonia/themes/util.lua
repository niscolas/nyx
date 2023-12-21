local M = {}

M.convert_decimal_hex_to_6_digit_hex = function(decimal_hex)
    return string.format("%06x", decimal_hex)
end

M.get_fg_from = function(hl_name)
    local result = get_hl(0, { name = hl_name })
    return result.fg
end

M.get_bg_from = function(hl_name)
    local result = get_hl(0, { name = hl_name })
    return result.bg
end

return M
