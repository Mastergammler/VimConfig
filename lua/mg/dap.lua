-- debugging configuration
local dap = require('dap');
vim.keymap.set("n","<F5>",dap.continue,{desc = "debugger"})
vim.keymap.set("n","<F10>",dap.step_over,{desc = "debugger"})
vim.keymap.set("n","<F11>",dap.step_into,{desc = "debugger"})
vim.keymap.set("n","<F12>",dap.step_out,{desc = "debugger"})
vim.keymap.set("n","<leader>b",dap.toggle_breakpoint,{desc = "debugger"})
vim.keymap.set("n","<leader>B",function()
    dap.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))
end,{desc = "debugger"})
vim.keymap.set("n","<leader>dl",function()
    dap.toggle_breakpoint(nil,nil,vim.fn.input('Log point message: '))
end,{desc = "debug log"})
vim.keymap.set("n","<leader>dr",dap.repl.open ,{desc = "debug repl open"})

-- dap / delete around paragraph
-- ap = around paragraph
