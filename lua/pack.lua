local M = {}


--- @type string
local home = os.getenv 'HOME' --[[@as string]]

--- @type string
local luaVersion = _VERSION:gsub('Lua ', '')

--- @class (exact) Pack.StdPath
---
--- @field config string
--- @field data string
--- @field log string
--- @field run string
--- @field state string
--- @field cache string
--- @field c string config
--- @field d string data
--- @field l string log
--- @field r string run
--- @field s string state
--- @field h string cache

--- @type table<string, string|true>
local stdpathLookup = {
  config = true,
  c      = 'config',
  data   = true,
  d      = 'data',
  log    = true,
  l      = 'log',
  run    = true,
  r      = 'run',
  state  = true,
  s      = 'state',
  cache  = true,
  h      = 'cache',
}

--- @type Pack.StdPath
local stdpath = setmetatable({}, {
  __index = function(tbl, key)
    local val = rawget(stdpathLookup, key)
    if val == true then
      val = vim.fn.stdpath(key)
      rawset(tbl, key, val)
      return val
    end
    val = tbl[val]
    rawset(tbl, key, val)
    return val
  end,
})


--- @class (exact) Pack.Opts
---
--- @field dataDir string
--- @field specPath string
--- @field luarocksPath string
--- @field packagePath string

--- @type table<string, string|true>
local defaultOpts = {

  -- TODO: changeme after we manage
  -- directory for plugins (git repos, etc)
  dataDir = stdpath.d .. '/site/pack/pckr/opt',

  -- These Opts Paths are strings containing information about zero or more
  -- paths used to load lua packages or user configuration. This system draws
  -- wisdom from lua's builtin package management system. For example, '?' in
  -- package.path is replaced by the package name in `require('name')` (with
  -- periods replaced with path separators) during loading. These Opts Paths
  -- have additional symbols that are normalized during loading. They are
  -- described here:
  --   '@<str>' =  stdpath('<str>'); only makes sense at beginning
  --               - c/config, d/data, l/log, r/run, s/state, h/cache
  --               - eg: @data/pack/
  --   '#'      = current lua version,
  --              - eg: ~/.luarocks/share/lua/#/?/init.lua
  --   '!'      = opts.dataDir
  --   '*'      = any directory; can't be like /*suf/ or /pre*/; only /*/
  --              - eg: !/*/lua/?/init.lua
  --   ';;'     = default *Path; same as package.path
  --              - eg: ;;~/nvim/plugins/
  --   '?'      = required name; same as package.path, package.searchpath(), etc
  -- paths for user plugin specifications
  specPath = '@c/lua/plugins',
  -- paths for luarocks packages
  luarocksPath = '~/.luarocks/share/lua/#/?/init.lua;~/.luarocks/share/lua/#/?.lua',
  -- paths for pack packages
  packagePath = '!/*/lua/?/init.lua;!/*/lua/?.lua',
}

--- @type Pack.Opts
local opts = setmetatable({}, {
  __index = function(tbl, key)
    local val = rawget(defaultOpts, key)
    rawset(tbl, key, val)
    return val
  end,
  __metatable = 'Pack Opts'
})

local state = {
  packages = {}
}

local function normalizePath(pathKey)
  local path = opts[pathKey]
  local def = rawget(defaultOpts, pathKey)
  return path
      :gsub(';;', def)
      :gsub('@(%w+)', function(p) return stdpath[p] end)
      :gsub('^~/', home .. '/')
      :gsub(';~/', ';' .. home .. '/')
      :gsub('#', luaVersion)
      :gsub('!', opts.dataDir)
end

local function readDirIter(path, ftype, fullpath)
  if not vim.uv.fs_access(path, 'X') then return end
  local err
  local dir
  --- @diagnostic disable-next-line: param-type-mismatch
  dir, err = vim.uv.fs_opendir(path, nil, 100)
  --- @type table<string,string>[]|nil
  local entries = {}
  local entriesInd = 0
  local entriesLen = 0
  local prefix = fullpath and path:gsub('/+$', '') .. '/' or ''
  if not dir then return end
  return function()
    while true do
      if entriesInd == entriesLen then
        entries, err = vim.uv.fs_readdir(dir)
        if err then return end
        if entries == nil then
          return nil
        end
        entriesInd = 0
        entriesLen = #entries
      end
      entriesInd = entriesInd + 1
      --- @diagnostic disable-next-line: need-check-nil
      local entry = entries[entriesInd]
      if ftype == nil or ftype == entry.type then
        return prefix .. entry.name
      end
    end
  end
end

--- @param name string
--- @return function|string?
local function loader(name)
  local base = name:gsub('%.', '/')
  local starPaths = {}
  local starPathsInd = 0
  local starPathsLen = 0
  local searched = {}

  for pkgPath in (normalizePath 'packagePath' .. ';' .. normalizePath 'luarocksPath')
  :gsub('%?', base)
  :gmatch '[^;]+' do
    starPathsLen = starPathsLen + 1
    starPaths[starPathsLen] = pkgPath
  end

  while starPathsInd < #starPaths do
    starPathsInd = starPathsInd + 1
    local path = starPaths[starPathsInd]
    local starInd = path:find '/%*/'
    if starInd then
      local prefix = path:sub(1, starInd)
      local suffix = path:sub(starInd + 2)
      if searched[prefix] then
        for _, dir in ipairs(searched[prefix]) do
          starPathsLen = starPathsLen + 1
          starPaths[starPathsLen] = dir .. suffix
        end
      else
        local cache = {}
        local cacheLen = 0
        for dir in readDirIter(prefix, 'directory', true) do
          starPathsLen = starPathsLen + 1
          starPaths[starPathsLen] = dir .. suffix
          cacheLen = cacheLen + 1
          cache[cacheLen] = dir
        end
        searched[prefix] = cache
      end
    else
      if vim.uv.fs_access(path, 'R') then
        local f, err = loadfile(path)
        if f then
          _PackPath = path
          return f
        else
          _PackPath = nil
          return err
        end
      end
    end
  end
  _PackPath = nil
end

if _PackInjectedLoader == nil then
  _PackInjectedLoader = true

  local function loadPackage(pkg)
    if pkg.config_pre then
      pkg:config_pre()
    end
    if pkg.config then
      pkg:config()
    elseif pkg.loaded.setup and pkg.setup ~= false then
      pkg.loaded.setup(pkg.setup)
    end
  end

  rawrequire = require
  function require(name)
    local r = require
    require = rawrequire
    local req = require(name)
    require = r
    if _PackPath then
      local base = name:gsub('%.', '/')
      local pkg
      for pkgPath in normalizePath 'packagePath'
      :gsub('%?', base)
      :gmatch '[^;]+' do
        local path = _PackPath:match('(' .. vim.pesc(pkgPath):gsub('/%%%*/', '/[^/]+)/'))
        if path then
          pkg = state.packages[path]
          if pkg then
            pkg.loaded = req
            -- loadPackage(pkg) -- TODO
          end
          break
        end
      end
      _PackPath = nil
    end
    return pkg
  end

  vim.loader.disable()

  table.insert(package.loaders, 2, loader)
end

local function loadSpec(spec)
  spec.uri = spec.uri or table.remove(spec, 1)
  if not spec.uri then
    return 'Empty URI'
  end
  -- vim.print(spec)
  if spec.uri:sub(1, 2) == '~/' or spec.uri:sub(1, 1) == '/' then
    spec.type = 'file'
    spec.as = vim.fs.basename(spec.uri)
    spec.path = spec.uri
  else
    local gituser, reponame = spec.uri:match '^([^/]+)/([^/]+)$'
    if gituser and reponame then
      spec.type = 'git'
      spec.as = spec.as or reponame
      spec.path = opts.dataDir .. '/' .. spec.as
    elseif spec.uri:find '^https?://' then
      spec.type = 'url'
      spec.as = spec.uri:gsub('.*/', ''):gsub('%?.*', ''):gsub('%.git$', '')
      spec.path = opts.dataDir .. '/' .. spec.as
    else
      return 'Invalid URI specification: ' .. spec.uri
    end
  end
  spec.pathexists = vim.uv.fs_access(spec.path, 'R')
  -- if spec.path:match 'oil' then
  --   vim.print('**', spec)
  -- end
  return spec
end

--- Load user plugin specifications based on opts.specPath
function M.loadPluginSpecs()
  state.packages = {}
  for specDir in normalizePath 'specPath':gmatch '[^;]+' do
    for specFile in readDirIter(specDir, 'file', true) do
      if not specFile:find '/init%.lua$' and specFile:find '%.lua$' then
        local f, err = loadfile(specFile)
        if f then
          local specs = f()
          if type(specs) == 'table' and #specs > 0 then
            for _, spec in ipairs(type(specs[1]) == 'table' and specs or { specs }) do
              local pspec = loadSpec(spec)
              state.packages[pspec.path] = pspec
            end
          end
        else
          print('Error loading plugin', specFile, err)
        end
      end
    end
  end
end

--- @class (exact) Pack.KeySpec
--- @field [1] string lhs
--- @field [2]? string|function rhs
--- @field mode? string|string[]
--- @field noremap? boolean
--- @field nowait? boolean
--- @field silent? boolean
--- @field script? boolean
--- @field expr? boolean
--- @field unique? boolean
--- @field callback? function
--- @field desc? string
--- @field replace_keycodes? boolean

--- @class (exact) Pack.RockSpec
--- @field [1] string
--- @field withArgs? string

--- @alias Pack.Key string|Pack.KeySpec
--- @alias Pack.Cmd string|[string,string|function]
--- @alias Pack.Event string|[string,string]|[string,string[]]|[string,function]

--- @class (exact) Pack.UserSpec
--- @field [1]? string uri
--- @field uri? string alternative uri
--- @field as? string
--- @field rtp? string|function
--- @field rocks? Pack.RockSpec|Pack.RockSpec[]
--- @field lazy? boolean
--- @field setup? boolean|table
--- @field globals? [string,any][]
--- @field requires? string|string[]
--- @field run? string|function
--- @field config_pre? string|function
--- @field config? string|function
--- @field keys? Pack.Key|Pack.Key[]
--- @field cmds? Pack.Cmd|Pack.Cmd[]
--- @field fts? string|string[]
--- @field events? Pack.Event|Pack.Event[]

-- --- @type Pack.UserSpec
-- local exampleSpec = {
--   'plugin/nvim-name',
--   as = 'name',
--   rtp = function(rtp) return rtp .. '/vim' end, -- same as 'vim',
--   rocks = { 'magick', withArgs = '--dev', foo='bar' },
--   lazy = true, -- :LazyLoad can load, but `keys`, `cmds`, `events`, and even `require` will also load
--   -- setup = true, -- try to call plugin.setup()
--   setup = { opt1 = true, opt2 = { 'a', 'b' } }, -- try to call plugin.setup(setup)
--   requires = { 'another/plugin' }, -- not required because lazy `require`
--   run = nil,
--   config_pre = nil,
--   config = function(plugin, options)
--     if not plugin.loaded and plugin.lazy and plugin.loaded.setup then
--       plugin.loaded.setup(options)
--     end
--   end,
--   keys = { '<Space>a', { '<Space>b', "<Cmd>echo 'hi'<CR>" }, { '<Space>c', function() end } },
--   cmds = { 'DoA', { 'DoB', "echo 'hi'" }, },
--   fts = { 'c', 'bash', 'zsh', 'sh' },
--   events = { 'UIEnter', { 'FileType', 'c' }, { 'FileType', { 'bash', 'zsh', 'sh' } }, { 'OptionSet', function(evt) print(evt) end }, },
-- }
-- vim.print(exampleSpec)

return M
