local lo = vim.opt_local

lo.concealcursor = ''
lo.conceallevel = 0

lo.formatoptions:append '2'
lo.formatoptions:append 'n'

lo.foldlevel = 0

lo.softtabstop = 2
lo.tabstop = 2
lo.shiftwidth = 2

local todo_items = ' x/-'

vim.keymap.set('n', '<Tab>', function() -->
  local lr = vim.go.lazyredraw
  vim.go.lazyredraw = true
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find('^%s*- %[[' .. todo_items .. ']%]')
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = todo_ind % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
  vim.go.lazyredraw = lr
  vim.cmd.redraw()
end, {
  buffer = true,
  silent = true,
  desc = 'Cycle through markdown things!'
})                                        --<

vim.keymap.set('n', '<S-Tab>', function() -->
  local line = vim.api.nvim_get_current_line()
  local _, beg = line:find('^%s*- %[[' .. todo_items .. ']%]')
  if beg then
    local todo_ind = todo_items:find(line:sub(beg - 1, beg - 1))
    local char_ind = (todo_ind - 2) % todo_items:len() + 1
    local char = todo_items:sub(char_ind, char_ind)
    vim.api.nvim_set_current_line(line:sub(1, beg - 2) .. char .. line:sub(beg))
  end
end, {
  buffer = true,
  silent = true,
  desc = 'Cycle backwards through markdown things!'
}) --<

local function getLink()
  local node = require 'nvim-treesitter.ts_utils'.get_node_at_cursor()
  if not node then return end
  local link, linkType
  if node:type() == 'inline_link' then
    -- [desc](link)
    -- ^    ^^    ^
    link = node:child(4)
    linkType = 'inline_link'
  elseif node:type() == 'link_text' then
    -- [desc](link)  [[shortcut]]
    --  ^^^^           ^^^^^^^^
    local parent = node:parent()
    if parent:type() == 'shortcut_link' then
      link = parent:child(1)
      linkType = 'shortcut_link'
    elseif parent:type() == 'inline_link' then
      link = node:parent():child(4)
      linkType = 'inline_link'
    end
  elseif node:type() == 'link_destination' then
    -- [desc](link)
    --        ^^^^
    link = node
    linkType = 'inline_link'
  elseif node:type() == 'inline' and node:child_count() > 2 then
    local cur = vim.api.nvim_win_get_cursor(0)
    cur[1] = cur[1] - 1 -- 0-based lines in ts
    cur[2] = cur[2] + 1 -- get next column node
    local nextColNode = vim.treesitter.get_node { pos = cur, ignore_injections = false }
    if nextColNode and nextColNode:type() == 'shortcut_link' then
      -- [[shortcut]]  other inline text
      -- ^          ^
      link = nextColNode:child(1)
      linkType = 'shortcut_link'
    end
  elseif node:type() == 'shortcut_link' then
    --
    link = node:child(1)
    linkType = 'shortcut_link'
  end
  return link and vim.treesitter.get_node_text(link, 0), linkType
end

vim.keymap.set('n', '<CR>', function()
  local params = vim.lsp.util.make_position_params(0)
  local def = vim.lsp.buf_request_sync(0, 'textDocument/definition', params, 2000)
  print('dev', vim.inspect(def))
  if def and def[1] and def[1].result then
    -- if there is a valid definition under the cursor, go to it
    vim.lsp.buf.definition()
    return
  end
  -- there is no definition under the cursor
  local link, linkType = assert(getLink())
  local stat = vim.uv.fs_stat(link)
  local bufname = vim.api.nvim_buf_get_name(0)
  if not stat or stat.type == 'directory' or link:sub(-1, -1) == '/' then
    if bufname:find '/index%.md$' then
      -- if current file is an index, the definition doesn't exist and is a
      -- directory, then assume it is also an index
      link = link:gsub('/+$', '') .. '/index.md'
    end
  end
  if not vim.fs.basename(link):find '^%.*.+%.%a+$' then
    -- if there is no suffix, append '.md'
    link = link .. '.md'
  end

  local function cb(path)
    if not path then return end
    vim.cmd.edit(path)
    if linkType == 'shortcut_link' and vim.api.nvim_buf_line_count(0) then
      path = path:gsub('%.md$', ''):gsub('/index', '')
      vim.api.nvim_buf_set_lines(0, 0, 1, true, { '# ' .. path, '', '' })
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
    end
  end

  if stat then
    cb(link)
  else
    vim.ui.input({
      prompt = 'Edit File:',
      default = link,
      completion = 'file'
    }, cb)
  end
end, {
  buffer = true,
  silent = true,
  desc = 'Go to definition or create file'
})

local function pf(f, ...) print(string.format(f, ...)) end
local function nt(n) return vim.treesitter.get_node_text(n, 0) end
local function pn(n)
  if not n then
    print 'No node'
    return
  end
  local p = n:parent()
  local np = n:prev_sibling()
  local nn = n:next_sibling()
  local npn = n:prev_named_sibling()
  local nnn = n:next_named_sibling()
  local cc = n:child_count()
  local rsr, rsc, rer, rec = n:range()
  pf('node[%d]: (%s) %s %d:%d => %d:%d', cc, n:type(), nt(n), rsr, rsc, rer, rec)
  if rsc == 0 then
    print '(no before node; start of line)'
  else
    local bn = vim.treesitter.get_node { pos = { rsr, rsc - 1 } }
    if bn then
      pf('before node: (%s) %s', bn:type(), nt(bn))
    else
      print '(no before node)'
    end
  end
  if p then pf('parent: (%s) %s', p:type(), nt(p), p) end
  if np then pf('prev sib: (%s) %s', np:type(), nt(np), np) end
  if nn then pf('next sib: (%s) %s', nn:type(), nt(nn), nn) end
  if npn then pf('prev sib: (%s) %s', npn:type(), nt(npn), npn) end
  if nnn then pf('next sib: (%s) %s', nnn:type(), nt(nnn), nnn) end
  for i = 0, cc - 1 do
    local c = n:child(i)
    pf('child[%d]: (%s) %s', i, c:type(), nt(c))
  end
  print(string.rep('=', 20))
end

if not figfonts then
  figfonts = {}

  local figfontignore = {}
  vim.iter(vim.gsplit([[
1943____ 4x4_offr 5x8 64f1____ advenger aquaplan assalt_m asslt__m atc_____
atc_gran a_zooloo battle_s battlesh baz__bil beer_pub binary b_m__200 briteb
britebi brite britei bubble_b bubble bubble__ bulbhead c1______ c2______
caus_in_ c_consen char1___ char2___ char4___ charact1 charact3 charact4 charact5
charact6 characte charset_ chartr chartri clr4x6 clr5x10 clr5x6 clr5x8 coil_cop
computer com_sen_ convoy__ cosmike cybersmall dcs_bfmo d_dragon decimal deep_str
demo_1__ demo_2__ demo_m__ devilish digital dosrebel drpepper druid___ dwhistled
ebbs_2__ eca_____ e__fist_ eftichess eftifont eftipiti eftirobot eftitalic
eftiwall eftiwater etcrvs__ faces_of fairligh fair_mea fantasy_ fbr12___
fbr1____ fbr2____ fbr_stri fbr_tilt finalass fireing_ flyn_sh fourtops fp1_____
fp2_____ funky_dr future_1 future_2 future_3 future_4 future_5 future_6 future_7
future_8 gauntlet ghost_bo gothic__ graceful grand_pr green_be hades___ heavy_me
heroboti hex high_noo hills___ home_pak house_of hypa_bal hyper___ inc_raw_
italic italics_ ivrit jerusalem joust___ katakana kgames_i kik_star krak_out
l4me lazy_jon lcd letterw3 letter_w lexible_ mad_nurs madrid magic_ma master_o
maxfour mayhem_d mcg_____ mig_ally mike mini mirror mnemonic modern__ moscow
mshebrew210 new_asci nfi1____ notie_ca ntgreek octal odel_lak ok_beer_ outrun__
pacos_pe panther_ pawn_ins pepper phonix__ platoon2 platoon_ pod_____ p_s_h_m_
p_skateb pyramid r2-d2___ rad_____ rad_phan rainbow_ rally_s2 rally_sp rampage_
rastan__ raw_recu rci_____ ripper!_ road_rai rockbox_ rok_____ roman___ rot13
runic runyc serifcap skateord skateroc skate_ro sketch_s slide sm______ smisome1
smkeyboard smtengwar space_op spc_demo star_war stealth_ stencil1 stencil2 stop
straight street_s subteran super_te tav1____ taxi____ tec1____ tec_7000 tecrvs__
tengwar term ti_pan__ t__of_ap tomahawk tombstone top_duck trashman triad_st
ts1_____ tsalagi tsm_____ tsn_base twopoint type_set ucf_fan_ ugalympi unarmed_
usa_____ usa_pq__ vortron_ war_of_w weird xbriteb xbritebi xbrite xbritei
xchartr yie-ar__ yie_ar_k zig_zag_ zone7___ z-pilot_
]], '%s+')):each(function(font)
    figfontignore[font] = true
  end)

  do
    (function()
      local dir, err = vim.uv.fs_opendir('/usr/share/figlet/fonts/')
      if dir == nil or err then return end
      while true do
        local entries
        entries, err = vim.uv.fs_readdir(dir)
        if entries == nil or err then
          figfonts = vim.iter(figfonts):flatten(1):totable()
          table.sort(figfonts)
          return vim.uv.fs_closedir(dir)
        end
        figfonts[#figfonts + 1] = vim.iter(entries)
            :filter(function(e) return e.type == 'file' and e.name:find '%.flf$' end)
            :map(function(e)
              local n = e.name:gsub('%.flf$', '')
              if figfontignore[n] then return nil end
              return n
            end)
            :totable()
      end
    end)()
  end
end

local function borderify(lines, maxline)
  local flines = vim.iter(lines)
      :map(function(line)
        return string.format('│%-' .. maxline .. 's│', line)
      end)
      :totable()
  table.insert(flines, 0, '╭' .. string.rep('─', maxline) .. '╮')
  table.insert(flines,    '╰' .. string.rep('─', maxline) .. '╯')
  vim.print(flines)
  return flines
end

vim.api.nvim_buf_create_user_command(0, 'Figlet', function(opts)
  local stdout = assert(vim.uv.new_pipe())
  local lines = {}

  ---@diagnostic disable-next-line: missing-fields
  local handle = vim.uv.spawn('figlet', {
    args = vim.iter { '-w', vim.o.columns, opts.fargs }:flatten():totable(),
    stdio = { nil, stdout, nil },
    verbatim = true,
    detached = false,
  }, function(code)
    if code ~= 0 then return end
    local maxline = 0
    lines = vim.iter(vim.gsplit(table.concat(lines, ''), '\n'))
        :map(function(line)
          line = line:gsub('%s+$', '')
          if line == '' then return nil end
          if #line > maxline then maxline = #line end
          return line
        end)
        :totable()
    vim.schedule(function()
      local l = opts.line1
      vim.api.nvim_buf_set_lines(0, l, l, true, { '```', '```' })
      l = l + 1
      if opts.bang then
        lines = borderify(lines, maxline)
      end
      vim.api.nvim_buf_set_lines(0, l, l, true, lines)
      vim.api.nvim_win_set_cursor(0, { l, 0 })
    end)
  end)

  vim.uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      lines[#lines + 1] = data
    end
  end)

  vim.uv.shutdown(stdout, function()
    vim.uv.close(handle, function() end)
  end)
end, {
  nargs = '+',
  bang = true,
  complete = function(_, line, pos)
    line = line:sub(1, pos)
    local f = line:match ' -f +(%w*)$'
    if f then
      return vim.iter(figfonts)
          :filter(function(font) return vim.startswith(font, f) end)
          :totable()
    elseif line:find ' %-$' then
      return {
        '-c', '-d', '-f', '-k', '-l', '-m', '-n', '-o', '-p', '-r', '-s', '-t',
        '-v', '-w', '-x', '-C', '-D', '-E', '-I', '-L', '-N', '-R', '-S', '-W',
        '-X'
      }
    end
  end,
  count = true,
})


vim.api.nvim_buf_create_user_command(0, 'FigletFzf', function(opts)
  -- local figs = vim.iter(figfonts):map(function(font)
  --   return "figlet -f " .. font .. 'Test 123'
  -- end)
  require 'fzf-lua'.fzf_exec(figfonts, {
    preview = 'figlet -f {} Test 123'
  })
end, {
})


-- for debugging
vim.keymap.set('n', '<Leader><CR>', function()
  -- vim.cmd.mess 'clear'
  local n = require 'nvim-treesitter.ts_utils'.get_node_at_cursor(0)
  pn(n)
  -- pn(n:parent())
  -- pn(n:prev_sibling() and n:prev_sibling():prev_sibling())
  vim.api.nvim__redraw { flush = true, statusline = true }
  local mess = vim.api.nvim_replace_termcodes(':mess<CR>', true, true, true)
  vim.api.nvim_feedkeys(mess, 'nt!', false)
end, { buffer = true, silent = false })

--> undo_ftplugin
vim.b.undo_ftplugin = table.concat(vim.tbl_map(function(t)
  return "exe 'sil! " .. t[1] .. ' <buffer> ' .. t[2] .. "'"
end, {
  { 'nunmap', '<Tab>' },
  { 'nunmap', '<S-Tab>' },
}), '|') --<
