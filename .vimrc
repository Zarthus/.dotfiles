" ### Setup vundle & plugins
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'closetag.vim'
Plugin 'lfilho/cosco.vim'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/syntastic'
Plugin 'Chiel92/vim-autoformat'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'StanAngeloff/php.vim'
Plugin 'airblade/vim-gitgutter'
call vundle#end()
" ###

syntax enable
colorscheme atom-dark-256

syntax on
filetype plugin indent on

set autoindent
set tabstop=4
set shiftwidth=4
set textwidth=119
set encoding=utf8

set ignorecase
set smartcase
set autoindent
set expandtab

set colorcolumn=120

set incsearch

set lcs=tab:··,trail:░,nbsp:%
set list

set showmode
set showcmd

set mouse=r

set whichwrap+=<,>

set nu!