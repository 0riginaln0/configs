local style = require "core.style"
local common = require "core.common"

local doc_background   = "#f5f5f5" -- code background
local doc_gray_lighter = "#e0e0e0" -- editor background, line with cursor on it
local doc_gray_light   = "#d0d0d0" -- selection, line_guide
local doc_gray         = "#b0b0b0" -- scrollbar
local doc_gray_dark    = "#999999" -- line number, line_guide_highlight, scrollbar hovered
local doc_gray_darker  = "#555555" -- line number with cursor on line
local purple_light     = "#ded9ff" -- search selection result

local just_black     = "#333333" -- normal, symbol
local comment_gray   = "#9E9E9E" -- comments
local keyword_purple = "#9C27B0" -- keywords
local keyword_red    = "#ad1403" -- other keywords
local literal_bronze = "#9e580d" -- numbers, literals
local string_gold    = "#b58900" -- strings
local just_blue      = "#0078D7" -- operators, functions

style.background       = { common.color(doc_background) }  -- Docview
style.background2      = { common.color(doc_gray_lighter) } -- Treeview
style.background3      = { common.color(doc_gray_lighter) } -- Command view
style.text             = { common.color(just_black) }
style.caret            = { common.color(just_blue) }
style.accent           = { common.color(just_blue) }
style.dim              = { common.color(doc_gray_dark) }
style.divider          = { common.color(doc_gray_light) } -- Line between nodes
style.selection        = { common.color(doc_gray_light) }
style.line_number      = { common.color(doc_gray_dark) }
style.line_number2     = { common.color(doc_gray_darker) } -- With cursor
style.line_highlight   = { common.color(doc_gray_lighter) }
style.scrollbar        = { common.color(doc_gray) }
style.scrollbar2       = { common.color(doc_gray_dark) } -- Hovered
style.scrollbar_track  = { common.color(doc_gray_lighter) }
style.nagbar           = { common.color "#FF0000" }
style.nagbar_text      = { common.color "#FFFFFF" }
style.nagbar_dim       = { common.color "rgba(255, 255, 255, 0.45)" }
style.drag_overlay     = { common.color "rgba(0, 0, 0, 0.1)" }
style.drag_overlay_tab = { common.color(just_blue) }
style.good             = { common.color "#4CAF50" }
style.warn             = { common.color "#FFC107" }
style.error            = { common.color "#F44336" }
style.modified         = { common.color "#2196F3" }

style.guide           = { common.color(doc_gray_light) }
style.guide_highlight = { common.color(doc_gray_dark) }

style.search_selection      = { common.color(purple_light) }
style.search_selection_text = { common.color "#000000"}

style.syntax["normal"] = { common.color(just_black) }   -- ( ) { }
style.syntax["symbol"] = { common.color(just_black) }
style.syntax["comment"] = { common.color(comment_gray) }  -- -- comment
style.syntax["keyword"] = { common.color(keyword_purple) }  -- local function end if case
style.syntax["keyword2"] = { common.color(keyword_red) } -- @ self int float GlobalName
style.syntax["number"] = { common.color(literal_bronze) }   -- 123 0x1654 0b0110101
style.syntax["literal"] = { common.color(literal_bronze) }  -- true false nil
style.syntax["string"] = { common.color(string_gold) }   -- "strings"
style.syntax["operator"] = { common.color(just_blue) } -- = + - / < > ! [ ] :
style.syntax["function"] = { common.color(just_blue) } -- calling functions

style.log["INFO"]  = { icon = "i", color = style.text }
style.log["WARN"]  = { icon = "!", color = style.warn }
style.log["ERROR"] = { icon = "!", color = style.error }

return style