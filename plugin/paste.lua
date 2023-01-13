-- Author: Violet
-- Last Change: 04 June 2022

-- Usage:
--   <leader>BB ------------------ paste current line to {paste-site}
--   {visual}<leader>B ----------- paste proper visual selection to {paste-site}
--   <leader>B{text-object} ------ paste {text-object} to {paste-site}
--   :{range}Pastebin [{name}] --- paste {range} (default: %) to {paste-site}
--   :Pbset {name} <tab> --------- change {paste-site} to {name} globally
--   :Pbset! {name} <tab> -------- change {paste-site} to {name} for buffer
--
-- {paste-site} refers to the name of a papstebin site (like ix.io, etc). The
-- :Pastebin command accepts an optional {name} which overrules the default or
-- user-defined {paste-site}. For mappings or :Pastebin with no arguments,
-- {paste-site} is defined by b:pastebin followed by g:pastebin. You can use
-- :Pbset to change g:pastebin and :Pbset! to change b:pastebin. :Pbset provides
-- simple tab completion for supported paste sites. By default, ix.io is used,
-- since it supports highlighting languages and has good defaults. Only vpaste
-- and ix support language highlighting. When a paste is succesfully uploaded, @+
-- register is set and a message is echoed.
--
-- If an error occurs, you will see it in the command-line, but if you close it,
-- type :messages to further investigate. If there is no output from the paste
-- site, then you're notified. If there is another error, then you will see the
-- output, and each line will be preceded by a vertical pipe ('|') and
-- highlighted with ErrorMsg.
--
-- Example:
--   :Pbset vpaste --- change {paste-site} to vpaste.net
--   <leader>Bip ----- paste paragraph to vpaste.net
--   :Pbset envs ----- change {paste-site} to envs.sh
--   :Pastebin ------- paste entire buffer to envs.sh
--   <c-v>$4j -------- paste visual-block (correctly) to envs.sh
--
-- Config:
--   g:pastebin ---- changes the default {paste-site} globally (default: 'ix')
--   b:pastebin ---- changes the default {paste-site} for current buffer;
--            +----- you probably want to set this in an autocmd - not in init
--   g:pasteopen --- open a successful paste with xdg-open (default: 1)
--   b:pasteopen --- like g:pasteopen but for a buffer
--
-- Supported Paste Sites:
--   ix      -> http://ix.io        -> supports highlighting (default)
--   sprunge -> http://sprunge.us   -> supports highlighting
--   vpaste  -> http://vpaste.net   -> supports highlighting
--   clbin   -> https://clbin.com
--   envs    -> https://envs.sh
--   termbin -> https://termbin.com

local map = require'utils'.map
local cmd = vim.api.nvim_create_user_command
local opts

map{ '<L>B', ':<c-u>set opfunc=paste#bin<cr>g@', silent=true }
map{ '<L>B', ':<c-u>call paste#bin(visualmode())<cr>', modes='x', silent=true}
map{ '<L>BB', 'V<space>B', silent=true, remap=true }

opts = { bang=false, complete='customlist,paste#complete', range='%', nargs='?', bar=true }
cmd('Pastebin', "call paste#bin('command', <line1>, <line2>, <q-args>)", opts)

opts = { bang=true, complete='customlist,paste#complete', nargs=1, bar=true }
cmd('Pbset', "execute 'let' (<bang>0 ? 'b:' : 'g:')..'pastebin = <q-args>'", opts)

