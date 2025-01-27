local M = {}

local relDateLookup = {
  d = 'day', day = 'day', days = 'day',
  w = 'week', week = 'week', weeks = 'week',
  m = 'month', month = 'month', months = 'month',
  y = 'year', year = 'year', years = 'year',
  D = 'decade', decade = 'decade', decades = 'decade',
  c = 'century', century = 'century', centuries = 'century',
  M = 'millenium', millenium = 'millenium', millenia = 'millenium',
}

local function relDateAdd(date, typ, amt)
  typ = relDateLookup[typ]
  if typ == nil then
    return
  end
  date[typ] = (date[typ] or 0) + amt
  return true
end

--- @class RelDate
--- @field day integer
--- @field year integer
--- @field month integer
--- @field hour integer
--- @field min integer
--- @field sec integer
--- @field wday integer
--- @field yday boolean
--- @field decade? integer
--- @field century? integer
--- @field millenium? integer

--- @return integer, string?
function M.relDateToTime(date)
  local now = os.date '*t' --[[@as RelDate]]
  local m
  local err

  if date == 'today' or date == '' then
    goto relDateDone
  end

  if date == 'yesterday' then
    now.day = now.day - 1
    goto relDateDone
  end

  if date == 'tomorrow' then
    now.day = now.day + 1
    goto relDateDone
  end

  m = date:match '^a +(%a+) +ago$'
  if m then
    if relDateAdd(now, m, -1) == nil then
      err = 'invalid RelDate: ' .. date
    end
    goto relDateDone
  end

  m = date:match '^in +a +(%a+)$'
  if m then
    if relDateAdd(now, m, 1) == nil then
      err = 'invalid RelDate: ' .. date
    end
    goto relDateDone
  end

  m = date:match '^(.-) +ago$'
  if m then
    for n, d in m:gmatch '(%d+)%s*(%a+)' do
      if relDateAdd(now, d, -tonumber(n)) == nil then
        err = 'invalid RelDate: ' .. date
        break
      end
    end
    goto relDateDone
  end

  m = date:match '^in +(.-)$'
  if m then
    for n, d in m:gmatch '(%d+)%s*(%a+)' do
      if relDateAdd(now, d, tonumber(n)) == nil then
        err = 'invalid RelDate: ' .. date
        break
      end
    end
    goto relDateDone
  end

  ::relDateDone::
  if err then
    return os.time(), err
  end
  now.year = now.year + (now.decade or 0) * 10 + (now.century or 0) * 100 + (now.millenium or 0) * 1000
  now.decade = nil
  now.century = nil
  now.millenium = nil
  return os.time(now --[[@as osdateparam]])
end

return M
