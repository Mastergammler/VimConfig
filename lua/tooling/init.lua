-- you need to specify the path from the root lua folder!
local cstools = require('tooling.cs.projectsearch')

assert(cstools == nil, "CS-Tool module not found")
assert(cstools.getRootDir == nil, "function not found")

vim.keymap.set("n", "<leader>tt", cstools.getRootDir, { desc = "[t]est [t]est" })
