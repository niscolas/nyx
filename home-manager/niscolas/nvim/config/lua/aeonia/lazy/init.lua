local M = {}

M.setup = function()
    require("aeonia.lazy.util").bootstrap()

    require("lazy").setup({
        {
            import = "aeonia.neoai.spec",
        },

        {
            "ellisonleao/gruvbox.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                require("aeonia.themes.gruvbox").setup()
            end,
        },

        {
            "folke/neodev.nvim",
            enabled = false,
            config = function()
                require("neodev").setup {}
            end,
            lazy = false,
            priority = 51,
        },

        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "Hoffs/omnisharp-extended-lsp.nvim",

                {
                    "ray-x/lsp_signature.nvim",
                    event = "VeryLazy",
                    config = function()
                        require("lsp_signature").setup {
                            hint_prefix = niscolas.icons.fn .. " ",
                        }
                    end,
                },
            },
        },

        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = require("aeonia.treesitter").setup,
            event = "VeryLazy",
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects",
                "nvim-treesitter/playground",

                {
                    "nvim-treesitter/nvim-treesitter-context",
                    config = true,
                },
            },
        },

        {
            "mfussenegger/nvim-dap",
            cmd = {
                "DapShowLog",
                "DapContinue",
                "DapToggleBreakpoint",
                "DapToggleRepl",
                "DapStepOver",
                "DapStepInto",
                "DapStepOut",
                "DapTerminate",
                "DapLoadLaunchJSON",
                "DapRestartFrame",
            },
            config = require("aeonia.dap").setup,
            dependencies = {
                "rcarriga/nvim-dap-ui",
                "theHamsta/nvim-dap-virtual-text",
            },
        },

        {
            "nvim-lua/plenary.nvim",
        },

        {
            "hrsh7th/nvim-cmp",
            config = require("aeonia.cmp").setup,
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-emoji",

                {
                    "tzachar/cmp-tabnine",
                    build = "./install.sh",
                    cond = require("aeonia.core.util").check_is_personal_setup,
                    config = function()
                        local tabnine = require("cmp_tabnine.config")

                        tabnine:setup {
                            max_lines = 1000,
                            max_num_results = 20,
                            sort = true,
                            run_on_every_keystroke = true,
                            snippet_placeholder = "..",
                            ignored_file_types = {
                                -- default is not to ignore
                                -- uncomment to ignore in lua:
                                -- lua = true
                            },
                            show_prediction_strength = false,
                        }
                    end,
                },

                {
                    "L3MON4D3/LuaSnip",
                    config = require("aeonia.luasnip").setup,
                    dependencies = {
                        "rafamadriz/friendly-snippets",
                    },
                },
            },
            event = "InsertEnter",
        },

        {
            "lewis6991/gitsigns.nvim",
            event = "VeryLazy",
            config = require("aeonia.gitsigns").setup,
        },

        {
            "tpope/vim-fugitive",
            config = require("aeonia.fugitive").setup,
        },

        {
            "tpope/vim-rhubarb",
        },

        {
            "tpope/vim-eunuch",
        },

        {
            "tpope/vim-repeat",
        },

        {
            "tpope/vim-sleuth",
        },

        {
            "andymass/vim-matchup",
        },

        {
            "numToStr/Comment.nvim",
            config = true,
        },

        {
            "glacambre/firenvim",
            build = function()
                fn["firenvim#install"](0)
            end,
            cond = require("aeonia.firenvim").is_env,
            config = require("aeonia.firenvim").setup,
        },

        {
            "lukas-reineke/indent-blankline.nvim",
            config = function()
                require("ibl").setup()
            end,
            event = "VeryLazy",
        },

        {
            "luukvbaal/stabilize.nvim",
            config = true,
            event = "VeryLazy",
        },

        {
            "windwp/nvim-autopairs",
            config = require("aeonia.autopairs").setup,
            event = "InsertEnter",
        },

        {
            "kylechui/nvim-surround",
            config = true,
            event = "InsertEnter",
        },

        {
            "gbprod/substitute.nvim",
            config = require("aeonia.substitute").setup,
            event = "InsertEnter",
        },

        {
            "folke/zen-mode.nvim",
            config = true,
            cmd = "ZenMode",
        },

        {
            "iamcco/markdown-preview.nvim",
            build = "cd app && npm install",
            ft = { "markdown" },
            init = function()
                g.mkdp_filetypes = { "markdown" }
            end,
        },

        {
            "mbbill/undotree",
            cmd = "UndotreeToggle",
            config = require("aeonia.undotree").setup,
            keys = {
                require("aeonia.core.keymap.util").lazy_keys_spec_from_keymap_spec(
                    require("aeonia.undotree").keymap.toggle
                ),
            },
        },

        {
            "ojroques/nvim-bufdel",
            config = require("aeonia.bufdel").setup,
            keys = require("aeonia.core.keymap.util").lazy_keys_from_keymap_spec_list(
                require("aeonia.bufdel").keymap
            ),
        },

        {
            "kyazdani42/nvim-web-devicons",
            event = "VeryLazy",
        },

        {
            "rcarriga/nvim-notify",
            config = require("aeonia.notify").setup,
            event = "VeryLazy",
        },

        {
            "wakatime/vim-wakatime",
            cmd = {
                "WakaTimeApiKey",
                "WakaTimeDebugEnable",
                "WakaTimeDebugDisable",
                "WakaTimeScreenRedrawEnable",
                "WakaTimeScreenRedrawEnableAuto",
                "WakaTimeScreenRedrawDisable",
                "WakaTimeToday",
            },
            cond = require("aeonia.core.util").check_is_personal_setup,
        },

        -- {
        --     "ggandor/leap.nvim",
        --     config = require("aeonia.leap").setup,
        -- },

        {
            "nvim-neorg/neorg",
            config = require("aeonia.neorg").setup,
            build = ":Neorg sync-parsers",
        },

        {
            "folke/which-key.nvim",
            config = true,
            event = "VeryLazy",
        },

        {
            "norcalli/nvim-colorizer.lua",
            opts = {
                "*",
            },
        },

        {
            "freddiehaddad/feline.nvim",
            config = require("aeonia.feline").setup,
            event = "VeryLazy",
        },

        {
            "RRethy/vim-illuminate",
            config = function()
                require("illuminate").configure()
            end,
        },

        {
            "folke/noice.nvim",
            config = require("aeonia.noice").setup,
            dependencies = {
                "MunifTanjim/nui.nvim",
            },
        },

        {
            "windwp/nvim-spectre",
        },

        {
            "folke/trouble.nvim",
            cmd = {
                "Trouble",
                "TroubleClose",
                "TroubleToggle",
                "TroubleRefresh",
            },
        },

        {
            "SmiteshP/nvim-navic",
            config = require("aeonia.navic").setup,
        },

        -- {
        --     "jbyuki/one-small-step-for-vimkind",
        -- },

        {
            "stevearc/oil.nvim",
            cmd = "Oil",
            keys = {
                require("aeonia.core.keymap.util").lazy_keys_spec_from_keymap_spec(
                    require("aeonia.oil").keymap.open
                ),
            },
            config = require("aeonia.oil").setup,
        },

        {
            "zbirenbaum/neodim",
            event = "LspAttach",
            opts = {
                alpha = 0.5,
                blend_color = "#000000",
                update_in_insert = {
                    enable = true,
                    delay = 100,
                },
                hide = {
                    virtual_text = false,
                    signs = false,
                    underline = false,
                },
            },
        },

        {
            "lucasdf/hologram.nvim",
            opts = {
                auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
            },
        },

        {
            "nvimtools/none-ls.nvim",
            as = "none-ls",
            config = require("aeonia.null-ls").setup,
        },

        {
            "smjonas/inc-rename.nvim",
            config = require("aeonia.inc-rename").setup,
        },

        {
            "ibhagwan/fzf-lua",
            config = require("aeonia.fzf-lua").setup,
            init = require("aeonia.fzf-lua").init,
        },

        {
            "levouh/tint.nvim",
            config = true,
            enabled = false,
        },

        {
            "folke/twilight.nvim",
            opts = {
                context = 100,
                dimming = {
                    alpha = 0.5,
                    inactive = true,
                },
                exclude = { "help" },
            },
        },

        {
            "pwntester/octo.nvim",
            config = function()
                require("octo").setup()
            end,
        },

        -- {
        --     "m4xshen/smartcolumn.nvim",
        --     config = true,
        -- },

        -- {
        --     "akinsho/git-conflict.nvim",
        --     config = require("aeonia.git-conflict").setup,
        --     version = "*",
        -- },

        {
            "IndianBoy42/tree-sitter-just",
            config = true,
        },

        {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            dependencies = {
                {
                    "zbirenbaum/copilot-cmp",
                    config = true,
                },
            },
            event = "InsertEnter",
            opts = {
                suggestion = { enabled = false },
                panel = { enabled = false },
            },
        },

        {
            "akinsho/toggleterm.nvim",
            config = require("aeonia.toggleterm").setup,
            version = "*",
        },

        {
            "nvim-neotest/neotest",
            config = function()
                require("neotest").setup {
                    adapters = {
                        require("neotest-dotnet") {
                            discovery_root = "solution",
                        },
                    },
                    library = { plugins = { "neotest" }, types = true },
                    loglevel = 1,
                }
            end,
            dependencies = {
                "antoinemadec/FixCursorHold.nvim",
                "Issafalcon/neotest-dotnet",
            },
        },

        -- {
        --     "anuvyklack/windows.nvim",
        --     config = function()
        --         vim.o.winwidth = 10
        --         vim.o.winminwidth = 10
        --         vim.o.equalalways = false
        --         require("windows").setup {
        --             animation = {
        --                 enable = false,
        --                 fps = 60,
        --                 duration = 1000,
        --             },
        --             ignore = {
        --                 buftype = { "toggleterm" },
        --                 filetype = { "toggleterm" },
        --             },
        --         }
        --     end,
        --     dependencies = {
        --         "anuvyklack/middleclass",
        --         "anuvyklack/animation.nvim",
        --     },
        -- },

        {
            "lvimuser/lsp-inlayhints.nvim",
            enabled = false,
            config = function()
                require("lsp-inlayhints").setup()

                vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
                vim.api.nvim_create_autocmd("LspAttach", {
                    group = "LspAttach_inlayhints",
                    callback = function(args)
                        if not (args.data and args.data.client_id) then
                            return
                        end

                        local bufnr = args.buf
                        local client =
                            vim.lsp.get_client_by_id(args.data.client_id)
                        require("lsp-inlayhints").on_attach(client, bufnr)
                    end,
                })
            end,
        },

        {
            "VidocqH/lsp-lens.nvim",
            config = true,
        },

        {
            "jcdickinson/codeium.nvim",
            commit = "b1ff0d6c993e3d87a4362d2ccd6c660f7444599f",
            cond = require("aeonia.core.util").check_is_personal_setup,
            config = true,
            enabled = false,
            dependencies = {
                "nvim-lua/plenary.nvim",

                {
                    "jcdickinson/http.nvim",
                    build = "cargo build --workspace --release",
                },
            },
        },

        {
            "cappyzawa/trim.nvim",
            cmd = {
                "Trim",
                "TrimToggle",
            },
            config = function()
                require("trim").setup {
                    trim_on_write = false,
                }
            end,
        },

        {
            "okuuva/auto-save.nvim",
            cmd = "ASToggle",
            config = require("aeonia.auto-save").setup,
        },

        {
            "nvim-telescope/telescope.nvim",
            config = require("aeonia.telescope").setup,
            tag = "0.1.2",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            },
        },

        {
            "folke/neoconf.nvim",
            priority = 999,
            config = function()
                require("neoconf").setup()
            end,
        },
    }, {
        defaults = {
            cond = function(plugin)
                local disabled_plugins =
                    require("neoconf").get("plugins.disabled", {})
                local result =
                    not vim.tbl_contains(disabled_plugins, plugin.name)
                return result
            end,
            lazy = false,
        },
    })
end

return M
