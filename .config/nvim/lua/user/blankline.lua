local status_ok, blankline = pcall(require, "indent_blankline")
if not status_ok then
  return
end

-- Indent blankline
blankline.setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}
