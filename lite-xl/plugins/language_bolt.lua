-- mod-version:3
local syntax = require "core.syntax"

--[[
Here is the list of all pattern types which could be used in themes:

    normal
    symbol
    comment
    keyword
    keyword2
    number
    literal
    string
    operator
    function

Here you can see which colors are used for each pattern in your chosen theme:
    https://github.com/lite-xl/lite-xl/tree/master/data/colors
    https://github.com/lite-xl/lite-xl-colors/tree/master/colors
A useful website for visualizing the color palette:
    https://coolors.co/e1e1e6-676b6f-e58ac9-f77483-ffa94d-f7c95c-93ddfa
        Gleam color palette:
            https://coolors.co/ffd596-9ce7ff-ffddfa-f0eeff-c8ffa7-1e1e1e-8b8b8b-ffaff3-fdffab

To change the color of a certain syntax, change its pattern type.

Example:
  { pattern = "pub", type = "normal" },
will change the color of the pub

You can see the color changes after:
1. ctrl+shift+p
     Core: Reload Module
       plugins.language_gleam
2. save current gleam file

If you want to understand how the Lua Patterns work, visit:
    https://gitspartv.github.io/lua-patterns/
]]

local nested_multiline = { symbols = {} }
nested_multiline["patterns"] = {
  { pattern = { "/%*", "%*/" }, type = "comment", syntax = nested_multiline },
  { pattern = ".",              type = "comment" },
}

syntax.add {
  name = "Bolt",
  files = { "%.bolt$" },
  comment = "//",
  block_comment = {"/*", "*/"},
  patterns = {
    { pattern = "%f[%a]%u%w*", type = "literal" }, -- Everything which starts from capital letter

    { pattern = "//.-\n",         type = "comment" },
    { pattern = { "/%*", "%*/" }, type = "comment", syntax = nested_multiline },

    { pattern = { '"', '"', '\\' }, type = "string" }, -- "hello there"

    { pattern = "0[xX][%x]+",   type = "number" }, -- 0xFF
    { pattern = "%d+[%d%.eE-]*", type = "number" }, -- 12000 21000.12 1.0e9 1.0e-6

    { pattern = "[%(%)]", type = "symbol" }, -- ( )
    { pattern = "[%[%]]", type = "symbol" }, -- [ ]
    { pattern = "[%{%}]", type = "symbol" }, -- { }

-- comment out/uncomment related patterns if you want your code to be less/more colorful
    { pattern = "%=>",        type = "operator"}, -- =>
    { pattern = "|",          type = "operator" }, -- |
    { pattern = "==",         type = "operator" }, -- ==
    { pattern = "!=",         type = "operator" }, -- !=
    -- { pattern = "%.%.",       type = "operator" }, -- ..
    { pattern = "<%=?",       type = "operator"}, -- < <=
    { pattern = ">%=?",       type = "operator"}, -- > >=
    { pattern = "[%+%-/*]=?", type = "operator" }, -- + - / * += -= /= *=
    { pattern = "=",          type = "operator" }, -- =
    { pattern = "%?%.?",      type = "operator"}, -- ? ?.
    { pattern = "%!",         type = "operator"}, -- !

    --{ pattern = "[%a_][%w_]*:",     type = "comment" }, --  "param:"
    --{ pattern = "[%a_][%w_]*%f[:]", type = "symbol" }, -- "param":
    --{ pattern = ":",                type = "operator"}, -- :

    { pattern = "[%a_][%w_]* *%f[(]", type = "function" }, -- functions
    { pattern = "[%a_][%w_]*",      type = "symbol" },   -- variables & constants
  },
  symbols = {
    ["import"]   = "keyword",
    ["from"]     = "keyword",
    ["export"]   = "keyword",
    ["return"]   = "keyword",
    ["fn"]       = "keyword",
    ["match"]    = "keyword",
    ["let"]      = "keyword",
    ["is"]       = "keyword",
    ["as"]       = "keyword",
    ["unsealed"] = "keyword",
    ["const"]    = "keyword",
    ["final"]    = "keyword",

    ["for"] = "keyword",
    ["in"]  = "keyword",
    ["to"]  = "keyword",
    ["by"]  = "keyword",
    ["do"]  = "keyword",

    ["continue"] = "keyword",
    ["break"]    = "keyword",

    ["and"] = "keyword",
    ["or"]  = "keyword",
    ["not"] = "keyword",

    ["type"]   = "keyword",
    ["typeof"] = "keyword",

    ["if"]   = "keyword",
    ["else"] = "keyword",
    ["then"] = "keyword",


    ["true"]  = "keyword2",
    ["false"] = "keyword2",
    ["null"]  = "keyword2",

    ["null"]   = "keyword2",
    ["number"] = "keyword2",
    ["string"] = "keyword2",
    ["bool"]   = "keyword2",
    ["any"]    = "keyword2",

    ["enum"] = "keyword2",
  },
}
