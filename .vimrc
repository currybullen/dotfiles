" TODO
" * Change status line?
" * Use an easier shortcut for easymotion?
" * Try out FZF in popup with preview when FZF 0.21.0 drops

" Use some sane defaults
source $VIMRUNTIME/defaults.vim

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-unimpaired'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Looks
set cursorline
set relativenumber
set number
if $TERM !=# 'linux'
    colorscheme gruvbox
    set background=dark
endif

" Status line
set statusline=%(%{FugitiveStatusline()}\ %) " Git
set statusline+=%<%(%f\ %)%(%m\ %)\%r " Path/modified/RO
set statusline+=%=%(%y\ %)%(\[%{&fileencoding?&fileencoding:&encoding}\]\ %)\[%{&fileformat}\] " File info
set statusline+=\ %3p%%\ %4l:%4c " Lines %/line #/ column
set laststatus=2 " Always display the status line

" Tab behavior
set smarttab
set autoindent

" Search
set ignorecase
set smartcase
set hlsearch
set grepprg=rg\ --vimgrep\ --smart-case
set shortmess-=S

" Completion
set wildmode=list:longest,full
set wildignorecase
set path+=**

" Splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Navigation
nnoremap gb :Buffers<CR>:b<Space>
nnoremap gx :ls<CR>:bd<Space>

" Wrapping
set linebreak

" Misc
set autoread " Reload file when changed on disk
set hidden " Enable hiding edited buffers
set formatoptions+=j " Delete comment character when joining commented lines
set complete-=i " Do not look through included files when completing
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+ " Chars to display when running :list
setglobal tags-=./tags tags-=./tags; tags^=./tags; " Search upwards for tags file
set pastetoggle=<F2> " Toggles paste option
set display+=lastline " @@@ ends long lines
set viminfo='100,"50 " Keep trak of 100 files for :oldfiles

" Fix for editorconfig + fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

function! GitLogWithOptionalRange(range, startline, endline, gitargs)
	if a:range == "0"
		execute "Git log " . a:gitargs . " %"
	else
		execute "Git log " . a:gitargs . " -L" . a:startline . "," . a:endline . ":% "
	endif
endfunction
command! -range -nargs=* Glogg call GitLogWithOptionalRange(<range>, <line1>, <line2>, <q-args>)

source $HOME/.coc
