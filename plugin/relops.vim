" File: relops.vim
" Author: Mohammed Chelouti <mhc23 at web dot de>
" Description: Plugin that enables relative numbers for pending operation.
" Last Modified: Sep 23, 2012

if exists('g:loaded_relops') && v:version <= 703 && has('autocmd')
    finish
endif
let g:loaded_relops = 1

if !exists('g:relops_check_for_nu')
    let g:relops_check_for_nu = 1
endif

" Plugin mappings {{{1
nnoremap <Plug>RelopsEnablernu :call RelOps_operate()<CR>

" Bind default vim operation keys {{{2
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
                \ 'zf']

for s:m in s:mappings
    if empty(maparg(s:m, 'n'))
        execute 'nnoremap <silent>' s:m ':call RelOps_operate()<CR>'.s:m
    endif
endfor

for s:m in ['<C-c>', '<Esc>']
    if empty(maparg(s:m, 'o'))
        execute 'onoremap <silent>' s:m ':call <SID>reset()<CR>'.s:m
    endif
endfor

" Special case: tilde
if &tildeop
    if empty(maparg('~', 'n'))
        execute 'nnoremap <silent> ~ :call RelOps_operate()<CR>~'
    endif
endif

" Clean up {{{2
unlet! s:m
unlet! s:lhs
unlet! s:user_map
unlet! s:mappings

" Autocommands {{{1
augroup RelOps
    au!
    au CursorMoved,CursorMovedI,BufLeave * silent call s:reset()
augroup END


" Enables relative numbers and remembers current line numbering {{{1
function! RelOps_operate() " {{{1
    if (!g:relops_check_for_nu || (&nu || &rnu))
                \ && &modifiable
        call s:reset()

        let s:save_opts = [&nu, &rnu, &nuw]
        let &nuw = s:visual_number_width() " prevent number column from 'wiggling'
        set relativenumber
        let s:relops_pending = 1
    endif
endfunction

" Resets line numbering {{{1
function! s:reset() " {{{1
    if exists('s:relops_pending')
        unlet! s:relops_pending
        let &nu = s:save_opts[0]
        let &rnu = s:save_opts[1]
        let &nuw = s:save_opts[2]
    endif
endfunction

" Returns: (int) width of the line number column. {{{1
function! s:visual_number_width() " {{{1
    let l:width = strlen(line('w$')) + 1

    if l:width >= &numberwidth
        return l:width
    else
        return &numberwidth
    endif
endfunction
" vim:foldmethod=marker:
