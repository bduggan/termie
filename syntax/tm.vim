" Vim syntax file
" Language: tm tmeta
" Maintainer: Brian Duggan
" Latest Revision: 26 February 2019

" Place this in ~/.vim/syntax
" and in ~/.vim/ftdetect add a file with:
" autocmd BufRead,BufNewFile *.tm set filetype=tm

if exists("b:current_syntax")
  finish
endif

syntax match TMComment /^\#.*$/
syntax match TMIdentifier /\\=\w\+/
syntax match TMStatement   /^\\[^=].*$/

hi def link TMStatement Statement
hi def link TMIdentifier Identifier
hi def link TMComment Comment
