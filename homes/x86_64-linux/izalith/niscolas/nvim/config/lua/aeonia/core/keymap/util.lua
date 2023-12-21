local M = {}

M.new_keymap_from_keymap_spec = function(spec)
    new_keymap(spec.mode, spec.lhs, spec.rhs, spec.opts or {})
end

M.new_keymaps_from_keymap_spec_list = function(spec_list)
    for _, spec in ipairs(spec_list) do
        new_keymap(spec.mode, spec.lhs, spec.rhs, spec.opts or {})
    end
end

M.lazy_keys_spec_from_keymap_spec = function(spec)
    local result = {}
    table.insert(result, spec.lhs)

    if spec.rhs then
        table.insert(result, spec.rhs)
    end

    if spec.mode then
        result.mode = spec.mode
    end

    if spec.ft then
        result.ft = spec.ft
    end

    if spec.opts and spec.opts.desc then
        result.desc = spec.opts.desc
    end

    return result
end

M.lazy_keys_from_keymap_spec_list = function(spec_list)
    local result = {}

    for _, spec in ipairs(spec_list) do
        table.insert(result, M.lazy_keys_spec_from_keymap_spec(spec))
    end

    return result
end

return M
