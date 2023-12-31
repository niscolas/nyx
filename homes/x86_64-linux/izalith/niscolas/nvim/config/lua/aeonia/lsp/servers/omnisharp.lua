local lsp_servers_mod = require("aeonia.lsp.servers")
local util = require("lspconfig.util")

local custom_on_attach = function(bufnr)
    new_keymap(
        "n",
        "gd",
        require("omnisharp_extended").telescope_lsp_definitions
    )
end

local on_attach = function(client, bufnr)
    local handlers_mod = require("aeonia.lsp.handlers")

    handlers_mod.on_attach(client, bufnr)
    -- client.server_capabilities.semanticTokensProvider = nil
    -- client.server_capabilities.semanticTokensProvider = {
    --     full = vim.empty_dict(),
    --     legend = {
    --         tokenModifiers = { "static_symbol" },
    --         tokenTypes = {
    --             "comment",
    --             "excluded_code",
    --             "identifier",
    --             "keyword",
    --             "keyword_control",
    --             "number",
    --             "operator",
    --             "operator_overloaded",
    --             "preprocessor_keyword",
    --             "string",
    --             "whitespace",
    --             "text",
    --             "static_symbol",
    --             "preprocessor_text",
    --             "punctuation",
    --             "string_verbatim",
    --             "string_escape_character",
    --             "class_name",
    --             "delegate_name",
    --             "enum_name",
    --             "interface_name",
    --             "module_name",
    --             "struct_name",
    --             "type_parameter_name",
    --             "field_name",
    --             "enum_member_name",
    --             "constant_name",
    --             "local_name",
    --             "parameter_name",
    --             "method_name",
    --             "extension_method_name",
    --             "property_name",
    --             "event_name",
    --             "namespace_name",
    --             "label_name",
    --             "xml_doc_comment_attribute_name",
    --             "xml_doc_comment_attribute_quotes",
    --             "xml_doc_comment_attribute_value",
    --             "xml_doc_comment_cdata_section",
    --             "xml_doc_comment_comment",
    --             "xml_doc_comment_delimiter",
    --             "xml_doc_comment_entity_reference",
    --             "xml_doc_comment_name",
    --             "xml_doc_comment_processing_instruction",
    --             "xml_doc_comment_text",
    --             "xml_literal_attribute_name",
    --             "xml_literal_attribute_quotes",
    --             "xml_literal_attribute_value",
    --             "xml_literal_cdata_section",
    --             "xml_literal_comment",
    --             "xml_literal_delimiter",
    --             "xml_literal_embedded_expression",
    --             "xml_literal_entity_reference",
    --             "xml_literal_name",
    --             "xml_literal_processing_instruction",
    --             "xml_literal_text",
    --             "regex_comment",
    --             "regex_character_class",
    --             "regex_anchor",
    --             "regex_quantifier",
    --             "regex_grouping",
    --             "regex_alternation",
    --             "regex_text",
    --             "regex_self_escaped_character",
    --             "regex_other_escape",
    --         },
    --     },
    --     range = true,
    -- }
    -- custom_on_attach(bufnr)
end

local omnisharp_path = lsp_servers_mod.install_path
    .. "/omnisharp/libexec/Omnisharp.dll"

print("OMNISHARP")
local pid = vim.fn.getpid()
return {
    cmd = {
        "dotnet",
        omnisharp_path,
        -- "--languageserver",
        -- "--hostPID",
        -- tostring(pid),
    },
    handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
    on_attach = on_attach,
    root_dir = function(path)
        return util.root_pattern("*.sln")(path)
    end,
}
