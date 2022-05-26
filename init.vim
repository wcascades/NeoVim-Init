set number
set relativenumber
set noswapfile
set ignorecase " ignore case for searches by default
set mouse=a
set shell=pwsh
syntax on
" v-- this needs to be loaded BEFORE plugins
let g:ale_disable_lsp = 1
" ----------------------
" Auto vim-plug install
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"-----------------------
call plug#begin(stdpath('data') . '/plugged')
Plug 'dense-analysis/ale'
Plug 'dracula/vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do' : { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lambdalisue/fern.vim'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-orgmode/orgmode'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'omniSharp/omnisharp-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'wcascades/ssgn'
call plug#end()
let g:OmniSharp_server_use_net6 = 1
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_selector_findusages = 'fzf'
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

" ------------
" mappings
" ------------

let mapleader = " "
map <leader>b :Buffers<CR>
map <leader>O :Fern .<CR>
map <leader>s :w<CR>
vnoremap <C-c> "+y
noremap! <C-BS> <C-w>
imap <C-v> <C-r>+
nmap gd <Plug>(coc-definition)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>r <Plug>(coc-references)
nnoremap <C-p> :GFiles<CR>
map <leader>p <C-p>
map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>
map <leader>tn :SSGNEditGitNote <CR>
map <leader>tm :SSGNEditMainNote <CR>
map <C-j> :cn<CR>
map <C-k> :cp<CR>
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
map <leader>cd :cd %:p:h<CR>
" todo: convert to lua
nnoremap <expr> <leader>fw ':Telescope find_files<cr>' . "'" . expand('<cword>')
let g:SSGNMainNoteLocation = "~/todo.txtg"

" Allows for reuse of yanked text
xnoremap <leader>p "_dP
" Work around windows suspend issue
if has("win32") && has("nvim")
  nnoremap <C-z> <nop>
  inoremap <C-z> <nop>
  vnoremap <C-z> <nop>
  snoremap <C-z> <nop>
  xnoremap <C-z> <nop>
  cnoremap <C-z> <nop>
  onoremap <C-z> <nop>
endif

" ----------
"  end mappings
" ----------

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=4
set expandtab
colorscheme gruvbox
hi Normal ctermbg=NONE

lua << EOF
require 'nvim-treesitter.install'.compilers = { "clang" }
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
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
  extensions = {}
}
require('lualine').setup()
-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
    -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
    highlight = {
        enable = true,
        disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
        additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
    },
    ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup{
    org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
    org_default_notes_file = '~/Dropbox/org/refile.org',
}
EOF

" FZF Config
let g:fzf_tags_command = 'ctags -R'
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"
""Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
"""""""""""""
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

