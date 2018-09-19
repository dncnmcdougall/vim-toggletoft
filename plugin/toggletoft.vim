function! s:ToggleToFT(...)

    if a:0 > 0 
        let l:FT = a:0
    else
        let l:FT = "term"
    endif

    let l:previousWinNr = winnr()
    let l:previousTab = tabpagenr()

    if &ft == l:FT
        let l:winNr = s:previousWinNr
        exe s:previousTab."tabnext"
        exe l:winNr."wincmd w"
    else
        let windows = getwininfo()

        let l:termWinNr = -1
        let l:termTab = -1

        for window in windows
            if getbufvar(window.bufnr, "&ft") == l:FT
                if l:termWinNr == -1
                    let l:termWinNr = window.winnr
                    let l:termTab = window.tabnr
                else
                    let l:termWinNr = min([window.winnr, l:termWinNr])
                    let l:termTab = min([window.tabnr, l:termTab])
                endif
            endif
        endfor

        if l:termWinNr != -1
            exe l:termTab."tabnext"
            exe l:termWinNr."wincmd w"
        endif
    endif

    let s:previousWinNr = l:previousWinNr
    let s:previousTab = l:previousTab
endfunction

function! s:RecordWindow()
    let s:previousWinNr = winnr()
    let s:previousTab = tabpagenr()
endfunction

augroup toggletoft
    autocmd!
    autocmd! WinLeave * call s:RecordWindow()
augroup END

command! -nargs=? ToggleToFT call s:ToggleToFT(<q-args>)
