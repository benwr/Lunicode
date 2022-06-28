if exists("g:loaded_lunicode")
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let s:lua_rocks_deps_loc = expand("<sfile>:h:r") . "/../lua/example-plugin/deps"
execute "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"

if exists("g:lunicode_normal_key")
  let s:normal_key = g:lunicode_normal_key
else
  let s:normal_key = "<leader>k"
endif

execute 'nnoremap <expr> ' . s:normal_key . ' LunicodeConvert()'
execute 'xnoremap <expr> ' . s:normal_key . ' LunicodeConvert()'

if exists("g:lunicode_insert_key")
  let s:insert_key = g:lunicode_insert_key
else
  let s:insert_key = "<C-k>"
endif

" TODO ugh; how can I do this without recursive mappings?
execute 'imap ' . s:insert_key . " <Esc>" . s:normal_key

if exists("g:lunicode_line_key")
  let s:line_key = g:lunicode_line_key
else
  let s:line_key = "<leader>K"
endif

execute 'nnoremap <expr> ' . s:line_key . " LunicodeConvert() .. '_'"

if exists("g:lunicode_insert_line_key")
  let s:insert_line_key = g:lunicode_insert_line_key
else
  let s:insert_line_key = "<C-k><C-k>"
endif

execute 'imap ' . s:insert_line_key . " <C-o>" . s:line_key

if !exists("g:lunicode_map")
  let g:lunicode_map = {}
endif

function LunicodeConvert(type = '') abort
  if a:type == ''
    set opfunc=LunicodeConvert
    return 'g@'
  endif

  let sel_save = &selection
  let reg_save = getreginfo('"')
  let cb_save = &clipboard
  let visual_marks_save = [getpos("'<"), getpos("'>")]

  try
    set clipboard= selection=inclusive
    let copy_commands = #{line: "'[V']y", char: "`[v`]y", block: "`[\<c-v>`]y"}
    silent exe 'noautocmd keepjumps normal! ' .. get(copy_commands, a:type, '')

    let l:result = luaeval("require('lunicode').lunicode_convert(_A)", getreg('"'))

    call setreg('"', l:result)

    let paste_commands = #{line: "'[V']p", char: "`[v`]p", block: "`[\<c-v>`]y"}
    silent exe 'noautocmd keepjumps normal! ' .. get(paste_commands, a:type, '')
  finally
    let &selection = sel_save
    call setreg('"', reg_save)
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
    let &clipboard = cb_save
  endtry
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo

let g:loaded_lunicode = 1

