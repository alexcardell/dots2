-- buffer management
vim.g.hidden = true
vim.opt.switchbuf = "usetab"
vim.opt.autoread = true

-- visual
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:2"

-- commands
vim.opt.showcmd = true
vim.opt.cmdheight = 1
-- vim.opt.showmode = false
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:full", "full" }

-- editing
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- nvim-cmp
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.spelllang = "en_gb,en"
vim.opt.inccommand = "nosplit"
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.scrolloff = 3
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.sidescrolloff = 3
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.textwidth = 80
vim.opt.virtualedit = "block"
vim.opt.splitbelow = true
vim.opt.splitright = true

local key = vim.api.nvim_set_keymap

-- basic mappings
key("i", "jk", "<Esc>", {})
-- toggle last buffer
key("n", "<leader><leader>", "<C-^>", {})
-- quickfix navigation
key("n", "gn", "<cmd>cnext<cr>", {})
key("n", "gp", "<cmd>cprevious<cr>", {})
key("n", "g1", "<cmd>cfirst<cr>", {})
key("n", "g0", "<cmd>clast<cr>", {})
key("n", "g<", "<cmd>colder<cr>", {})
key("n", "g>", "<cmd>cnewer<cr>", {})

require('alex/completion').setup()
require('alex/lsp').setup_lsp()
require('alex/dap').setup()
require('alex/linting').setup()
require('alex/statusline').setup()
require('alex/tree').setup()
require('alex/llm').setup()

-- metals autocmd
vim.cmd([[
  augroup lsp
    au!
    au FileType java,scala,sbt lua require("metals").initialize_or_attach(require('alex/lsp').metals)
  augroup end
]])

require('telescope').setup({
  defaults = {
    path_display = { "truncate" }
  }
})

key("n", "<localleader>d", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
key("n", "<localleader>t", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
key("n", "<localleader>h", "<cmd>lua vim.lsp.buf.hover()<cr>", {})
key("n", "<localleader>H", "<cmd>lua vim.diagnostic.open_float()<cr>", {})
key("n", "<localleader>i", "<cmd>lua vim.lsp.buf.implementation()<cr>", {})
key("n", "<localleader>R", "<cmd>lua vim.lsp.buf.rename()<cr>", {})
key("n", "<localleader>r", "<cmd>lua vim.lsp.buf.references()<cr>", {})
key("n", "<localleader>c", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
key("n", "<localleader>l", "<cmd>lua vim.lsp.codelens.run()<cr>", {})
key("n", "<localleader>f", "<cmd>lua vim.lsp.buf.format()<cr>", {})

key("n", "<localleader>mb", "<cmd>MetalsImportBuild<cr>", {})

-- Diaglist
key("n", "<localleader>x", "<cmd>lua require('diaglist').open_all_diagnostics()<cr>", {})
key("n", "<localleader>X", "<cmd>lua require('diaglist').open_buffer_diagnostics()<cr>", {})

-- Telescope
key("n", "<leader>fa", "<cmd>Telescope find_files hidden=true<cr>", {})
key("n", "<leader>f/", "<cmd>Telescope live_grep<cr>", {})
key("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {})
key("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {})
key("n", "<leader>fc", "<cmd>Telescope commands<cr>", {})
key("n", "<leader>fm", "<cmd>Telescope marks<cr>", {})
key("n", "<leader>fp", "<cmd>Telescope registers<cr>", {})
key("n", "<leader>fx", "<cmd>Telescope diagnostics<cr>", {})
key("n", "<leader>fs", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", {})
key("n", "<localleader>mc", [[  lua require("telescope").extensions.metals.commands() ]], {})

-- tmux integration
require('Navigator').setup({})
key('n', "<C-h>", '<CMD>NavigatorLeft<CR>', {})
key('n', "<C-l>", '<CMD>NavigatorRight<CR>', {})
key('n', "<C-k>", '<CMD>NavigatorUp<CR>', {})
key('n', "<C-j>", '<CMD>NavigatorDown<CR>', {})

-- Tree
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- colorscheme
require('base16-colorscheme').with_config({
  telescope = false,
  indentblankline = false,
  notify = false,
  ts_rainbow = false,
  illuminate = false,
  cmp = false,
  dapui = false,
})

vim.cmd([[ colorscheme base16-tomorrow-night ]])

local zk = require('zk')
local zk_cmds = require('zk.commands')

zk.setup({ picker = 'telescope' })

zk_cmds.add("ZkDaily", function(options)
  options = vim.tbl_extend("force", { dir = "journal/daily" }, options or {})
  zk.new(options)
end)

require('gitsigns').setup()
key("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", {})
key("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", {})
key("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", {})
key("v", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", {})
key("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", {})
key("n", "]c", '&diff ? "]c" : "<cmd>Gitsigns next_hunk<cr>"', { expr = true })
key("n", "[c", '&diff ? "[c" : "<cmd>Gitsigns prev_hunk<cr>"', { expr = true })
key("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", {})
key("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", {})

require('tint').setup({})

require('zen-mode').setup()

require('other-nvim').setup({
  mappings = {
    -- sbt src -> test
    {
      pattern = "/src/main/scala/(.*)/(.*).scala",
      target = "/src/test/scala/%1/%2Test.scala",
      context = "test"
    },
    -- sbt src -> it:test
    {
      pattern = "/src/main/scala/(.*)/(.*).scala",
      target = "/src/it/scala/%1/%2Test.scala",
      context = "it-test"
    },
    -- sbt test -> src
    {
      pattern = "/src/test/scala/(.*)/(.*)Test.scala",
      target = "/src/main/scala/%1/%2.scala",
      context = "main"
    },
    -- sbt it:test -> src
    {
      pattern = "/src/it/scala/(.*)/(.*)Test.scala",
      target = "/src/main/scala/%1/%2.scala",
      context = "main"
    },
    -- mill src -> test
    {
      pattern = "/src/(.*)/(.*).scala",
      target = "/test/src/%1/%2Test.scala",
      context = "test"
    },
    -- mill src -> it:test
    {
      pattern = "/src/(.*)/(.*).scala",
      target = "/it/src/%1/%2Test.scala",
      context = "test"
    },
    -- mill test -> src
    {
      pattern = "/test/src/(.*)/(.*)Test.scala",
      target = "/src/%1/%2.scala",
      context = "main"
    },
    -- mill it:test -> src
    {
      pattern = "/it/src/(.*)/(.*)Test.scala",
      target = "/src/%1/%2.scala",
      context = "main"
    },
  },
})
key("n", "<leader>of", "<cmd>Other<cr>", {})
key("n", "<leader>os", "<cmd>OtherSplit<cr>", {})
key("n", "<leader>ov", "<cmd>OtherVSplit<cr>", {})

require('marks').setup()

require('nvim-treesitter.configs').setup({
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = false,
  },
  incremental_selection = {
    enable = false,
  },
  indent = {
    enable = true
  }
})

require('outline').setup({
  symbols = {
    icon_source = 'lspkind'
  }
})
key("n", "<leader>ss", "<cmd>Outline<cr>", {})

-- vim.cmd([[ highlight CustomIndentLine ctermfg=Black guifg=#282a2e ]])
vim.cmd([[ highlight CustomIndentLine ctermfg=Black guifg=#373b41 ]])
require('ibl').setup({
  indent = {
    char = '│',
    -- char = '╎',
    highlight = { 'CustomIndentLine' }
  }
})

require('illuminate').configure({
  providers = { 'lsp' },
  delay = 400
})

-- require('oatmeal').setup({
--   backend = "ollama",
--   model = "codellama:latest"
-- })

vim.api.nvim_create_user_command(
  'DiffReview',
  'DiffviewOpen origin/HEAD...HEAD --imply-local',
  {}
)

-- require('copilot').setup({
--   panel = { enabled = false },
--   suggestion = {
--     enabled = true,
--     -- keymap = {
--     --   accept = "<C-'>",
--     --   accept_word = false,
--     --   accept_line = false,
--     --   next = "<C-]>",
--     --   prev = "<C-[>",
--     --   dismiss = "<C-#>",
--     -- },
--   }
-- })

require('hardtime').setup()
