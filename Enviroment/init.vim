function! Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

set encoding=UTF-8
set relativenumber
set number
syntax on 
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

call plug#begin()
if exists('g:vscode')
	" VSCode extension
else
	" ordinary neovim
	Plug 'shaunsingh/moonlight.nvim'
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'
"	Plug 'neovim/nvim-lspconfig'
"	Plug 'nvim-lua/completion-nvim'
endif


" use normal easymotion when in vim mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
call plug#end()

colorscheme moonlight

if exists('g:vscode')

else
        "lua require('callbacks')

	" Neo-vim LSP config
		"lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
		"autocmd BufEnter * lua require'completion'.on_attach()

		" Use <Tab> and <S-Tab> to navigate through popup menu
"		inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"		inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"
"		" Set completeopt to have a better completion experience
"		set completeopt=menuone,noinsert,noselect
"
"		" Avoid showing message extra message when using completion
"		set shortmess+=c

	" Tree
    nnoremap <C-q> :NvimTreeToggle<CR>
    "nnoremap <leader>r :NvimTreeRefresh<CR>
    "nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose and NvimTreeFocus are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly


    "
endif

let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:rainbow_active = 1
let g:EasyMotion_do_mapping = 0 " Disable default mappings

"map  s <Plug>(easymotion-bd-w)
nmap s <Plug>(easymotion-bd-f)

"c and d dont use buffer register
nnoremap d "_d
vnoremap d "_d
nnoremap c "_c
vnoremap c "_c

nnoremap Q <Nop>
inoremap <c-a> <Nop>

" When press next move to center screen
nnoremap n nzz
nnoremap N Nzz
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" move line up down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" begin and end on line
nnoremap B ^
nnoremap E $
