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
Plug 'airblade/vim-gitgutter'
Plug 'vim-test/vim-test'
Plug 'Yggdroot/indentLine'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-eunuch'
Plug 'cespare/vim-toml'
Plug 'preservim/nerdtree'
call plug#end()

" Looks
set relativenumber
set number
let g:indentLine_color_term = 239 " This color is gruvbox specific
let g:indentLine_enabled = 0
let g:indentLine_fileTypeExclude = ['help']
let g:show_spaces_that_precede_tabs = 1
if $TERM !=# 'linux'
	colorscheme gruvbox
	set background=dark
endif

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

" Split behavior
set splitbelow
set splitright

" Navigation bindings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <space>f :Files<CR>
nnoremap <space>b :Buffers<CR>
map <space>s <Plug>(easymotion-prefix)

" Git bindings
nnoremap <space>gb :Git blame<CR>
nnoremap <space>gs :G<CR>
nnoremap <space>gf :GFiles?<CR>
nnoremap <space>gc :Commits<CR>
nnoremap <space>gu :BCommits<CR>

" Misc bindings
nnoremap <space>w :BD<CR>
nnoremap gx :ls<CR>:bd<Space>
nnoremap <space>u :w !sudo tee %
nnoremap <space>i :IndentLinesToggle<CR>
	\:set list!<CR>

" Wrapping
set linebreak

" Misc
set autoread " Reload file when changed on disk
set hidden " Enable hiding edited buffers
set formatoptions+=j " Delete comment character when joining commented lines
set complete-=i " Do not look through included files when completing
set listchars=tab:▶‒,trail:-,extends:>,precedes:<,nbsp:+,lead:- " Chars to display when running :list
setglobal tags-=./tags tags-=./tags; tags^=./tags; " Search upwards for tags file
set pastetoggle=<F2> " Toggles paste option
set display+=lastline " @@@ ends long lines
set viminfo='100,"50 " Keep trak of 100 files for :oldfiles

" Fix for editorconfig + fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

function! GitLogWithOptionalRange(range, startline, endline, gitargs)
	let log_cmd="Git log --oneline --no-patch"
	if a:range == "0"
		execute log_cmd . a:gitargs . " %"
	else
		execute log_cmd . a:gitargs . " -L" . a:startline . "," . a:endline . ":% "
	endif
endfunction
command! -range -nargs=* Glogg call GitLogWithOptionalRange(<range>, <line1>, <line2>, <q-args>)

" :BD, taken from https://github.com/junegunn/fzf.vim/pull/733#issuecomment-559720813
function! s:list_buffers()
	redir => list
	silent ls
	redir END
	return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
	execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
	\ 'source': s:list_buffers(),
	\ 'sink*': { lines -> s:delete_buffers(lines) },
	\ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

function! GitLogWithOptionalRange(range, startline, endline, gitargs)
        if a:range == "0"
                execute "Git log " . a:gitargs . " %"
        else
                execute "Git log " . a:gitargs . " -L" . a:startline . "," . a:endline . ":% "
        endif
endfunction
command! -range -nargs=* Glogg call GitLogWithOptionalRange(<range>, <line1>, <line2>, <q-args>)

augroup indentations_per_filetype
	autocmd!
	autocmd FileType nginx setlocal ts=4 sw=4 sts=4 expandtab
	autocmd FileType yaml setlocal ts=2 sw=2 sts=2 expandtab
	autocmd FileType toml setlocal ts=2 sw=2 sts=2 expandtab
augroup END
