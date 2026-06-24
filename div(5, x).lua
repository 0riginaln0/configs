local style = require "core.style"
local common = require "core.common"

local NIGHT_MODE_INTENSITY = 0 -- [0, 1, ... 100]

local function clamp(min, max, value)
  return math.max(min, math.min(max, value))
end

local function hex_to_rgb(hex_str)
  local hex_str = hex_str:gsub("#", "")
  return tonumber("0x"..hex_str:sub(1,2)),
         tonumber("0x"..hex_str:sub(3,4)),
         tonumber("0x"..hex_str:sub(5,6))
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

-- taken from https://tannerhelland.com/2012/09/18/convert-temperature-rgb-algorithm-code.html
local function kelvin_to_rgb(kelvin)
  local temp = clamp(1000, 40000, kelvin) / 100
  
  local r, g, b
  
  if temp <= 66 then
    r = 1.0
  else
    r = temp - 60
    r = 329.698727446 * (r ^ -0.1332047592)
  end
  
  if temp <= 66 then
    g = temp
    g = 99.4708025861 * math.log(g) - 161.1195636625
  else
    g = temp - 60
    g = 288.1221695283 * (g ^ -0.0755148492)
  end

  if temp >= 66 then
    b = 1.0
  elseif temp <= 19 then
    b = 0.0
  else
    b = temp - 10
    b = 138.5177312231 * math.log(b) - 305.0447927307
  end
  
  return clamp(0, 255, r),
         clamp(0, 255, g),
         clamp(0, 255, b)
end

local function apply_night_mode(hex_color, intensity_percent)
  local intensity = clamp(0, 100, intensity_percent) / 100
  local target_kelvin = 6500 - (intensity * (6500 - 1200))

  local night_r, night_g, night_b = kelvin_to_rgb(target_kelvin)
  local r, g, b = hex_to_rgb(hex_color)
  local base_r, base_g, base_b = kelvin_to_rgb(6500)
  
  local r_new = clamp(0, 255, math.floor(r * (night_r / base_r)))
  local g_new = clamp(0, 255, math.floor(g * (night_g / base_g)))
  local b_new = clamp(0, 255, math.floor(b * (night_b / base_b)))

  return rgb_to_hex(r_new, g_new, b_new)
end

local function get_colors(intensity)
  intensity = intensity or 0

  return {
    doc_background   = apply_night_mode("#f5f5f5", intensity), -- code background
    doc_gray_lighter = apply_night_mode("#e0e0e0", intensity), -- editor background, line with cursor on it
    doc_gray_light   = apply_night_mode("#d0d0d0", intensity), -- selection, line_guide
    doc_gray         = apply_night_mode("#b0b0b0", intensity), -- scrollbar
    doc_gray_dark    = apply_night_mode("#999999", intensity), -- line number, line_guide_highlight, scrollbar hovered
    doc_gray_darker  = apply_night_mode("#555555", intensity), -- line number with cursor on line
    purple_light     = apply_night_mode("#ded9ff", intensity), -- search selection result

    just_black     = apply_night_mode("#333333", intensity), -- normal, symbol
    comment_gray   = apply_night_mode("#9E9E9E", intensity), -- comments
    keyword_purple = apply_night_mode("#9C27B0", intensity), -- keywords
    keyword_red    = apply_night_mode("#ad1403", intensity), -- other keywords
    literal_bronze = apply_night_mode("#9e580d", intensity), -- numbers, literals
    string_gold    = apply_night_mode("#b58900", intensity), -- strings
    just_blue      = apply_night_mode("#0078D7", intensity), -- operators, functions
  }
end

local c = get_colors(NIGHT_MODE_INTENSITY)

style.background       = { common.color(c.doc_background) }  -- Docview
style.background2      = { common.color(c.doc_gray_lighter) } -- Treeview
style.background3      = { common.color(c.doc_gray_lighter) } -- Command view
style.text             = { common.color(c.just_black) }
style.caret            = { common.color(c.just_blue) }
style.accent           = { common.color(c.just_blue) }
style.dim              = { common.color(c.doc_gray_dark) }
style.divider          = { common.color(c.doc_gray_light) } -- Line between nodes
style.selection        = { common.color(c.doc_gray_light) }
style.line_number      = { common.color(c.doc_gray_dark) }
style.line_number2     = { common.color(c.doc_gray_darker) } -- With cursor
style.line_highlight   = { common.color(c.doc_gray_lighter) }
style.scrollbar        = { common.color(c.doc_gray) }
style.scrollbar2       = { common.color(c.doc_gray_dark) } -- Hovered
style.scrollbar_track  = { common.color(c.doc_gray_lighter) }
style.nagbar           = { common.color "#FF0000" }
style.nagbar_text      = { common.color "#FFFFFF" }
style.nagbar_dim       = { common.color "rgba(255, 255, 255, 0.45)" }
style.drag_overlay     = { common.color "rgba(0, 0, 0, 0.1)" }
style.drag_overlay_tab = { common.color(c.just_blue) }
style.good             = { common.color "#4CAF50" }
style.warn             = { common.color "#FFC107" }
style.error            = { common.color "#F44336" }
style.modified         = { common.color "#2196F3" }

style.guide           = { common.color(c.doc_gray_light) }
style.guide_highlight = { common.color(c.doc_gray_dark) }

style.search_selection      = { common.color(c.purple_light) }
style.search_selection_text = { common.color "#000000"}

style.syntax["normal"] = { common.color(c.just_black) }   -- ( ) { }
style.syntax["symbol"] = { common.color(c.just_black) }
style.syntax["comment"] = { common.color(c.comment_gray) }  -- -- comment
style.syntax["keyword"] = { common.color(c.keyword_purple) }  -- local function end if case
style.syntax["keyword2"] = { common.color(c.keyword_red) } -- @ self int float GlobalName
style.syntax["number"] = { common.color(c.literal_bronze) }   -- 123 0x1654 0b0110101
style.syntax["literal"] = { common.color(c.literal_bronze) }  -- true false nil
style.syntax["string"] = { common.color(c.string_gold) }   -- "strings"
style.syntax["operator"] = { common.color(c.just_blue) } -- = + - / < > ! [ ] :
style.syntax["function"] = { common.color(c.just_blue) } -- calling functions

style.log["INFO"]  = { icon = "i", color = style.text }
style.log["WARN"]  = { icon = "!", color = style.warn }
style.log["ERROR"] = { icon = "!", color = style.error }

return style