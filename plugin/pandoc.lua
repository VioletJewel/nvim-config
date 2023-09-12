-- Author: Violet
-- Last Change: 11 September 2023

local au = require'utils'.augroup'VioletPandoc'
local cmd = function(...) vim.api.nvim_buf_create_user_command(0, ...) end

local pandoc_t = {}
local pdf_t = {}

local default_template = 'eisvogel' -- ~/.pandoc/templates/eisvogel.latex
local default_pdf_viewer = {'zathura', '--fork', '{}'}

au{ 'BufWritePost',
  desc     = 'auto `!Pandoc %` on :write for *.md',
  pattern  = '*.md',
  callback = function()
    if not vim.g.no_pandoc and not vim.b.no_pandoc and vim.fn.getline(1) == '---' then
      vim.cmd.Pandoc()
    end
  end,
}

au{ 'Filetype',
  pattern = 'markdown',
  callback = function()

    cmd('Pandoc', function()
        local inf = vim.fn.expand('%')
        if inf:sub(-3) ~= '.md' then
          return
        end
        local outf = vim.fn.expand('%:r')..'.pdf'
        local templ = vim.b.pandoc_template or vim.g.pandoc_template or default_template
        local ecmd
        flags = vim.b.pandoc_flags or vim.g.pandoc_flags or nil

        local function pandoc_exit(s)
          if s.code ~= 0 then
            print(":Pandoc failed:", s.stderr)
            return
          end
          pandoc_t[outf] = nil
          print('Pandoc compiled successfully')
          if vim.b.pandoc_open_pdf ~= false and vim.g.pandoc_open_pdf ~= false and pdf_t[outf] == nil then
            ecmd = vim.b.pandoc_pdf_viewer or vim.g.pandoc_pdf_viewer or default_pdf_viewer
            for i,c in ipairs(ecmd) do
              ecmd[i] = c:format(outf)
            end
            pdf_t[outf] = vim.system(ecmd)
          end
        end

        if pandoc_t[outf] ~= nil then
          vim.cmd.redraw()
          print(':Pandoc killed by :write')
          pandoc_t[outf]:kill()
        end

        if templ:match'^%s*$' then
          ecmd = {
            'pandoc',
            '--from', 'markdown',
            '--listings',
            '-o', outf,
            inf,
          }
        else
          ecmd = {
            'pandoc',
            '--from', 'markdown',
            '--template', templ,
            '--listings',
            '-o', outf,
            inf,
          }
        end

        if flags ~= nil then
          for _,f in ipairs(flags) do
            table.insert(ecmd, #ecmd, f)
          end
        end


        pandoc_t[outf] = vim.system( ecmd, nil, pandoc_exit )
      end, {
        nargs=0
      })

    cmd('PandocOff', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.no_pandoc = true
      end, {
        desc = 'Set no_pandoc = 1 for buffer or globally (with bang)',
        bang = true,
        nargs = 0
      })

    cmd('PandocOn', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.no_pandoc = nil
      end, {
        desc = 'Set no_pandoc = nil for buffer or globally (with bang)',
        bang = true,
        nargs = 0
      })

    cmd('PandocPdfOpenOff', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.pandoc_open_pdf = false
      end, {
        desc = 'Set no_pandoc = 1 for buffer or globally (with bang)',
        bang = true,
        nargs = 0
      })

    cmd('PandocPdfOpenOn', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.no_pandoc = nil
      end, {
        desc = 'set no_pandoc = nil for buffer or globally (with bang)',
        bang = true,
        nargs = 0
      })

    cmd('PandocTemplate', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.pandoc_template = opts.args
      end, {
        desc = 'Set pandoc template to <args> for buffer or globally (with bang)',
        bang = true,
        nargs = 1
      })

    cmd('PandocTemplateDisable', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.pandoc_template = ''
      end, {
        desc = 'Disable pandoc template for buffer or globally (with bang)',
        bang = true,
        nargs = 0
      })

    cmd('PandocFlags', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.pandoc_flags = opts.fargs
      end, {
        desc = '',
        bang = true,
        nargs = '+'
      })

    cmd('PandocFlagsDisable', function(opts)
        local d = opts.bang and vim.g or vim.b
        d.pandoc_flags = nil
      end, {
        desc = '',
        bang = true,
        nargs = 0
      })

  end

}

