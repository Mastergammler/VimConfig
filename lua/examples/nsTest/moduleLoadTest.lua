-- FIXME: editor is going crazy right here

local filePath = vim.api.nvim_buf_get_name(0);
print("Current file to execute", filePath)
print("LuaVersion:", _VERSION)

local testmod = require("examples.nstest.moduleTest")
local testingFunctnios = require("examples.nstest.testingFunctions")

print(P(testingFunctnios))
