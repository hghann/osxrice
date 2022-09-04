vim.cmd [[
function! CommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
                \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
                \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
"call CommandAlias('W','w')
call CommandAlias("w'",'w')
call CommandAlias('Wq','wq')
call CommandAlias('WQ','wq')
call CommandAlias('Q','q')
"call CommandAlias('man','Man')
"call CommandAlias('git','Git')
"call CommandAlias('cp','!cp')
"call CommandAlias('mv','!mv')
"call CommandAlias('rm','!rm')
"call CommandAlias('mkdir','!mkdir')
"call CommandAlias('ss','s//g\<Left>\<Left>')
]]
