local M = {}

local figfonts = {}
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

local function borderify(lines, maxline)
  local flines = vim.iter(lines)
      :map(function(line)
        return string.format('│%-' .. maxline .. 's│', line)
      end)
      :totable()
  table.insert(flines, 1, '╭' .. string.rep('─', maxline) .. '╮')
  table.insert(flines, '╰' .. string.rep('─', maxline) .. '╯')
  vim.print(flines)
  return flines
end

function M.figlet(args, border, cb)
  local stdout = assert(vim.uv.new_pipe())
  local lines = {}

  ---@diagnostic disable-next-line: missing-fields
  local handle = vim.uv.spawn('figlet', {
    args = vim.iter { '-w', vim.o.columns, args }:flatten():totable(),
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
      cb(border and borderify(lines, maxline) or lines)
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
end

function M.completion(_, line, pos)
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
end

function M.getfonts()
  return vim.list_slice(figfonts)
end

return M
