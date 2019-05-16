# spu.vim
Super persistent undo (keeps undotree even after file changed outside vim)

Fixes ([from](https://stackoverflow.com/a/16975959/2577465))
> However, note that if a file is modified externally without Vim, Vim will not be able to read the undo history back when you start editing the file again and the undo tree information will be lost. There is no way to get it back.
