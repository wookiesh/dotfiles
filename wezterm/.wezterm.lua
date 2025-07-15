local wezterm = require 'wezterm'

return {
  -- Appearance
  color_scheme = "Catppuccin Mocha", -- You can change to your preferred color scheme
  font = wezterm.font_with_fallback {
--    "JetBrainsMono Nerd Font",
    "FiraCode Nerd Font",
    "Monaco",
  },
  font_size = 12,
  line_height = 1.1,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  window_background_opacity = 0.9,
  text_background_opacity = 1.0,
  window_decorations = "RESIZE",
  adjust_window_size_when_changing_font_size = false,

  -- Padding
  window_padding = {
    left = 8,
    right = 8,
    top = 6,
    bottom = 6,
  },

  -- Performance
  animation_fps = 60,
  max_fps = 60,

  -- Keybindings (example: split panes and navigate)
  keys = {
    {key="Enter", mods="ALT", action=wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"}},
    {key="Enter", mods="ALT|SHIFT", action=wezterm.action.SplitVertical{domain="CurrentPaneDomain"}},
    {key="h", mods="CTRL|SHIFT", action=wezterm.action.ActivatePaneDirection("Left")},
    {key="l", mods="CTRL|SHIFT", action=wezterm.action.ActivatePaneDirection("Right")},
    {key="k", mods="CTRL|SHIFT", action=wezterm.action.ActivatePaneDirection("Up")},
    {key="j", mods="CTRL|SHIFT", action=wezterm.action.ActivatePaneDirection("Down")},

    {key="k", mods="CMD", action=wezterm.action.ClearScrollback('ScrollbackAndViewport')},
  },

  -- Scrollback
  scrollback_lines = 5000,
}
