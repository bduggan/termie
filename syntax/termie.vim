" Vim syntax file
" Language: termie
" Maintainer: Brian Duggan
" Latest Revision: 26 February 2019

" Place this in ~/.vim/syntax
" and in ~/.vim/ftdetect add a file with:
" autocmd BufRead,BufNewFile *.tm set filetype=tm

if exists("b:current_syntax")
  finish
endif

syntax match TermieComment /^\#.*$/
syntax match TermieIdentifier /\\=\w\+/
syntax match TermieStatement   /^\\[^=].*$/

hi def link TermieStatement Statement
hi def link TermieIdentifier Identifier
hi def link TermieComment Comment
