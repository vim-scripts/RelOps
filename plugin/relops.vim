" File: relops.vim
" Author: Mohammed Chelouti <mhc23 at web dot de>
" Description: Plugin that enables relative numbers for pending operation.
" Last Modified: Sep 12, 2012

if exists('g:loaded_relops') && v:version <= 703 | finish | endif
let g:loaded_relops = 1

if !exists('g:relops_check_for_nu')
    let g:relops_check_for_nu = 1
endif

" Mappings {{{1
let s:mappings = ['c',
                \ 'd',
                \ 'y',
                \ 'g~',
                \ 'gu',
                \ 'gU',
                \ '!',
                \ '=',
                \ 'gq',
                \ 'g?',
                \ '>',
                \ '<',
                \ 'zf',
                \ 'g@']

for s:m in s:mappings
    let s:user_map = mapcheck(s:m, 'n')
    if !empty(s:user_map) && s:m == maparg(s:user_map)
        let s:lhs = s:user_map
    else
        let s:lhs = s:m
    endif
    execute 'nnoremap <silent>' s:lhs ":call <SID>operate()<CR>".s:m
endfor

" Special cases {{{2
if &tildeop
    let s:user_map = mapcheck('~', 'n')
    if !empty(s:user_map) && '~' == maparg(s:user_map)
        let s:lhs = s:user_map
    else
        let s:lhs = '~'
    endif
    execute 'nnoremap <silent>' s:lhs ":call <SID>operate()<CR>~"
endif
onoremap <C-c> :call <SID>reset()<CR><C-c>
onoremap <Esc> :call <SID>reset()<CR><Esc>

" Clean up {{{2
unlet! s:m
unlet! s:lhs
unlet! s:user_map
unlet! s:mappings

" Autocommands " {{{1
augroup RelOps
    au!
    au CursorMoved,CursorMovedI * call s:reset()
augroup END

" Enables relative numbers and remembers current line numbering {{{1
function! s:operate() " {{{1
    if (!g:relops_check_for_nu || (&nu || &rnu))
                \ && &modifiable
        call s:reset()

        let s:save_numbers = [&nu, &rnu]
        set relativenumber
        let s:RelOps_pending = 1
    endif
endfunction

" Resets line numbering {{{1
function! s:reset() " {{{1
    if exists('s:RelOps_pending')
        unlet! s:RelOps_pending
        let &nu = s:save_numbers[0]
        let &rnu = s:save_numbers[1]
    endif
endfunction " }}}1

" vim:foldmethod=marker:
