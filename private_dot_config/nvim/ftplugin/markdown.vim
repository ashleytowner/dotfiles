" Header Text Objects
function! s:inHeader()
  call search('^#\{1,6\}', 'bceW')
  normal! lvg_
endfunction

function! s:aroundHeader()
  call search('^#\{1,6\}', 'bceW')
  normal! 0vg_
endfunction

xnoremap <silent> <buffer> ih :<C-u>call <SID>inHeader()<CR>
onoremap <silent> <buffer> ih :<C-u>call <SID>inHeader()<CR>
xnoremap <silent> <buffer> ah :<C-u>call <SID>aroundHeader()<CR>
onoremap <silent> <buffer> ah :<C-u>call <SID>aroundHeader()<CR>

" Code fence text objects
function! s:inCodeFence()
    " Search backwards for the opening of the code fence.
	call search('^```.*$', 'bceW')
    " Move one line down
	normal! j
    " Move to the begining of the line at start selecting
	normal! 0v
    " Search forward for the closing of the code fence.
	call search("```", 'ceW')

	normal! kg_
endfunction

function! s:aroundCodeFence()
    " Search backwards for the opening of the code fence.
	call search('^```.*$', 'bcW')
	normal! v$
    " Search forward for the closing of the code fence.
	call search('```', 'eW')
endfunction

xnoremap <silent> if :<c-u>call <sid>inCodeFence()<cr>
onoremap <silent> if :<c-u>call <sid>inCodeFence()<cr>
xnoremap <silent> af :<c-u>call <sid>aroundCodeFence()<cr>
onoremap <silent> af :<c-u>call <sid>aroundCodeFence()<cr>
