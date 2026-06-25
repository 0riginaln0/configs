-- mod-version:3
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local style = require "core.style"
local StatusView = require "core.statusview"

local themes = {
  { name = "div_light(5, x)", module = "colors.div_light(5, x)" },
  { name = "div_dark(5, x)", module = "colors.div_dark(5, x)" },
  -- Add next theme here
}

local PATH_CONFIG = USERDIR .. "/toggle_colorscheme_settings.lua"
local Settings = { color_scheme_idx = 1 }

local function clamp(n, lo, hi)
  if n < lo then return lo end
  if n > hi then return hi end
  return n
end

function Settings:save_settings()
  local fp = io.open(PATH_CONFIG, "w")
  if fp then
    fp:write(tostring(self.color_scheme_idx))
    fp:close()
  end
end

function Settings:load_settings()
  local fp = io.open(PATH_CONFIG, "r")
  if fp then
    local raw = fp:read("*a")
    fp:close()
    local idx = tonumber(raw)
    if idx then
      self.color_scheme_idx = clamp(idx, 1, #themes)
      core.reload_module(themes[self.color_scheme_idx].module)
    end
  else
    core.reload_module(themes[1].module)
  end
end

function Settings:apply_idx(idx)
  idx = clamp(idx, 1, #themes)
  self.color_scheme_idx = idx
  core.reload_module(themes[self.color_scheme_idx].module)
end

function Settings:toggle()
  local next_idx = self.color_scheme_idx + 1
  if next_idx > #themes then next_idx = 1 end
  self:apply_idx(next_idx)
end

local on_quit_project = core.on_quit_project
function core.on_quit_project()
  Settings:save_settings()
  on_quit_project()
end

command.add(nil, {
  ["theme:Toggle"] = function()
    Settings:toggle()
  end,
})

keymap.add {
  ["ctrl+shift+alt+p"] = "theme:Toggle",
}

core.status_view:add_item({
  name = "theme:toggle",
  alignment = StatusView.Item.RIGHT,
  command = "theme:Toggle",
  visible = true,
  get_item = function()
    return {
      style.font,
      "◐ " .. themes[Settings.color_scheme_idx].name
    }
  end,
  position = -1,
  tooltip = "Toggle theme",
  separator = core.status_view.separator2,
})

Settings:load_settings()
