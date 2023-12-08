return {
    "gbprod/substitute.nvim",
    event = "InsertEnter",
    keys = {
        {
            "gr",
            function()
                require("substitute").operator()
            end,
            mode = "n",
            noremap = true,
            desc = "Substitute Operator",
        },
        {
            "grr",
            function()
                require("substitute").line()
            end,
            mode = "n",
            noremap = true,
            desc = "Substitute Line",
        },
        {
            "grR",
            function()
                require("substitute").eol()
            end,
            mode = "n",
            noremap = true,
            desc = "Substitute Until EOL",
        },
        {
            "gr",
            function()
                require("substitute").visual()
            end,
            mode = "x",
            noremap = true,
            desc = "Substitute (Visual)",
        },
    },
    opts = {},
}
