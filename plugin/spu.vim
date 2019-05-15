
"=================== super persistant undo ===================
"double write file so backup is same as current file
"upon leader d, if "  execute 'rundo ' . undo_filename "  fails
  "read backup file, %!cat backupfile
  "do backup
let g:undo_filename = "." . expand('%:t') . ".un~"
function!  SPU()
 execute 'write! /tmp/spu'
 execute '%!cat ' . expand('%:t') . "~"
 "TODO check for error here as well
 execute 'rundo ' . g:undo_filename
 execute 'write'
 execute '%!cat /tmp/spu'
 execute 'write'
endfunction

function! IS_UNDOFILE_SANE()
  redir => listing
  "let v:warningmsg = ""
  silent execute 'rundo ' . g:undo_filename
  redir END
  "echo listing
  "if v:warningmsg =~ "File contents" 
    "return 0
  "endif

  if listing =~ "Finished reading undo file"
    return 1
  endif
  return 0
endfunction

function! Prompt_for_SUP()
  if IS_UNDOFILE_SANE()
    "echo "all okay"
  else
    echo "fuck"
  endif
endfunction

au BufRead * call Prompt_for_SUP()

" so that backups same as original file
au BufWritePost * execute 'write!'
