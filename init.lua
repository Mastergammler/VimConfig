local startTime = os.clock();
local nsUtils = require('examples.nsTest.testingFunctions')

require("mg")
require("tooling")
require("packer")
require("tooling.refactoring")
--require("examples")

vim.cmd('autocmd BufNewFile,BufRead *.xaml set filetype=xml')

-- FIXME: getcwd also doesn't work 'workaround because dirchange broken on wsl?
--vim.cmd('cd ' .. vim.fn.getcwd())

local endTime = os.clock();
--nsUtils.printExecutionTime(startTime, endTime)
--print("Loaded init 2302")
