" Vim syntax file
" Language: boda
" Maintainer: Brian Duggan
" Latest Revision: 26 February 2019

" Place this in ~/.vim/syntax
" and in ~/.vim/ftdetect add a file with:
" autocmd BufRead,BufNewFile *.tm set filetype=tm

if exists("b:current_syntax")
  finish
endif

syntax match BodaComment /^\#.*$/
syntax match BodaIdentifier /\\=\w\+/
syntax match BodaStatement   /^\\[^=].*$/

hi def link BodaStatement Statement
hi def link BodaIdentifier Identifier
hi def link BodaComment Comment
