vim.cmd([[
function! s:inSlash()
  call search('/', 'bceW')
  normal! lv
  call search('/', 'ceW')
  normal! h
endfunction

function! s:aroundSlash()
  call search('/', 'bceW')
  normal! v
  call search('/', 'eW')
endfunction

xnoremap <buffer> <silent> i/ :<C-u>call <SID>inSlash()<CR>
onoremap <buffer> <silent> i/ :<C-u>call <SID>inSlash()<CR>
xnoremap <buffer> <silent> a/ :<C-u>call <SID>aroundSlash()<CR>
onoremap <buffer> <silent> a/ :<C-u>call <SID>aroundSlash()<CR>
]])
