local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local output = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath })
    print(output)
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = true
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    {
        "christoomey/vim-tmux-navigator",
        enabled = vim.fn.has('unix') ~= 0,
        cond = vim.env.TMUX,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    },
    {
        'f-person/git-blame.nvim',
        opts = {
            enabled = false,
        },
        cmd = { "GitBlameToggle" }
    },
    {
        'rhysd/committia.vim',
        ft = 'gitcommit',
        init = function()
            vim.g.floaterm_autoclose = 1
            vim.g.floaterm_autoinsert = 1
            vim.g.floaterm_keymap_toggle = '<c-t>'
        end,
    },
    {
        'Valloric/ListToggle',
        event = { "VeryLazy" },
    },
    {
        'voldikss/vim-floaterm',
        init = function()
            vim.g.committia_open_only_vim_starting = 1
        end,
    },
    {
        'chrisbra/Recover.vim'
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { '<leader>ff', '<cmd>Telescope find_files<cr>' },
            { '<leader>fg', '<cmd>Telescope live_grep<cr>' },
            { '<leader>fb', '<cmd>Telescope buffers<cr>' },
            { '<leader>fs', '<cmd>Telescope grep_string<cr>' },
            { '<leader>fy', '<cmd>Telescope registers<cr>' },
            { '<leader>fr', '<cmd>Telescope resume<cr>' },
        }
    },
    {
        'bronson/vim-trailing-whitespace',
        cmd = { "FixWhitespace" }
    },
    {
        'lilydjwg/fcitx.vim',
        enabled = vim.fn.has('x11') ~= 0,
    },
    {
        'google/vim-searchindex'
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        event = { "VeryLazy" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts = {
            ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "css", "html", "bash", "cmake", "csv", "git_config", "gitignore", "glsl", "hlsl", "json", "make", "ninja", "qmljs", "regex", "ssh_config", "tmux", "xml", "yaml", "diff", "javascript", "markdown", "markdown_inline", "python" },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,

    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        'junegunn/vim-easy-align',
        keys = {
            { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
        }
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "main",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                window = {
                    mappings = {
                        ["E"] = "system_open",
                        ["I"] = "run_command",
                    },
                },
                commands = {
                    system_open = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        if vim.fn.has('macunix') ~= 0 then
                            vim.fn.jobstart({ "open", path }, { detach = true })
                        elseif vim.fn.has('win32') ~= 0 then
                            vim.fn.jobstart({ "cmd", "/c", "explorer", path }, { detach = true })
                        elseif vim.fn.has('unix') ~= 0 then
                            vim.fn.jobstart({ "xdg-open", path }, { detach = true })
                        end
                    end,
                    run_command = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.api.nvim_input(": " .. path .. "<Home>")
                    end,
                },
            },

        },
        keys = {
            { '<leader>n', '<cmd>Neotree toggle<cr>' },
        },
    },
    {
        'vim-scripts/ReplaceWithRegister'
    },
    {
        'vim-scripts/VisIncr'
    },
    {
        'voldikss/vim-translator',
        keys = {
            { '<C-t>', '<Plug>TranslateW' },
            { '<C-t>', '<Plug>TranslateWV', mode = { 'v' } },
        }
    },
    {
        "hedyhli/markdown-toc.nvim",
        ft = "markdown",
        cmd = { "Mtoc" },
    },
    {
        'easymotion/vim-easymotion',
        keys = {
            { '<leader>', '<Plug>(easymotion-prefix)', mode = { '' } },
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        config = true
    },
    {
        'mg979/vim-visual-multi',
        init = function()
            vim.g.VM_theme = 'olive'
            vim.g.VM_leader = '\\'
            vim.g.VM_maps = { ["Select All"] = '\\a' }
        end,

    },
    {
        'lambdalisue/suda.vim',
        enabled = vim.fn.has('unix') ~= 0,
    },
    {
        'tpope/vim-repeat'
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true
    },
    {
        'dyng/ctrlsf.vim'
    },
    {
        'psliwka/vim-smoothie'
    },
    {
        'simnalamburt/vim-mundo'
    },
    {
        'AndrewRadev/splitjoin.vim'
    },
    {
        'numToStr/Comment.nvim',
        config = true,
        lazy = false,
    },
    {
        'vim-scripts/DoxygenToolkit.vim',
        init = function()
            vim.g.DoxygenToolkit_briefTag_pre = "@brief "
            vim.g.DoxygenToolkit_paramTag_pre = "@param "
            vim.g.DoxygenToolkit_returnTag = "@returns "
        end,
        cmd = { "Dox" }
    },
    {
        'stevearc/aerial.nvim',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = true,
        keys = {
            { '<leader>a', '<cmd>AerialToggle!<CR>' }
        }
    },
    {
        'voldikss/vim-browser-search',
        keys = {
            { '<leader>gg', '<Plug>SearchNormal' },
            { '<leader>gg', '<Plug>SearchVisual', mode = { 'v' } },
        }
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        'weirongxu/plantuml-previewer.vim',
        dependencies = {
            'tyru/open-browser.vim'
        },
        cmd = { "PlantumlOpen", "PlantumlToggle" }
    },
    {
        "williamboman/mason.nvim",
        config = true
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "clangd", "jsonls" },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {}
                end,
                ['clangd'] = function()
                    require("lspconfig").clangd.setup {
                        on_attach = function(_, bufnr)
                            vim.keymap.set('n', '<leader>s', '<cmd>ClangdSwitchSourceHeader<cr>',
                                { buffer = bufnr, noremap = true, silent = true })
                        end
                    }
                end,
                ["lua_ls"] = function()
                    require('lspconfig').lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" }
                                }
                            }
                        }
                    }
                end,
            }
        }
    },
    {
        "neovim/nvim-lspconfig",
        keys = {
            { '<leader>e', '<cmd>lua vim.diagnostic.setloclist()<cr>' }
        },
        init = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local opts = { buffer = ev.buf, noremap = true, silent = true }
                    local function quickfix()
                        vim.lsp.buf.code_action({
                            filter = function(a) return a.isPreferred end,
                            apply = true
                        })
                    end

                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>x', quickfix, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, opts)
                end,
            })
        end
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                cpp = { "clang-format" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },

        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            'hrsh7th/cmp-cmdline',
            {
                'quangnguyen30192/cmp-nvim-ultisnips',
                config = true,
                dependencies = { 'SirVer/ultisnips' }
            },
            {
                'saadparwaiz1/cmp_luasnip',
                dependencies = { 'L3MON4D3/LuaSnip' }
            },
            {
                'chrisgrieser/cmp_yanky',
                dependencies = { "gbprod/yanky.nvim", opts = {} }
            },
            'paopaol/cmp-doxygen',
            {
                'hrsh7th/cmp-copilot',
                dependencies = { 'github/copilot.vim' }
            }
        },
        opts = function()
            local cmp = require("cmp")
            return {
                snippet = {
                    expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                window = {
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'cmp_yanky' },
                    { name = 'doxygen' },
                    { name = 'ultisnips' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                }),
                formatting = {
                    format = function(_, vim_item)
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                        return vim_item
                    end
                }
            }
        end,
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        keys = {
            {
                "<C-j>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
                end,
                expr = true,
                silent = true,
                mode = "i",
            },
            { "<C-j>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
    },
    {
        'SirVer/ultisnips',
        init = function()
            vim.g.UltiSnipsExpandTrigger = "<C-e>"
            vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
            vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
        end,
    }
})
