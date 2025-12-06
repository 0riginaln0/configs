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

To change the color of a certain syntax, change its pattern type.

Example:
  { pattern = "%.",                    type = "normal" },
will change the color of the dot.

You can see the color changes after:
1. ctrl+shift+p
     Core: Reload Module
       plugins.language_roc
2. save current roc file

If you want to understand how the Lua Patterns work, visit:
    https://gitspartv.github.io/lua-patterns/
]]

syntax.add {
  name = "Roc",
  files = "%.roc$",
  comment = "#",
  patterns = {
    { pattern = "#.*",         type = "comment" }, -- # Comments
    { pattern = "%f[%a]%u%w*", type = "function" }, -- Roc Tags, Module Imports.
    {
      pattern = { '"""', '"""', '\\' },
      type = "string",
      syntax = {
        patterns = {
          { pattern = { "${", "}", "\\" }, type = "keyword", syntax = ".roc" }, -- Interpolation
          { pattern = '[^$"]+',            type = "string"},
          { pattern = '[$"]',              type = "string"},
        },
        symbols = {}
      }
    },
    {
      pattern = { '"', '"', '\\' },
      type = "string",
      syntax = {
        patterns = {
          { pattern = { "${", "}", "\\" }, type = "keyword", syntax = ".roc" }, -- Interpolation
          { pattern = '[^$"]+',            type = "string"},
          { pattern = '[$"]',              type = "string"},
        },
        symbols = {}
      }
    },

    { pattern = "[%l_][%a_%d]*",         type = "normal" }, -- constants, variables and so on
    { pattern = "%d[xb%_acdef%.%d]*%d*", type = "number" }, -- Numbers

    { pattern = "!", type = "keyword2" },
    { pattern = "?", type = "keyword2" },

    { pattern = ":",    type = "operator" },
    { pattern = "->",   type = "operator" },
    { pattern = "=>",   type = "operator" },
    { pattern = "|>",   type = "operator" },
    { pattern = ",",    type = "operator" },

    { pattern = "%.%.", type = "operator" }, -- ..
    { pattern = "%.",   type = "operator" }, -- .
    -- { pattern = "=",    type = "operator" },
    { pattern = "==",   type = "operator" },
    { pattern = "!=",   type = "operator" },
    -- { pattern = "||",   type = "operator" },
    { pattern = "&&",   type = "operator" },
    -- { pattern = "|",    type = "operator" },
    { pattern = "+",    type = "operator" },
    { pattern = "-",    type = "operator" },
    { pattern = "*",    type = "operator" },
    { pattern = "/",    type = "operator" },
    { pattern = ">",    type = "operator" },
    { pattern = "<",    type = "operator" },
    { pattern = "@",    type = "operator" },

    { pattern = "%(",   type = "normal" }, -- (
    { pattern = "%)",   type = "normal" }, -- )
    { pattern = "%[",   type = "normal" }, -- [
    { pattern = "%]",   type = "normal" }, -- ]
    { pattern = "%{",   type = "normal" }, -- {
    { pattern = "%}",   type = "normal" }, -- }
  },
  symbols = {
    ["if"]         = "keyword",
    ["then"]       = "keyword",
    ["else"]       = "keyword",
    ["when"]       = "keyword",
    ["as"]         = "keyword",
    ["is"]         = "keyword",
    ["dbg"]        = "keyword",
    ["import"]     = "keyword",
    ["expect"]     = "keyword",
    ["return"]     = "keyword",
    ["crash"]      = "keyword",
    ["and"]        = "keyword",
    ["or"]         = "keyword",
    ["exposing"]   = "keyword",
    ["implements"] = "keyword",
    ["where"]      = "keyword",
    ["platform"]   = "keyword",
    ["module"]     = "keyword",
    ["app"]        = "keyword",
  },
}
