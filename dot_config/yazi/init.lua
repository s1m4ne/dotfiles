require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})

require("full-border"):setup {
  type = ui.Border.ROUNDED,
}

require("smart-enter"):setup{
  open_multi = false,
}
