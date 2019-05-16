"https://github.com/superjer/vimrc/blob/50660c3a2c50d2dacce64ea5f703a7ddd0237afd/.vimrc#L115
"=================== super persistant undo ===================
"double write file so backup is same as current file
"upon leader d, if "  execute 'rundo ' . undo_filename "  fails
  "read backup file, %!cat backupfile
  "do backup
"let g:spu_dir = $HOME . "/.spu.vim"

"if !isdirectory(g:spu_dir)
    "call mkdir(g:spu_dir, "p")
"endif

function!  SPU()
 let undo_filename = escape(undofile(expand('%')),'% ')
 let g:spu_bkp_name = &backupdir .  substitute(expand('%:p'), "/", "%", "g") . "~"
 "execute 'write! /tmp/spu'
 execute system("cp " . expand("%:p") . " /tmp/spu")
 if filereadable(g:spu_bkp_name)
   execute '%!cat ' . escape(g:spu_bkp_name, "% ")
  else
    echo "cannot restore undotree :C no backup exists"
 endif
 "TODO check for error here as well
 execute 'rundo ' . undo_filename
 execute 'write'
 execute '%!cat /tmp/spu'
 execute 'write'
endfunction

function! IS_UNDOFILE_SANE()
  let undo_filename = escape(undofile(expand('%')),'% ')
  redir => listing
  "let v:warningmsg = ""
  silent execute 'rundo ' . undo_filename
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
    let result = Confirm("Undo is lost, press Y to restore")
    if result
      call SPU()
    endif
  endif
endfunction

fun! Confirm(msg)
    echo a:msg . ' '
    let l:answer = nr2char(getchar())

    if l:answer ==? 'y'
        return 1
    elseif l:answer ==? 'n'
        return 0
    else
        echo 'Please enter "y" or "n"'
        return Confirm(a:msg)
    endif
endfun
au BufRead * call Prompt_for_SUP()

function! WriteBackup()
  silent execute 'write!'
endfunction

au BufWritePost * call WriteBackup()
