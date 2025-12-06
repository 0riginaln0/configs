return {
  ["config"] = {
    ["animation_rate"] = 1.0,
    ["borderless"] = true,
    ["custom_keybindings"] = {
      ["doc:toggle-block-comments"] = {
        [1] = "ctrl+shift+/",
        [2] = "ctrl+shift+keypad /"
      },
      ["doc:toggle-line-comments"] = {
        [1] = "ctrl+/",
        [2] = "ctrl+keypad /"
      },
      ["treeview:toggle"] = {
        [1] = "ctrl+\\",
        [2] = "ctrl+b"
      }
    },
    ["disabled_plugins"] = {},
    ["enabled_plugins"] = {
      ["autosaveonfocuslost"] = true
    },
    ["fps"] = 120,
    ["line_limit"] = 100,
    ["message_timeout"] = 3,
    ["plugins"] = {
      ["drawwhitespace"] = {
        ["enabled"] = true,
        ["show_leading"] = false,
        ["show_middle"] = false,
        ["show_trailing"] = true,
        ["show_trailing_error"] = false
      },
      ["indentguide"] = {
        ["highlight"] = false
      },
      ["lineguide"] = {
        ["enabled"] = true,
        ["rulers"] = {
          [1] = 100
        }
      },
      ["linewrapping"] = {
        ["enable_by_default"] = false,
        ["mode"] = "word",
        ["require_tokenization"] = false
      },
      ["minimap"] = {
        ["avoid_small_docs"] = true,
        ["caret_color"] = {
          [1] = 147,
          [2] = 221,
          [3] = 250,
          [4] = 255
        },
        ["instant_scroll"] = false,
        ["selection_color"] = {
          [1] = 82,
          [2] = 82,
          [3] = 87,
          [4] = 255
        },
        ["syntax_highlight"] = true
      },
      ["trimwhitespace"] = {
        ["enabled"] = false
      }
    },
    ["theme"] = "louis-pilfold",
    ["transitions"] = true
  }
}
