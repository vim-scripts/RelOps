" Add custom key bindings to relops.
if exists('g:relops_mappings')
    for s:m in g:relops_mappings
        let s:maparg = maparg(s:m, 'n', 0, 1)
        let s:nore = s:maparg.noremap == 1 ? 'nore' : ''

        if !empty(s:maparg)
            execute 'n'.s:nore.'map <silent>' s:m ':call RelOps_operate()<CR>'.s:maparg.rhs
        endif
    endfor
endif

unlet! s:m
unlet! s:maparg
unlet! s:nore
