set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/plugged
call plug#begin('~/.vim/plugged')
" alternatively, pass a path where Vundle should install plugins
    " call vundle#begin('~/.vim/bundle/')
    " let Vundle manage Vundle, required
    " Plug 'VundleVim/Vundle.vim'

    " The following are examples of different formats supported.
    " Keep Plug commands between vundle#begin/end.
    " plugin on GitHub repo
    Plug 'tpope/vim-fugitive'
    " plugin from http://vim-scripts.org/vim/scripts.html
    " Plug 'L9'
    " Git plugin not hosted on GitHub
    " Plug 'git://git.wincent.com/command-t.git'
    Plug 'wincent/command-t'
    " Plug 'davidhalter/jedi-vim'
    " git repos on your local machine (i.e. when working on your own plugin)
    " Plug 'file:///home/gmarik/path/to/plugin'
    " The sparkup vim script is in a subdirectory of this repo called vim.
    " Pass the path to set the runtimepath properly.
    " Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
    " Install L9 and avoid a Naming conflict if you've already installed a
    " different version somewhere else.
    " Plug 'ascenator/L9', {'name': 'newL9'}
    " Plug 'lilydjwg/colorizer'
    Plug 'ctrlpvim/ctrlp.vim'
    " Plug 'multiple-search'
    " Plug 'scrooloose/nerdcommenter'
    " Plug 'scrooloose/nerdtree'
    " Plug 'Shougo/neocomplete.vim'
    " Plug 'tabular'
    " Plug 'xolox/vim-easytags'
    " Plug 'xolox/vim-misc'
    " Plug 'jceb/vim-orgmode'
    " Plug 'terryma/vim-multiple-cursors'

    " Plug 'undotree'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Plug 'vim-autoclose'
    Plug 'Townk/vim-autoclose'
    Plug 't9md/vim-choosewin'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'
    " Plug 'vwxyutarooo/nerdtree-devicons-syntax'
    " Plug 'vim-cpp-enhanced-highlight'
    " Plug 'vim-ctrlp-cmdpalette'
    " Plug 'fisadev/vim-ctrlp-cmdpalette'
    Plug 'yegappan/mru'
    " Plug 'vim-scripts/Conque-Shell'
    " Plug 'ryanoasis/vim-devicons'
    " Plug 'vim-easymotion'
    " Plug 'nathanaelkane/vim-indent-guides'
    " Plug 'vim-mark-master'
    " Plug 'vim-multiple-cursors'
    " Plug 'vim-nerdtree-syntax-highlight'
    Plug 'ngemily/vim-vp4'
    " Plug 'vim-webdevicons'
    " Plug 'mhinz/vim-startify'
    " Plug 'nvie/vim-flake8'
    " ALE is successor for Syntastic
    " Plug 'vim-syntastic/syntastic'
    Plug 'dense-analysis/ale'

    " All of your Plugins must be added before the following line
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Plug 'wellle/targets.vim'  " https://github.com/wellle/targets.vim
    Plug 'frazrepo/vim-rainbow'

    Plug 'mileszs/ack.vim'
    Plug 'preservim/tagbar'

    " Language packs for Vim
    Plug 'sheerun/vim-polyglot'

    " convenient way to navigate between tabs and the windows they contain
    Plug 'kien/tabman.vim'

call plug#end()            " required

filetype plugin indent on    " required
