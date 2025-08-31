-- mod-version:3

local syntax = require "core.syntax"

-- Adapted from https://nim-lang.org/docs/manual.html#lexical-analysis-numeric-literals
local hex_digit = "[\\da-fA-F]"
local hex_part = hex_digit .. "(?:_?" .. hex_digit .. ")*"
local hex_regex = "\\-?0x" .. hex_part .. "(?:\\." .. hex_part .. ")?"

local digits = "\\d(?:_?\\d)*"
local exponent = "[eE][\\+\\-]?" .. digits
local decimal_part = "\\." .. digits .. "(?:" .. exponent .. ")?"
local decimal_regex = "\\-?(?:" .. digits .. ")(?:(?:" .. decimal_part .. ")|" .. exponent .. ")?"

local all_symbols = {
  ["if"]       = "keyword",
  ["unless"]   = "keyword",
  ["then"]     = "keyword",
  ["else"]     = "keyword",
  ["elseif"]   = "keyword",
  ["switch"]   = "keyword",
  ["when"]     = "keyword",
  ["goto"]     = "keyword",
  ["and"]      = "keyword",
  ["or"]       = "keyword",
  ["not"]      = "keyword",

  ["do"]       = "keyword",
  ["while"]    = "keyword",
  ["for"]      = "keyword",
  ["in"]       = "keyword",
  ["repeat"]   = "keyword",
  ["until"]    = "keyword",
  ["break"]    = "keyword",
  ["continue"] = "keyword",

  ["return"]   = "keyword",
  ["macro"]    = "keyword",
  ["with"]     = "keyword",
  ["using"]    = "keyword",
  ["try"]      = "keyword",
  ["catch"]    = "keyword",

  ["class"]    = "keyword",
  ["extends"]  = "keyword",

  ["global"]   = "keyword",
  ["local"]    = "keyword",
  ["const"]    = "keyword",

  ["import"]   = "keyword",
  ["export"]   = "keyword",
  ["default"]  = "keyword",
  ["as"]       = "keyword",
  ["from"]     = "keyword",

  -- super and self are technically variables, so it is better
  -- to distinguish them from reserved keywords.
  ["super"]    = "keyword2",
  ["self"]     = "keyword2",

  ["true"]     = "literal",
  ["false"]    = "literal",
  ["nil"]      = "literal",
}

local keywords = {}
for symbol, token in pairs(all_symbols) do
  if symbol ~= "not" and token == "keyword" then
    table.insert(keywords, symbol)
  end
end

-- Spaces at the end of the pattern are important;
-- otherwise you would get weird coloring for assert info for example.
-- assert would be not colored and the `in` inside info would be colored as a
-- keyword.
local function_pattern = "[a-zA-Z_][\\w_]*()\\s+(?:" .. table.concat(keywords, "|") .. ")\\s+"

syntax.add {
  name = "Yuescript String Interpolation",
  files = "%.yue__string_interp$",
  patterns = {
    { pattern = {"#{", "}", "\\"},                         type = "keyword", syntax = ".yue" },
    { pattern = "[^ ]",                                    type = "string"}
  },
  symbols = {}
}

syntax.add {
  name = "Yuescript",
  files = { "%.yue$" },
  comment = "--",
  block_comment = { "--[[", "]]" },
  patterns = {
    { pattern = { "%-%-%[%[", "%]%]" },                    type = "comment" },
    { pattern = "%-%-.*\n",                                type = "comment" },
    -- shebang
    { pattern = "#!.*\n",                                  type = "comment" },
    -- Identifiers starting with an uppercase letter
    -- (class names, enums, etc.)
    { pattern = "%u[%w_]*",                                type = "keyword2" },

    -- close attribute
    -- The first pattern must take precedence over the second, so you can't put
    -- `close` to the symbols table.
    { pattern = "<()%s*close",                             type = { "operator", "normal" } },
    { pattern = "close",                                   type = "keyword" },

    -- A macro name should be easily distinguished from a function name,
    -- that's why we use a different color.
    { pattern = "macro%s+()[%a_][%w_]*",                   type = { "keyword", "keyword2" } },
    { pattern = "class%s+()[%a_][%w_]*",                   type = { "keyword", "keyword2" } },

    -- function call
    -- Capture `()` is important here, otherwise imports would be highlighted as functions
    { pattern = "[%a_][%w_]*()%s*%f[%(@\"'{#]",            type = { "function", "normal" } },
    { regex   = function_pattern,                          type = { "normal", "keyword" } },
    { pattern = "[%a_][%w_]*()%s+not%s+in",                type = { "normal", "keyword" } },
    { pattern = "[%a_][%w_]*()%s+%f[%[%$%a_]",             type = { "function", "normal" } },
    { pattern = "|>%s*()[%a_][%.%w_]*%.%s*()[%a_][%w_]*",  type = { "operator", "normal", "function" } },
    { pattern = "|>%s*()[%a_][%w_]*",                      type = { "operator", "function" } },

    -- function call with number literal
    { regex = "[a-zA-Z_]\\w*\\s+()" .. hex_regex,          type = { "function", "number" } },
    { regex = "[a-zA-Z_]\\w*\\s+()\\-?" .. decimal_part,   type = { "function", "number" } },
    { regex = "[a-zA-Z_]\\w*\\s+()" .. decimal_regex,      type = { "function", "number" } },

    -- function call with exclamation mark (question mark is used for existence-check)
    { pattern = "[%a_][%w_]*()%??%s*!=",                   type = { "normal", "operator" } },
    { pattern = "[%a_][%w_]*()%??%s*!",                    type = { "function", "operator" } },

    -- goto labels
    { pattern = "::()[%a_][%w_]*()::",                     type = { "operator", "keyword2", "operator" } },

    -- methods
    { pattern = "::()[%a_][%w_]*",                         type = { "operator", "function" } },
    { pattern = "\\()[%a_][%w_]*",                         type = { "operator", "function" } },

    -- number literal
    { regex = hex_regex,                                   type = "number" },
    { regex = "\\-?" .. decimal_part,                      type = "number" },
    { regex = decimal_regex,                               type = "number" },

    -- attributes
    { pattern = "@@?[%w_]*",                               type = "keyword2" },
    -- macro call
    { pattern = "$[%w_]+",                                 type = "keyword2" },

    { pattern = "[%a_][%w_]*",                             type = "symbol" },
    { pattern = { '"', '"', '\\' },                        type = "string", syntax = ".yue__string_interp" },
    { pattern = { "'", "'", '\\' },                        type = "string" },

    -- raw string
    { pattern = { "%[=*%[", "%]=*%]" },                    type = "string" },
    -- operators
    -- I removed braces since it caused conflicts with string formatting
    { pattern = "[&<>%+-%*/=#%[%]!|?:~%%%.%^]+",           type = "operator" },
    { pattern = "\\",                                      type = "operator" },
  },
  symbols = all_symbols,
}
