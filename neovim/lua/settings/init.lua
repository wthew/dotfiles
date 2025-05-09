vim.cmd([[ set encoding=utf8 ]])
vim.cmd([[ set nu! ]])
vim.cmd([[ set relativenumber ]])
vim.cmd([[ set mouse=a ]])
vim.cmd([[ set wildmenu ]])
vim.cmd([[ set confirm ]])
vim.cmd([[ set incsearch ]])
vim.cmd([[ set title ]])
vim.cmd([[ set t_Co=256 ]])
vim.cmd([[ set shiftwidth=2 ]])
vim.cmd([[ set softtabstop=2 ]])
vim.cmd([[ set expandtab ]])
vim.cmd([[ set guicursor= ]])
vim.cmd([[ set guifont=Monocraft\ Nerd\ Font:h10]])
vim.cmd([[ set cursorline ]])
vim.cmd([[ syntax on ]])
vim.cmd([[ set nowrap ]])
vim.cmd([[ set termguicolors ]])
vim.cmd([[ colorscheme dracula ]])
vim.cmd([[ highlight Normal guibg=none ]])
vim.cmd [[ autocmd BufWritePre * lua vim.lsp.buf.format() ]]
vim.cmd([[ set clipboard=unnamedplus ]])
vim.opt.laststatus = 2
vim.opt.showtabline = 2
vim.cmd([[ let g:neovide_transparency = 0.8 ]])

vim.api.nvim_set_hl(0, "NormalFloat", {

  fg = "none",

  bg = "none",

})

require 'settings.themes'
