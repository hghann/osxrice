vim.cmd [[
try
  "colorscheme darkplus
  colorscheme spaceway
  highlight Normal ctermbg=NONE guibg=NONE
  highlight Conceal ctermbg=NONE
  highlight NonText ctermbg=none guibg=none
  highlight SignColumn ctermbg=none guibg=none
  highlight LineNr ctermbg=none guibg=none
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
