"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h')."/.."

""""""""""""""""""""""""""""""
" => YankStack
""""""""""""""""""""""""""""""
nmap <c-p> <Plug>yankstack_substitute_older_paste
nmap <c-P> <Plug>yankstack_substitute_newer_paste

""""""""""""""""""""""""""""""
" => Ack
""""""""""""""""""""""""""""""
" simple recursive grep
nmap ,r :Ack
nmap ,wr :Ack <cword><CR>

""""""""""""""""""""""""""""""
" => TabMan
""""""""""""""""""""""""""""""
" mappings to toggle display, and to focus on it
" let g:tabman_toggle = 'tl'
" let g:tabman_focus  = 'tf'

""""""""""""""""""""""""""""""
" => AutoClose
""""""""""""""""""""""""""""""

" Fix to let ESC work as espected with Autoclose plugin
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
" don't change working directory
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
" file finder mapping
let g:ctrlp_map = ',p'
" tags (symbols) in current file finder mapping
nmap ,g :CtrlPBufTag<CR>
" tags (symbols) in all files finder mapping
nmap ,G :CtrlPBufTagAll<CR>
" general code finder in all files mapping
nmap ,p :CtrlPLine<CR>
" recent files finder mapping
nmap ,m :CtrlPMRUFiles<CR>
" commands finder mapping
nmap ,c :CtrlPCmdPalette<CR>
" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction
" same as previous mappings, but calling with current word as default text
nmap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nmap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nmap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nmap ,wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" ignore these files and folders on file finder
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
  \ 'file': '\.pyc$\|\.pyo$',
  \ }



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> ALE  -  Replacement for Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Linters enable checking of code errors
let g:ale_linters = {
                  \      'python' : ['ruff'],
                  \      'cpp' : ['cpplint'],
                  \}

" Fixers enforce Code Format like PEP-8 for python
let g:ale_fixers = {
                  \      'python' : ['black'],
                  \      'cpp' : ['cppcheck'],
                  \}

let g:ale_python_pylint_options = '--rcfile '.expand('~/.pylintrc')

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
highlight clear ALEErrorSign
highlight clear ALEWarningSign

let g:ale_echo_msg_error_str = '⚠'
let g:ale_echo_msg_warning_str = '✗'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> TagBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tagbar_ctags_bin = expand('~/.local/bin/universal_ctags')
nmap <F8> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1
let g:tagbar_show_visibility = 1
let g:tagbar_show_linenumbers = 1
hi TagbarHighlight ctermbg=3
hi TagbarHighlight ctermfg=1

let g:tagbar_autofocus = 1

hi TagbarKind     ctermfg=148
hi TagbarScope    ctermfg=197
hi TagbarFoldIcon ctermfg=186
hi TagbarNestedKind ctermfg=148
hi TagbarType     ctermfg=81
hi TagbarSignature ctermfg=186
hi TagbarPseudoID ctermfg=148
hi TagbarHighlight ctermfg=197
hi TagbarAccessPublic       ctermfg=186 guifg=Green
hi TagbarAccessProtected    ctermfg=141
hi TagbarAccessPrivate  ctermfg=197 guifg=Red
let g:tagbar_visibility_symbols = {
      \ 'public'    : '+ ',
      \ 'protected' : '# ',
      \ 'private'   : '- '
      \ }
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_scopestrs = {
    \    'class': "",
    \    'const': "",
    \    'constant': "",
    \    'enum': "",
    \    'field': "",
    \    'func': "",
    \    'function': "",
    \    'getter': "襁",
    \    'implementation': "",
    \    'interface': "",
    \    'map': "פּ",
    \    'member': "",
    \    'method': "",
    \    'setter': "",
    \    'variable': "",
    \ }


function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
    let colour = a:current ? '%#StatusLine#' : '%#StatusLineNC#'
    let flagstr = join(a:flags, '')
    if flagstr != ''
        let flagstr = '[' . flagstr . '] '
    endif
    return colour . '[' . a:sort . '] ' . flagstr . a:fname
endfunction
let g:tagbar_status_func = 'TagbarStatusFunc'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> Window Chooser
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mapping
nmap  -  <Plug>(choosewin)
" show big letters
let g:choosewin_overlay_enable = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> neocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable omni completion.
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_fuzzy_completion = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_fuzzy_completion_start_length = 1
let g:neocomplcache_auto_completion_start_length = 1
let g:neocomplcache_manual_completion_start_length = 1
let g:neocomplcache_min_keyword_length = 1
let g:neocomplcache_min_syntax_length = 1
" complete with words from any opened file
let g:neocomplcache_same_filetype_lists = {}
let g:neocomplcache_same_filetype_lists._ = '_'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> Jedi Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> AMD Specific Plugin Configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if strlen($P4_ROOT) > 0
    let p4_root = $P4_ROOT
    if isdirectory($P4_ROOT . "/HEAD")
      let p4_root = $P4_ROOT . "/HEAD"
    endif
    let dir = $P4_ROOT . '/src/shared/common/common/'
    let g:syntastic_cpp_include_dirs = globpath(dir, '*', 0, 1)
    let g:syntastic_cpp_include_dirs += [p4_root . '/src/shared/device/devmodel']
    let g:syntastic_cpp_include_dirs += [p4_root . '/src/shared/common']
    let g:syntastic_cpp_include_dirs += [p4_root . '/src/ext/Boost/boost_1_72_0']
    let g:syntastic_cpp_include_dirs += [p4_root . '/src/ext/gurobi/include']
    let g:syntastic_cpp_include_dirs += [p4_root . '/src/ext/']
    let g:syntastic_cpp_include_dirs += split($LD_LIBRARY_PATH, ':')
endif
let g:syntastic_cpp_remove_include_errors=1
let g:syntastic_cpp_no_include_search=1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> FZF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add namespace for fzf.vim exported commands
let g:fzf_command_prefix = 'Fzf'

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_layout = { 'down': '~40%' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Use preview when FzfFiles runs in fullscreen
command! -nargs=? -bang -complete=dir FzfFiles
            \call fzf#vim#files(<q-args>, <bang>F ? fzf#vim#with_preview('up:60%') : {}, <bang>F)
command FzfChanges call s:fzf_changes()

let g:fzf_history_dir = '~/.local/share/fzf-history'
" Find files with default preview window
nnoremap <silent> <leader>f :FzfFiles<CR>
" Find files with full preview window
nnoremap <silent> <leader>F :FzfFiles!<CR>
nnoremap <silent> <leader>b :FzfBuffers<CR>
nnoremap <silent> <leader>; :FzfCommands<CR>
nnoremap <silent> <leader>L :FzfLines<CR>
cnoremap <silent> <C-p> :FzfHistory<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Path completion with custom source command
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> Vim PERFORCE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vp4_prompt_on_write = 1
let g:vp4_perforce_executable = '/tools/batonroot/rodin/devkits/lnx24/perforce-2018.1/bin/p4'
let g:vp4_allow_open_depot_file=1
let g:vp4_filelog_max=15
let g:vp4_open_on_write=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"=> Vim Airline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_detect_paste=1
let g:airline_theme='wombat'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

""""""""""""""""""""""""""""""
" => MRU plugin
" Most recently used files
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>k :MRU<CR>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM-JIRA
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:jiracomplete_url = 'https://jira.xilinx.com/'
let g:jiracomplete_username = 'rrachapa'
let g:jiracomplete_password =   " optional "
