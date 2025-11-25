require('nvim-treesitter.configs').setup {
  ensure_installed = { "javascript", "lua", "python", "typescript" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require('nvim-autopairs').setup({
  enable_check_bracket_line = false
})

-- require("tailwind-tools").setup({
  -- your configuration
-- })

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.75 -- You can change this too


vim.api.nvim_set_keymap("n", "<C-e>", ":NvimTreeToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { silent = true, noremap = true })     -- move line up(n)
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { silent = true, noremap = true })     -- move line down(n)
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, noremap = true }) -- move line up(v)
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, noremap = true }) -- move line down(v)
vim.api.nvim_set_keymap("n", "<C-t>", ":ToggleTerm<cr>", { silent = true, noremap = true })

-- empty setup using defaults
require("nvim-tree").setup {
  on_attach = function(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    local function edit_or_open()
      local node = api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- expand or collapse folder
        api.node.open.edit()
      else
        -- open file
        api.node.open.edit()
        -- Close the tree if file was opened
        api.tree.close()
      end
    end

    -- open as vsplit on current node
    local function vsplit_preview()
      local node = api.tree.get_node_under_cursor()

      if node.nodes ~= nil then
        -- expand or collapse folder
        api.node.open.edit()
      else
        -- open file as vsplit
        api.node.open.vertical()
      end

      -- Finally refocus on tree if it was lost
      api.tree.focus()
    end
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings

    vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
    vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
    vim.keymap.set("n", "h", api.tree.close, opts("Close"))
    vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
  end,
  view = {
    float = {
      enable = true,
      open_win_config = function()
        local screen_w = vim.opt.columns:get()
        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
        local window_w = screen_w * WIDTH_RATIO
        local window_h = screen_h * HEIGHT_RATIO
        local window_w_int = math.floor(window_w)
        local window_h_int = math.floor(window_h)
        local center_x = (screen_w - window_w) / 2
        local center_y = ((vim.opt.lines:get() - window_h) / 2)
            - vim.opt.cmdheight:get()
        return {
          border = 'rounded',
          relative = 'editor',
          row = center_y,
          col = center_x,
          width = window_w_int,
          height = window_h_int,
        }
      end,
    },
    width = function()
      return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
    end,
  },
}


local format_augroup = vim.api.nvim_create_augroup("LSPFormatting", {})
local function on_attach(client, buffer)
  if not client.supports_method("textDocument/formatting") then
    return
  end

  vim.api.nvim_clear_autocmds({
    group = format_augroup,
    buffer = buffer,
  })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = format_augroup,
    buffer = buffer,
    callback = function()
      if vim.g.noformat ~= nil then
        return
      end
      vim.lsp.buf.format({
        async = false,
        timeout_ms = 5000,
        filter = function(c)
          -- using goimports instead
          if c.name == "gopls" then
            return false
          end
          return true
        end,
      })
    end,
  })
end


local has_any_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require 'lspconfig'.clangd.setup {}
require "lsp_signature".setup()
vim.o.completeopt = 'menuone,noselect'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local cmp = require 'cmp'
local luasnip = require("luasnip")

local lspkind = require('lspkind')
local source_mapping = {
  buffer = " Buffer",
  nvim_lsp = " LSP",
  nvim_lua = "󰢱 Lua",
  path = " Path",
  luasnip = "󰅍 LuaSnip"
}

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      local menu = source_mapping[entry.source.name]
      if entry.source.name == 'cmp_tabnine' then
        if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
          menu = entry.completion_item.data.detail .. ' ' .. menu
        end
        vim_item.kind = ''
      end
      vim_item.menu = menu
      return vim_item
    end
  },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {

    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),

    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
})


require("tmux").setup({
  copy_sync = {
    -- enables copy sync. by default, all registers are synchronized.
    -- to control which registers are synced, see the `sync_*` options.
    enable = true,

    -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
    -- first buffer or named_buffer_name = true to ignore a named tmux
    -- buffer with name named_buffer_name :)
    ignore_buffers = { empty = false },

    -- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
    -- clipboard by tmux
    redirect_to_clipboard = true,

    -- offset controls where register sync starts
    -- e.g. offset 2 lets registers 0 and 1 untouched
    register_offset = 0,

    -- overwrites vim.g.clipboard to redirect * and + to the system
    -- clipboard using tmux. If you sync your system clipboard without tmux,
    -- disable this option!
    sync_clipboard = true,

    -- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
    sync_registers = true,

    -- syncs deletes with tmux clipboard as well, it is adviced to
    -- do so. Nvim does not allow syncing registers 0 and 1 without
    -- overwriting the unnamed register. Thus, ddp would not be possible.
    sync_deletes = true,

    -- syncs the unnamed register with the first buffer entry from tmux.
    sync_unnamed = true,
  },
  navigation = {
    -- cycles to opposite pane while navigating into the border
    cycle_navigation = true,

    -- enables default keybindings (C-hjkl) for normal mode
    enable_default_keybindings = false,

    -- prevents unzoom tmux when navigating beyond vim border
    persist_zoom = false,
  },
  resize = {
    -- enables default keybindings (A-hjkl) for normal mode
    enable_default_keybindings = false,

    -- sets resize steps for x axis
    resize_step_x = 1,

    -- sets resize steps for y axis
    resize_step_y = 1,
  }
})


require("toggleterm").setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  }
})
