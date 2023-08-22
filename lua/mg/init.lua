local startTime = os.clock()

local nsUtils = require('examples.nsTest.testingFunctions')

require("mg/set")
require("mg/remap")
require("mg/globals")
require("mg/dap")
-- require("mg/commands")


local function highlightCurrentWord()
    local searchWord = vim.fn.expand("<cword>")
    vim.cmd(string.format("/%s", searchWord))
end

vim.keymap.set("n", "<leader>hl", highlightCurrentWord, { desc = "[h]igh[l]ight current word" })

local endTime = os.clock()

--nsUtils.printExecutionTime(startTime, endTime)
--print("Hello from MG")
