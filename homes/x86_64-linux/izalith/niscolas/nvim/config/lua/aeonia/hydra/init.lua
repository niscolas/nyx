local M = {}
local splits = require("smart-splits")
local cmd = require("hydra.keymap-util").cmd
local pcmd = require("hydra.keymap-util").pcmd

M.setup = function()
    local hydra = require("hydra")

    hydra {
        name = "Side scroll",
        mode = "n",
        body = "z",
        heads = {
            { "h", "5zh" },
            { "l", "5zl", { desc = "←/→" } },
            { "H", "zH" },
            { "L", "zL", { desc = "half screen ←/→" } },
        },
    }

    local window_hint = [[
        ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
        ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
        ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally 
        _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
        ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
        focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
        ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
    ]]

    hydra {
        name = "Windows",
        hint = window_hint,
        config = {
            invoke_on_body = true,
            hint = {
                border = "rounded",
                offset = -1,
            },
        },
        mode = "n",
        body = "<C-w>",
        heads = {
            { "h", "<C-w>h" },
            { "j", "<C-w>j" },
            { "k", pcmd("wincmd k", "E11", "close") },
            { "l", "<C-w>l" },

            { "H", cmd("WinShift left") },
            { "J", cmd("WinShift down") },
            { "K", cmd("WinShift up") },
            { "L", cmd("WinShift right") },

            {
                "<C-h>",
                function()
                    splits.resize_left(5)
                end,
            },
            {
                "<C-j>",
                function()
                    splits.resize_down(5)
                end,
            },
            {
                "<C-k>",
                function()
                    splits.resize_up(5)
                end,
            },
            {
                "<C-l>",
                function()
                    splits.resize_right(5)
                end,
            },
            { "=", "<C-w>=", { desc = "equalize" } },

            { "s", pcmd("split", "E36") },
            { "<C-s>", pcmd("split", "E36"), { desc = false } },
            { "v", pcmd("vsplit", "E36") },
            { "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

            { "w", "<C-w>w", { exit = true, desc = false } },
            { "<C-w>", "<C-w>w", { exit = true, desc = false } },

            {
                "z",
                cmd("WindowsMaximize"),
                { exit = true, desc = "maximize" },
            },
            {
                "<C-z>",
                cmd("WindowsMaximaze"),
                { exit = true, desc = false },
            },

            { "o", "<C-w>o", { exit = true, desc = "remain only" } },
            { "<C-o>", "<C-w>o", { exit = true, desc = false } },

            { "c", pcmd("close", "E444") },
            { "q", pcmd("close", "E444"), { desc = "close window" } },
            { "<C-c>", pcmd("close", "E444"), { desc = false } },
            { "<C-q>", pcmd("close", "E444"), { desc = false } },

            { "<Esc>", nil, { exit = true, desc = false } },
        },
    }
end

return M
