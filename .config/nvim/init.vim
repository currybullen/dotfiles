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
Plug 'Yggdroot/indentLine'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-eunuch'
Plug 'cespare/vim-toml'
Plug 'preservim/nerdtree'
Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-commentary'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dadbod'
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
nnoremap <Leader>tt :tabnew<CR>
nnoremap <Leader>td :tabclose<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
map <Leader>s <Plug>(easymotion-s)

" Git bindings
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gs :G<CR>
nnoremap <Leader>gf :GFiles?<CR>
nnoremap <Leader>gc :Commits<CR>
nnoremap <Leader>gu :BCommits<CR>
nnoremap <Leader>gd :Gvdiffsplit!<CR>
nnoremap <Leader>gl :tab :Git log --name-status 

" Allow opening a diff in a new tab from :G with dt
" https://github.com/tpope/vim-fugitive/issues/1451#issuecomment-770310789
au User FugitiveIndex nmap <buffer> dt :Gtabedit <Plug><cfile><Bar>Gdiffsplit<CR>

" Misc bindings
nnoremap <Leader>d :BD<CR>
nnoremap <Leader>i :IndentLinesToggle<CR>
	\ :set list!<CR>
noremap <Leader>y "+y
noremap <Leader>p "+p
nnoremap <Leader>h :nohlsearch<CR>

" Wrapping
set linebreak

" Misc
set autoread " Reload file when changed on disk
set hidden " Enable hiding edited buffers
set formatoptions+=j " Delete comment character when joining commented lines
set complete-=i " Do not look through included files when completing
set list
set listchars=tab:▶‒,trail:-,extends:>,precedes:<,nbsp:+,lead:- " Chars to display when running :list
setglobal tags-=./tags tags-=./tags; tags^=./tags; " Search upwards for tags file
set pastetoggle=<F2> " Toggles paste option
set display+=lastline " @@@ ends long lines
set viminfo='100,"50 " Keep trak of 100 files for :oldfiles
let g:vimwiki_list = [{'path': '$HOME/Sync/default/vimwiki', 'diary_caption_level': 2}]
let g:vimwiki_global_ext = 0
let g:airline_symbols_ascii = 1
let g:gitgutter_map_keys = 0

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
	autocmd FileType vimwiki setlocal ts=2 sw=2 sts=2 expandtab
	autocmd FileType tf setlocal ts=2 sw=2 sts=2 expandtab
augroup END
