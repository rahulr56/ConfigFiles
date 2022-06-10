" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme) 
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'
    "...All your other bundles...
    if iCanHazVundle == 0
        echo "Installing Vundles, please ignore key map error messages"
        echo ""
        :PluginInstall
    endif

    "Add your bundles here
    Plugin 'altercation/vim-colors-solarized' "T-H-E colorscheme
    " The following are examples of different formats supported.
    " Keep Plugin commands between vundle#begin/end.
    " plugin on GitHub repo
    Plugin 'tpope/vim-fugitive'
    " plugin from http://vim-scripts.org/vim/scripts.html
    " Plugin 'L9'
    " Git plugin not hosted on GitHub
    " Plugin 'git://git.wincent.com/command-t.git'
    Plugin 'wincent/command-t'
    " Plugin 'davidhalter/jedi-vim'
    " git repos on your local machine (i.e. when working on your own plugin)
    " Plugin 'file:///home/gmarik/path/to/plugin'
    " The sparkup vim script is in a subdirectory of this repo called vim.
    " Pass the path to set the runtimepath properly.
    " Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
    " Install L9 and avoid a Naming conflict if you've already installed a
    " different version somewhere else.
    " Plugin 'ascenator/L9', {'name': 'newL9'}
    Plugin 'lilydjwg/colorizer'
    Plugin 'ctrlpvim/ctrlp.vim'
    " Plugin 'multiple-search'
    " Plugin 'scrooloose/nerdcommenter'
    " Plugin 'scrooloose/nerdtree'
    Plugin 'vim-syntastic/syntastic'
    " Plugin 'Shougo/neocomplete.vim'
    " Plugin 'tabman.vim'
    " Plugin 'tabular'
    Plugin 'tagbar'
    " Plugin 'xolox/vim-easytags'
    Plugin 'xolox/vim-misc'
    " Plugin 'jceb/vim-orgmode'
    Plugin 'terryma/vim-multiple-cursors'

    " Plugin 'undotree'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    " Plugin 'vim-autoclose'
    Plugin 'Townk/vim-autoclose'
    Plugin 't9md/vim-choosewin'
    Plugin 'jeffkreeftmeijer/vim-numbertoggle'
    " Plugin 'vwxyutarooo/nerdtree-devicons-syntax'
    " Plugin 'vim-cpp-enhanced-highlight'
    " Plugin 'vim-ctrlp-cmdpalette'
    Plugin 'fisadev/vim-ctrlp-cmdpalette'
    " Plugin 'ryanoasis/vim-devicons'
    " Plugin 'vim-easymotion'
    Plugin 'nathanaelkane/vim-indent-guides'
    " Plugin 'vim-mark-master'
    " Plugin 'vim-multiple-cursors'
    " Plugin 'vim-nerdtree-syntax-highlight'
    Plugin 'ngemily/vim-vp4'
    " Plugin 'vim-webdevicons'
    " Plugin 'mhinz/vim-startify'
    " Plugin 'nvie/vim-flake8'
    " Plugin 'dense-analysis/ale'

    " All of your Plugins must be added before the following line
    Plugin 'junegunn/fzf.vim'
    Plugin 'junegunn/fzf'
    Plugin 'wellle/targets.vim'  " https://github.com/wellle/targets.vim
    ", { 'do': { -> fzf#install() } }
call vundle#end() 
"must be last
filetype plugin indent on " load filetype plugins/indent settings
syntax on                      " enable syntax

" Setting up Vundle - the vim plugin bundler end
