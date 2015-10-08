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
Plugin 'taglist.vim'
Plugin 'Chiel92/vim-autoformat'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

call vundle#end()
" ###

syntax enable
colorscheme atom-dark-256

syntax on
filetype plugin indent on

set autoindent
set tabstop=4
set textwidth=119
set encoding=utf8

set ignorecase
set smartcase
set autoindent

set colorcolumn=120

set incsearch

set showmode
set showcmd

set mouse=a

set whichwrap+=<,>


