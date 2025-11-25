local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.window_background_opacity = 1
-- config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
-- config.color_scheme = 'Dracula'
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font('Monocraft Nerd Font')
config.font_size = 10
config.kde_window_background_blur = true
-- config.window_decorations = "TITLE"

config.colors = {
  tab_bar = {
    background = 'transparent'
  }
}

return config
