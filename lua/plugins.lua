do -->1 pckr setup
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not (vim.uv or vim.loop).fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

local cmd = require 'pckr.loader.cmd'
local keys = require 'pckr.loader.keys'
local event = require 'pckr.loader.event'

--<1
local function lspBufSetup(evt)-->1
  local bnr = evt.buf
  local function bmap(mode, lhs, rhs, opts)
    if type(opts) == 'string' then opts = { desc = opts } end
    opts.buffer = opts.buffer or bnr
    vim.keymap.set(
      type(mode) == 'table' and mode or vim.split(mode, ''),
      lhs,
      type(rhs) == 'string' and vim.lsp.buf[rhs] or rhs,
      opts
    )
  end

  vim.bo[bnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  bmap('n', 'gD', 'declaration', 'goto lsp declaration')
  bmap('n', 'gd', 'definition', 'goto lsp definition')
  bmap('n', 'K', 'hover', 'show lsp hover')
  bmap('n', '<Space>K', 'K', 'preserve default K')
  bmap('n', 'gi', 'implementation', 'goto lsp implementation')
  bmap('nix', '<M-CR>', function()
    local basewid = vim.api.nvim_get_current_win()
    for _, wid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if wid ~= basewid and vim.api.nvim_win_get_config(wid).win == basewid then
        vim.print(wid)
        vim.api.nvim_win_close(wid, false)
        return
      end
    end
    vim.lsp.buf.signature_help()
  end, 'show lsp signature help')
  bmap('n', '<Leader>wa', 'add_workspace_folder', 'add lsp workspace folder')
  bmap('n', '<Leader>wr', 'remove_workspace_folder', 'remove lsp workspace folder')
  bmap('n', '<Leader>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, 'list lsp workspace folders')
  bmap('n', '<Leader>D', 'type_definition', 'goto lsp type definition')
  bmap('n', '<Leader>r', 'rename', 'rename lsp symbol')
  bmap('nx', '<Leader>ca', 'code_action', 'list lsp code action')
  bmap('n', '<Leader>R', 'references', 'list lsp references')
  bmap({ 'n', 'x' }, '<Leader>F', function() vim.lsp.buf.format { async = true } end, 'format file|range using lsp')
end -- }}}

require 'pckr'.add {-->1

  { 'neovim/nvim-lspconfig',-->2
    cond = event { 'BufReadPost', 'BufNewFile' },
    config = function()
      local lc = require 'lspconfig'
      local au = require 'utils'.augroup 'LspAttach'
      vim.iter(pairs({
        clangd = {},
        zls = {},
        lua_ls = {-->3
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                return
              end
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" --[["${3rd}/busted/library"]] }
              }
            })
          end,
          settings = { Lua = {} }
        },--<3
        rust_analyzer = {-->3
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = false,
              },
            }
          }
        },--<3
        marksman = {},
      })):each(function(lsp, cfg)
        -- cfg.autostart = false -- disable auto :LspStart
        lc[lsp].setup(cfg)
      end)
      au { 'LspAttach', callback = lspBufSetup }
      -- global keymaps
      vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = 'open diagnostic float' })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'goto prev diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'goto next diagnostic' })
      vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'set diagnostic loclist' })

    end,
  };--<2

  { 'tpope/vim-abolish',-->2
    cond = {
      keys('n', 'cr'),
      cmd 'Abolish',
      cmd 'Subvert',
      cmd 'S',
    },
  };--<2

  { 'mlochbaum/BQN',-->2
    config = function()
      local datadir = vim.fn.stdpath 'data' --- @cast datadir string
      vim.opt.rtp:append(vim.fs.joinpath(datadir, 'site', 'pack', 'pckr', 'opt', 'BQN', 'editors', 'vim'))
    end,
  };--<2

  { 'https://git.sr.ht/~detegr/nvim-bqn',-->2
    cond = event('FileType', 'bqn'),
    config_pre = function() vim.g.nvim_bqn = 'bqn' end,
  };--<2

  'rstacruz/vim-closer';

  'tpope/vim-commentary';

  { 'vyfor/cord.nvim',-->2
    run = './build',
    cond = event 'UIEnter',
    config = function()
      require 'cord'.setup()
    end,
  };--<2

  'VioletJewel/vim-ctrlg';

  'elixir-editors/vim-elixir';

  'tommcdo/vim-exchange';

  { 'nvim-tree/nvim-web-devicons',-->2
    cond = event 'UIEnter',
    config = function()
      require 'nvim-web-devicons'.setup {
        override = { markdown = { icon = "" } },
        override_by_extension = { md = { icon = "" } },
      }
    end,
  };--<2

  { 'ibhagwan/fzf-lua',-->2
    requires = { 'nvim-tree/nvim-web-devicons' },
    cond = {
      keys('n', '<Space>f'),
      keys('n', '<Bslash>c'),
      cmd 'FZF',
      cmd 'FzfLua',
    },
    config = function()
      require 'fzf-lua'.setup {
        'max-perf',
        previewers = {
          bat = {
            -- iff bat's config file exists, empty string; ellse '--color=always --style=changes
            args = vim.uv.fs_stat(vim.fs.joinpath((os.getenv 'XDG_CONFIG_DIR' or vim.fs.joinpath(os.getenv 'HOME', '.config')), 'bat', 'config')) and '' or '--color=always --style=changes',
          }
        },
        keymap = {
          builtin = {
            true,
            ['<M-f>'] = 'toggle-fullscreen',
          },
          fzf = {
            true,
            ['alt-j']  = 'preview-down',
            ['alt-k']  = 'preview-up',
            ['ctrl-j'] = 'preview-page-down',
            ['ctrl-k'] = 'preview-page-up',
            ['alt-w']  = 'toggle-preview-wrap',
            ['alt-p']  = 'toggle-preview',
          },
        },
        actions = {
          files = {
            true,
            ['alt-e'] = function(_, opts)
              local f = vim.fs.joinpath(opts.cwd, opts.last_query)
              local e = vim.api.nvim_replace_termcodes('<Esc>:e ', true, true, true)
              vim.api.nvim_feedkeys(e..f, 'L', false)
            end,
          }
        },
      }
      vim.keymap.set('n', '<Leader>f', function() require'fzf-lua'.files() end, { desc = 'browse files in fzf' })
      vim.keymap.set('n', '<M-Esc>', function() require'fzf-lua'.resume() end, { desc = 'resume fzf session' })
      vim.keymap.set('n', '<LocalLeader>c', function() require'fzf-lua'.files{ cwd = vim.fn.stdpath 'config' } end, { desc = 'browse nvim config files in fzf' })
    end,
  };--<2

  { 'nanotee/zoxide.vim',-->2
    requires = { 'ibhagwan/fzf-lua' },
    config_pre = function() vim.g.zoxide_use_select = 1 end,
    cond = keys('n', '<Space>z', ':<C-u>Zi<CR>', { desc = '[F]ZF [Z]oxide CD' }),
    config = function()
      require 'fzf-lua'.register_ui_select()
      -- vim.api.nvim_set_keymap('n', '<Leader>z', ':Zi<CR>', { desc = '[F]ZF [Z]oxide CD' })
    end,
  };--<2

  { 'tpope/vim-fugitive',-->2
    cond = {
      keys('n', '<Space>gg'),
      cmd 'G',
      cmd 'Git',
      cmd 'Ggrep',
      cmd 'Glgrep',
      cmd 'Gclog',
      cmd 'Gcd',
      cmd 'Glcd',
      cmd 'Gedit',
      cmd 'Gdiffsplit',
    },
    config = function()
      vim.keymap.set('n', '<Leader>gg', function()
        local buf = vim.api.nvim_get_current_buf()
        vim.cmd.Git { mods = { vertical = true, split = "topleft" } }
        if #vim.api.nvim_tabpage_list_wins(0) == 2 and vim.bo[buf].buftype == '' and #vim.fn.undotree(buf).entries == 0 then
          vim.cmd.wincmd 'o'
        end
        vim.api.nvim_win_set_cursor(0, { 1, 0 })
      end, {
        silent = true,
        desc = 'open :Git|only (if no active windows) or :top vert Git (otherwise)'
      })
    end,
  };--<2

  { 'junegunn/gv.vim',-->2
    requires = { 'tpope/vim-fugitive' },
  };--<2

  { 'lewis61/gitsigns.nvim',-->2
    cond = {
      keys('n', '<Bslash>gss'),
      keys('n', '<Bslash>gsn'),
      keys('n', '<Bslash>gsl'),
      keys('n', '<Bslash>gsw'),
      keys('n', '<Bslash>gsb'),
    },
    config = function()
      require 'gitsigns'.setup {
        signcolumn = false, -- Toggle w :Gitsigns toggle_signs
        -- numhl      = false, -- Toggle w :Gitsigns toggle_numhl
        -- linehl     = false, -- Toggle w :Gitsigns toggle_linehl
        -- word_diff  = false, -- Toggle w :Gitsigns toggle_word_diff
        on_attach = function(bufnr)
          local gitsigns = require 'gitsigns'
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.api.nvim_feedkeys(']c', 'nt', false)
            else
              gitsigns.nav_hunk 'next'
            end
          end, {
            buffer = bufnr,
            desc = 'go to next git hunk'
          })
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk 'prev'
            end
          end, {
            buffer = bufnr,
            desc = 'go to previous git hunk'
          })
          -- Actions
          vim.keymap.set('n',
            '<LocalLeader>hs', gitsigns.stage_hunk, {
              buffer = bufnr,
              desc = 'stage gitsigns hunk'
            })
          vim.keymap.set('x', '<LocalLeader>hs', function()
            gitsigns.stage_hunk {
              vim.fn.line('.'), vim.fn.line('v')
            }
          end, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n',
            '<LocalLeader>hr', gitsigns.reset_hunk, {
              buffer = bufnr,
              desc = 'reset gitsigns hunk'
            })
          vim.keymap.set('x', '<LocalLeader>hr', function()
            gitsigns.reset_hunk {
              vim.fn.line('.'), vim.fn.line('v') }
          end, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hS', gitsigns.stage_buffer, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hu', gitsigns.undo_stage_hunk, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hR', gitsigns.reset_buffer, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hp', gitsigns.preview_hunk, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hb', function()
            gitsigns.blame_line { full = true }
          end, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>tb', gitsigns.toggle_current_line_blame, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hd', gitsigns.diffthis, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>hD', function() gitsigns.diffthis('~') end, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          vim.keymap.set('n', '<LocalLeader>td', gitsigns.toggle_deleted, {
            buffer = bufnr,
            desc = 'stage gitsigns hunk'
          })
          -- git blame
          vim.keymap.set('n', '<LocalLeader>gb', gitsigns.blame_line, {
            buffer = bufnr,
            desc = 'show git blame on current line'
          })
          vim.keymap.set('n', '<LocalLeader>gB', gitsigns.blame, {
            buffer = bufnr,
            desc = 'toggle git blame split'
          })
          -- Text object
          vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {
            buffer = bufnr
          })
        end
      }
      local function toggle(desc, action)
        return function()
          print(desc .. ' ' .. (require'gitsigns'[action]() and 'on' or 'off'))
        end
      end
      vim.keymap.set('n', '<LocalLeader>gss',
        toggle('sign-column signs', 'toggle_signs'), {
        desc = 'toggle gitsigns sign-column signs'
      })
      vim.keymap.set('n', '<LocalLeader>gsn',
        toggle('linenr highlight', 'toggle_numhl'), {
        desc = 'toggle gitsigns linenr highlight'
      })
      vim.keymap.set('n', '<LocalLeader>gsl',
        toggle('inline highlight', 'toggle_linehl'), {
        desc = 'toggle gitsigns inline highlight'
      })
      vim.keymap.set('n', '<LocalLeader>gsw',
        toggle('word diff', 'toggle_word_diff'), {
        desc = 'toggle gitsigns word diff'
      })
      vim.keymap.set('n', '<LocalLeader>gsb',
        toggle('auto git blame', 'toggle_current_line_blame'), {
        desc = 'toggle gitsigns auto git blame'
      })
    end,
  };--<2

  'tweekmonster/helpful.vim';

  { 'OXY2DEV/helpview.nvim',-->2
    requires = { "nvim-treesitter/nvim-treesitter" },
    cond = event('FileType', 'help')
  };--<2

  { 'L3MON4D3/LuaSnip',-->2
    tag = "v2.*",
    run = 'make install_jsregexp',
    cond = {
      keys({'n','i','s'}, '<M-Space>'),
      keys({'n','i','s'}, '<M-h>'),
      keys({'n','i','s'}, '<M-l>'),
      keys({'n','i','s'}, '<M-j>'),
      keys({'n','i','s'}, '<M-k>'),
      cmd 'LuaSnipListAvailable',
      cmd 'LuaSnipUnlinkCurrent',
    },
    config = function()
      local ls = require 'luasnip'
      local cfg = vim.fn.stdpath 'config' ---@cast cfg string
      require 'luasnip.loaders.from_lua'.lazy_load {
        lazy_paths = vim.fs.joinpath(cfg, 'snippets')
      }
      vim.keymap.set({'n','i','s'}, '<M-space>', function()
        if ls.expandable() then ls.expand() end
      end, {
        desc = 'expand luasnip snippet when possible'
      })
      vim.keymap.set({'n','i','s'}, '<M-h>', function()
        if ls.jumpable(-1) then ls.jump(-1) end
      end, {
        desc = 'jump to previous luasnip node'
      })
      vim.keymap.set({'n','i','s'}, '<M-l>', function()
        if ls.jumpable(1) then ls.jump(1) end
      end, {
        desc = 'jump to next luasnip node'
      })
      vim.keymap.set({'n','i','s'}, '<M-j>', function()
        if ls.choice_active() then ls.change_choice(1) end
      end, {
        desc = 'cycle forwards through luasnip node choices'
      })
      vim.keymap.set({'n','i','s'}, '<M-k>', function()
        if ls.choice_active() then ls.change_choice(-1) end
      end, {
        desc = 'cycle backwards through luasnip node choices',
      })
    end,
  };--<2

  { 'dhruvasagar/vim-table-mode',-->2
    cond = event('FileType', 'markdown'),
  };--<2

  { 'iamcco/markdown-preview.nvim',-->2
    run = 'cd app && yarn install',
    config_pre = function()
      vim.g.mkdp_auto_close = 0
    end,
  };--<2

  { 'toppair/peek.nvim',-->2
    run = 'deno task --quiet build:fast',
    cond = {
      cmd 'PeekOpen',
      cmd 'PeekClose',
    },
    config = function()
      require 'peek'.setup {
        -- app = 'firefox'
      }
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
  };--<2

  { 'MeanderingProgrammer/render-markdown.nvim',-->2
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
    },
    cond = event('FileType', 'markdown'),
    config = function()
      require 'render-markdown'.setup {
        enabled = false,
        preset = 'lazy',
        anti_conceal = { enabled = false },
        render_modes = { 'n', 'v', 'i', 'c' },
        heading = {
          position = 'overlay',
          sign = true,
          -- signs = { '󰫎 ' },
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
          width = 'full',
          border = true,
          border_prefix = false,
          above = '▄',
          below = '▀',
        },
        bullet = {
          left_pad = 0,
          right_pad = 0,
        },
        checkbox = {
          enabled = true,
          position = 'inline',
          custom = {
            todo = {
              raw = '[-]',
              rendered = '󰥔 ',
              highlight = 'RenderMarkdownTodo',
              scope_highlight = 'RenderMarkdownTodo',
            },
            fail = {
              raw = '[/]',
              rendered = ' ',
              highlight = 'RenderMarkdownError',
              scope_highlight = 'RenderMarkdownError',
            }
          },
        },
        -- indent = {
        --   enabled = true,
        --   per_level = 2,
        --   skip_level = 0,
        --   skip_heading = true,
        -- },
        win_options = {
          conceallevel = {
            default = 3,
            rendered = 3,
          },
          concealcursor = {
            default = '',
            rendered = 'nvic',
          },
        },
        -- latex = {
        --   enabled = true,
        --   converter = 'latex2text',
        --   highlight = 'RenderMarkdownMath'
        -- },
        -- code = {
        --   enabled = true,
        --   sign = true,
        --   width = 'full',
        -- },
        -- dash = {
        --   enabled = true,
        --   icon = '─',
        --   width = 'full',
        -- }
      }
    end,
  };--<2

  { 'zk-org/zk-nvim',-->2
    config = function()
      require 'zk'.setup()
    end,
  };--<2

  { 'stevearc/oil.nvim',-->2
    requires = {
      -- { 'echasnovski/mini.icons', opts = {} },
      { 'nvim-tree/nvim-web-devicons' },
    },
    cond = event 'UIEnter',
    config = function()
      require 'oil'.setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        -- cleanup_delay_ms = false,
        keymaps = {
          Y = { 'actions.yank_entry', opts = { modify = ':p' } },
          l = {
            function()
              if vim.w.hlNav == false then
                return 'l'
              end
              require 'oil.actions'.select()
              return ''
            end,
            expr = true,
          },
          h = {
            function()
              if vim.w.hlNav == false then
                return 'h'
              end
              require 'oil.actions'.parent()
              return ''
            end,
            expr = true,
          }
        }
      }
      vim.api.nvim_set_keymap('n', '<Leader>dd', "<Cmd>exe'e'empty(expand('%'))?'.':'%:h'<CR>", {})
      vim.api.nvim_set_keymap('n', '<Leader>dv', "<Cmd>exe'bel vs'empty(expand('%')) ? '.' : '%:h'<CR>", {})
      vim.api.nvim_set_keymap('n', '<Leader>dV', "<Cmd>exe'abo vs'empty(expand('%')) ? '.' : '%:h'<CR>", {})
      vim.api.nvim_set_keymap('n', '<Leader>ds', "<Cmd>exe'bel sp'empty(expand('%')) ? '.' : '%:h'<CR>", {})
      vim.api.nvim_set_keymap('n', '<Leader>dS', "<Cmd>exe'abo sp'empty(expand('%')) ? '.' : '%:h'<CR>", {})
    end,
  };--<2

  'tpope/vim-repeat';

  'vim-scripts/ReplaceWithRegister';

  { 'NStefan002/screenkey.nvim',-->2
    cond = cmd 'Screenkey',
    config_pre = function()
      vim.g.screenkey_statusline_component = true
    end,
    config = function()
      require 'screenkey'.setup {
        win_opts = {
          width = vim.fn.winwidth(0),
          title = '',
          height = 1,
          noautocmd = false,
        },
        keys = {
          ['<ESC>'] = '⎋',
        }
      }
      vim.api.nvim_create_user_command('Screenkey', function()
        vim.o.winbar = vim.o.winbar and nil or "%{%v:lua.require('screenkey').get_keys()%}"
      end, {})
    end,
  };--<2

  { 'kylechui/nvim-surround',-->2
    cond = {
      keys('n', 'ys'),
      keys('n', 'ds'),
      keys('n', 'cs'),
      keys('n', 'yS'),
      keys('n', 'cS'),
      keys('i', '<C-g>s'),
      keys('i', '<C-g>S'),
      keys({'n','x'}, 'S'),
      keys('x', 'gS'),
    },
    config = function() require 'nvim-surround'.setup() end,
  };--<2

  { 'godlygeek/tabular',-->2
    cond = {
      cmd 'Tabularize',
      cmd 'GTabularize',
    },
  };--<2

  { 'lervag/vimtex',-->2
    config_pre = function()
      vim.g.vimtex_view_general_viewer = 'zathura'
      vim.g.vimtex_echo_verbose_input = 0
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = function() return './.' .. vim.fn.expand '%:t:r' .. '.out' end,
        out_dir = function() return './.' .. vim.fn.expand '%:t:r' .. '.out' end,
        options = {
          '-shell-escape',
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-emulate-aux-dir',
          '-interaction=nonstopmode',
        },
      }
    end,
  };--<2

  'KeitaNakamura/tex-conceal.vim';

  { 'nvim-treesitter/nvim-treesitter',-->2
    run = function() require 'nvim-treesitter.install'.update { with_sync = true } () end,
    cond = event { 'BufReadPost', 'BufNewFile' },
    config = function()
      -- &ft to 0 or more tree-sitter grammars
      local ft2ts = {
        -- additional ts grammars
        -- (if markdown not in tsFts above, ADD IT HERE)
        { 'regex' },
        -- ft -> ts grammars converstion
        markdown = { 'markdown', 'markdown_inline' },
        tex = { 'latex' },
        lisp = { 'commonlisp' },
        typescript = { 'typescript', 'tsx' },
        lua = { 'lua', 'luadoc' },
        vim = { 'vim', 'vimdoc' },
        javascriptreact = {},
        typescriptreact = {},
      }
      local grammars = ft2ts[1] or {}
      local glen = #ft2ts
      for _, ft in ipairs {
        'markdown', 'c', 'cpp', 'make', 'lisp', 'haskell', 'ocaml', 'lua', 'vim',
        'query', 'json', 'json5', 'yaml', 'toml', 'rasi', 'elixir', 'heex',
        'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html', 'tex',
      } do
        for _, g in ipairs(ft2ts[ft] or {ft}) do
          glen = glen + 1
          grammars[glen] = g
        end
      end
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = grammars,
        sync_install = false,
        highlight = { enable = true, },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<M-i>',
            node_incremental = '<M-i>',
            scope_incremental = '<M-I>',
            node_decremental = '<M-o>',
          },
        },
        matchup = { enable = true, },
      }
    end,
  };--<2

  { 'nvim-treesitter/nvim-treesitter-textobjects',-->2
    requires = { 'nvim-treesitter/nvim-treesitter', },
    cond = event { 'BufReadPost', 'BufNewFile' },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<M-a>'] = '@parameter.inner',
            },
            swap_previous = {
              ['<M-A>'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<Leader>df'] = '@function.outer',
              ['<Leader>dF'] = '@class.outer',
            },
          },
        },
      }
    end,
  };--<2

  { 'andymass/vim-matchup',-->2
    cond = event 'UIEnter',
  };--<2

  { 'VioletJewel/vimterm.nvim',-->2
    cond = event 'UIEnter',
    config = function() require 'vimterm'.setup() end,
  };--<2

  { 'folke/zen-mode.nvim',-->2
    cond = {
      keys('n', '<Bslasz'),
      cmd 'ZenMode',
    },
    config = function()
      require 'zen-mode'.setup()
      vim.keymap.set('n', '<LocalLeader>z', function() require 'zen-mode'.toggle() end)
    end,
  };--<2

  -->2 themes

  { 'folke/tokyonight.nvim',-->3
    config = function()
      require 'utils'.augroup 'VioletTheme' { 'UIEnter', callback = function()
        -- vim.cmd.syntax 'reset'
        vim.cmd.colorscheme 'tokyonight'
        vim.cmd.doautocmd { args = { 'colorscheme', 'tokyonight' } }
      end }
    end,
  };--<3

  'rebelot/kanagawa.nvim';

  'catppuccin/nvim';

  'lifepillar/gruvbox8';

  'sainnhe/sonokai';

  'dracula/vim';

  'owickstrom/vim-colors-paramount';

  'violetjewel/color-nokto';

  'violetjewel/color-vulpo';

  'navarasu/onedark.nvim';

  'gbprod/nord.nvim';

  -- 'b0o/lavi.nvim';

  --<2

}--<1
