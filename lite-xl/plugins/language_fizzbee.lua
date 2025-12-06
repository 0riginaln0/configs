-- mod-version:3
local syntax = require "core.syntax"

local function table_merge(a, b)
    local t = {}
    for _, v in pairs(a) do table.insert(t, v) end
    for _, v in pairs(b) do table.insert(t, v) end

    return t
end


local fizzbee_symbols = {

  ["class"]    = "keyword",
  ["finally"]  = "keyword",
  ["is"]       = "keyword",
  ["return"]   = "keyword",
  ["continue"] = "keyword",
  ["for"]      = "keyword",
  ["lambda"]   = "keyword",
  ["try"]      = "keyword",
  ["except"]   = "keyword",
  ["def"]      = "keyword",
  ["async"]    = "keyword",
  ["await"]    = "keyword",
  ["from"]     = "keyword",
  ["nonlocal"] = "keyword",
  ["while"]    = "keyword",
  ["and"]      = "keyword",
  ["global"]   = "keyword",
  ["not"]      = "keyword",
  ["with"]     = "keyword",
  ["as"]       = "keyword",
  ["elif"]     = "keyword",
  ["if"]       = "keyword",
  ["or"]       = "keyword",
  ["else"]     = "keyword",
  ["match"]    = "keyword",
  ["case"]     = "keyword",
  ["import"]   = "keyword",
  ["pass"]     = "keyword",
  ["break"]    = "keyword",
  ["in"]       = "keyword",
  ["del"]      = "keyword",
  ["raise"]    = "keyword",
  ["yield"]    = "keyword",
  ["assert"]   = "keyword",

  ["self"]     = "keyword2",
  
  
  -- gossip specific
  ["role"]     = "keyword",
  ["action"]   = "keyword",
  ["func"]     = "keyword",
  
  ["any"]        = "keyword",
  ["always"]     = "keyword",
  ["eventually"] = "keyword",
  ["assertion"]  = "keyword",
  ["fair"] = "keyword",
  ["require"] = "keyword",

  ["None"]     = "literal",
  ["True"]     = "literal",
  ["False"]    = "literal",

}



local fizzbee_fstring = {

  patterns = {
    { pattern = "\\.",         type = "string" },
    { pattern = '[^"\\{}\']+', type = "string" }

  },

  symbols = {}
}



local fizzbee_patterns = {

  { pattern = '[uUrR]%f["]',                 type = "keyword"                         },

  { pattern = { '[ruU]?"""', '"""', '\\' },  type = "string"                          },
  { pattern = { "[ruU]?'''", "'''", '\\' },  type = "string"                          },
  { pattern = { '[ruU]?"',   '"',   '\\' },  type = "string"                          },
  { pattern = { "[ruU]?'",   "'",   '\\' },  type = "string"                          },
  { pattern = { 'f"',        '"',   "\\" },  type = "string", syntax = fizzbee_fstring },
  { pattern = { "f'",        "'",   "\\" },  type = "string", syntax = fizzbee_fstring },

  { pattern = "%d+[%d%.eE_]*",               type = "number"                          },
  { pattern = "0[xboXBO][%da-fA-F_]+",       type = "number"                          },
  { pattern = "%.?%d+",                      type = "number"                          },
  { pattern = "%f[-%w_]-%f[%d%.]",           type = "number"                          },

  { pattern = "[%+%-=/%*%^%%<>!~|&]",        type = "operator"                        },
  { pattern = "[%a_][%w_]*%f[(]",            type = "function"                        },

  { pattern = "[%a_][%w_]+",                 type = "symbol"                          },

}



local fizzbee_type = {

  patterns = {
    { pattern = "|",            type = "operator"  },
    { pattern = "[%w_]+",       type = "keyword2"  },
    { pattern = "[%a_][%w_]+",  type = "symbol"    },
  },

  symbols = {
    ["None"] = "literal"
  }
}
-- Add this line after in order for the recursion to work.
-- Makes sure that the square brackets are well balanced when capturing the syntax
-- (in order to make something like this work: Tuple[Tuple[int, str], float])
table.insert(fizzbee_type.patterns, 1, { pattern = { "%[", "%]" }, syntax = fizzbee_type })



-- For things like this_list = other_list[a:b:c]
local not_fizzbee_type = {

  patterns = fizzbee_patterns,

  symbols = fizzbee_symbols

}

table.insert(not_fizzbee_type.patterns, 1, { pattern = { "%[", "%]" }, syntax = not_fizzbee_type })
table.insert(not_fizzbee_type.patterns, 1, { pattern = { "{",  "}"  }, syntax = not_fizzbee_type })

table.insert(fizzbee_fstring.patterns,  1, { pattern = { "{",  "}"  }, syntax = not_fizzbee_type })



local fizzbee_func = {

  patterns = table_merge({

    { pattern = { "->",   "%f[:]"        }, type = "operator", syntax = fizzbee_type  },
    { pattern = { ":%s*", "%f[^%[%]%w_]" },                    syntax = fizzbee_type  },

  }, fizzbee_patterns),

  symbols = fizzbee_symbols
}

table.insert(fizzbee_func.patterns, 1, { pattern = { "%(", "%)" }, syntax = fizzbee_func })



syntax.add {
  name = "FizzBee",
  files = { "%.fizz$" },
  headers = "^#!.*[ /]fizzbee",
  comment = "#",
  block_comment = { '"""', '"""' },

  patterns = table_merge({

    { pattern = "#.*",                         type = "comment"                                         },
    { pattern = { '^%s*"""', '"""' },          type = "comment"                                         },

    { pattern = { "%[", "%]" },                                                syntax = not_fizzbee_type },
    { pattern = { "{",  "}"  },                                                syntax = not_fizzbee_type },

    --{ pattern = { "^%s*()def%f[%s]",    ":" }, type = { "normal", "keyword" }, syntax = fizzbee_func     }, -- this and the following prevent one-liner highlight bugs

    { pattern = { "^%s*()for%f[%s]",    ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()if%f[%s]",     ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()elif%f[%s]",   ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()while%f[%s]",  ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()match%f[%s]",  ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()case%f[%s]",   ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },
    { pattern = { "^%s*()except%f[%s]", ":" }, type = { "normal", "keyword" }, syntax = not_fizzbee_type },

    { pattern =  "else():",                    type = { "keyword", "normal" }                           },
    { pattern =  "try():",                     type = { "keyword", "normal" }                           },

    --{ pattern = "lambda()%s.+:",               type = { "keyword", "normal" }                           },
    --{ pattern = "class%s+()[%a_][%w_]+().*:",  type = { "keyword", "keyword2", "normal" }               },


    --{ pattern = { ":%s*", "%f[^%[%]%w_]"},                                     syntax = fizzbee_type     },

  }, fizzbee_patterns),

  symbols = fizzbee_symbols

}
