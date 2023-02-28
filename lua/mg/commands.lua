vim.cmd("command! -nargs=* -complete=shellcmd Git silent! execute '!" .. vim.fn.systemlist("which git")[1] .. " <args>'")
vim.cmd("command! -nargs=* -complete=shellcmd git silent! execute 'Git <args>'")
