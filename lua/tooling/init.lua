--[[
Goals and ideas:

MAIN GOAL: REDUCE FRICTION

- maybe do something for starting via IIS Express?
-> I would need some configuration etc?
- workspace switch?
-> Would need some index of workspaces -> folder <-> name match
=> Would this work with harpoon?
--]]
local cstools = require('tooling.cs.projectsearch')

assert(cstools ~= nil, "CS-Tool module not found")
assert(cstools.getRootDir ~= nil, "function not found")


--vim.keymap.set("n", "<leader>tt", execTest, { desc = "[t]est [t]est" })
vim.keymap.set("n", "<leader>tt", cstools.getRootDir, { desc = "[t]est [t]est" })
