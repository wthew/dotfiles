

local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.window_background_opacity = 0.75
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.color_scheme = 'Dracula'
config.font = wezterm.font('Monocraft Nerd Font')
config.font_size = 10
config.kde_window_background_blur = true

config.colors = {
	tab_bar = {
		background = 'transparent'
	}
}

return config
