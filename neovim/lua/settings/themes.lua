require'nvim-web-devicons'.get_icons()

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local custom_dracula_lualine = require('lualine.themes.dracula')
custom_dracula_lualine.normal.c.bg = '#00000000'
custom_dracula_lualine.visual.c.bg = '#00000000'
custom_dracula_lualine.command.c.bg = '#00000000'

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = custom_dracula_lualine,
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {''},
    lualine_c = {'filename', 'filetype'},
    lualine_x = {'branch'},
    lualine_y = {''},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

