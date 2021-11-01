-- load base settings
require('settings')

-- load custom keymappings
require('mappings')

local execute = vim.api.nvim_command
local fn = vim.fn

-- install packer if it's not already
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

local use = require('packer').use
require('packer').startup(function()
    -- use 'kyazdani42/nvim-tree.lua'
    -- use 'hoob3rt/lualine.nvim'
    use 'PotatoesMaster/i3-vim-syntax' -- i3 highlighting
    use 'cespare/vim-toml' -- TOML highlighting
    use 'dag/vim-fish' -- Fish syntax highlighting
    use 'fladson/vim-kitty' -- Kitty syntax highlighting
    use 'folke/lua-dev.nvim' -- Lua dev setup
    use 'folke/tokyonight.nvim' -- colorscheme
    -- use 'glepnir/lspsaga.nvim'
    use 'glepnir/zephyr-nvim' -- colorscheme
    use 'hrsh7th/nvim-compe' -- Autocompletion plugin
    use 'hrsh7th/vim-vsnip' -- Autocompletion plugin
    use 'itchyny/lightline.vim' -- Nice status line
    use 'joshdick/onedark.vim' -- Theme inspired by Atom
    use 'kosayoda/nvim-lightbulb' -- Show LSP code actions in signcolumn
    use 'kyazdani42/nvim-web-devicons'
    use 'neovim/nvim-lspconfig' -- LSP setup
    use 'nvim-lua/lsp_extensions.nvim' -- Just using for rust inlay type inlay_hints
    use 'rafamadriz/friendly-snippets' -- Snippet library that integrates into vsnip
    use 'rust-lang/rust.vim'
    use 'tbastos/vim-lua' -- lua highlighting
    use 'wbthomason/packer.nvim' -- Package manager

    use {'akinsho/nvim-bufferline.lua',
         requires = 'kyazdani42/nvim-web-devicons'
    }

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/popup.nvim' },
            { 'nvim-lua/plenary.nvim' }
        }
    }

    use {
        'folke/todo-comments.nvim', -- highlight PERF, HACK, TODO, NOTE, FIX, WARNING
        requires = 'nvim-lua/plenary.nvim',
        config = function()
            require('todo-comments').setup{}
        end
    }
end)

require('plugin_configs.treesitter')
require('plugin_configs.compe')

-- require('lspsaga').init_lsp_saga()
-- lualine setup
-- local status, lualine = pcall(require, "lualine")
-- if (not status) then return end
-- lualine.setup {
--   options = {
--     icons_enabled = true,
--     theme = 'solarized_dark',
--     section_separators = {'', ''},
--     component_separators = {'', ''},
--     disabled_filetypes = {}
--   },
--   sections = {
--     lualine_a = {'mode'},
--     lualine_b = {'branch'},
--     lualine_c = {'filename'},
--     lualine_x = {
--       { 'diagnostics', sources = {"nvim_lsp"}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '} },
--       'encoding',
--       'filetype'
--     },
--     lualine_y = {'progress'},
--     lualine_z = {'location'}
--   },
--   inactive_sections = {
--     lualine_a = {},
--     lualine_b = {},
--     lualine_c = {'filename'},
--     lualine_x = {'location'},
--     lualine_y = {},
--     lualine_z = {}
--   },
--   tabline = {},
--   extensions = {'fugitive'}
-- }

-- vim.cmd[[colorscheme tokyonight]]

-- update nvim lightbulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Set statusbar
vim.g.lightline = {
colorscheme = 'tokyonight',
active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified'} } }
}

vim.o.termguicolors = true
require('bufferline').setup{
    options = {
        numbers = 'buffer_id',
        -- number_style = '',
    }
}

-- LSP stuff
-- require('lsp');
-- require('lualsp');
-- require('pylsp');
-- Define signs for signcolumn
vim.fn.sign_define("LspDiagnosticsSignError",
    {text = "", texthl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
    {text = "", texthl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
    {text = "", texthl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
    {text = "", texthl = "LspDiagnosticsSignHint"})

-- Lua LSP
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local luadev = require('lua-dev').setup({
    lspconfig = {
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }})
local lspconfig = require('lspconfig')
lspconfig.sumneko_lua.setup(luadev)

-- Python LSP
local lspconfig = require('lspconfig')
lspconfig.pylsp.setup{}

-- Rust LSP
-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'nvim-compe'.on_attach(client)
    -- require'lspsaga'.on_attach(client)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>Lspsaga rename<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>Lspsaga code_action<CR>', opts)
  buf_set_keymap('v', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Enable rust_analyzer
lspconfig.rust_analyzer.setup({ on_attach = on_attach })
-- require('lsp_extensions')
vim.cmd[[autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require('lsp_extensions').inlay_hints{ prefix = '>> ', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }]]

-- use tab and shift tab for completion menu
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
vim.o.updatetime=300
-- " Show diagnostic popup on cursor hold
-- TODO: this is interesting, but maybe make it only trigger with a keymapping?
-- vim.cmd[[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]]
