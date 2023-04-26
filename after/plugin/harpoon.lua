local nsUtils = require('examples.nsTest.testingFunctions')
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local term = require("harpoon.term")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[A]dd file to harpoon list" })
vim.keymap.set("n", "<leader>lh", ui.toggle_quick_menu, { desc = "[l]ist [h]arpoon targets" })
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
vim.keymap.set("n", "`1", function() term.gotoTerminal(1) end)
vim.keymap.set("n", "`2", function() term.gotoTerminal(2) end)
vim.keymap.set("n", "`3", function() term.gotoTerminal(3) end)
vim.keymap.set("n", "`4", function() term.gotoTerminal(4) end)

-- dotnetCommand: build|run|watch (not sure watch works)
function sendDotnetCommand(dotnetCommand, cmdNo)
    local projectFile = nsUtils.findProjectFile({ SearchPattern = "*.csproj" })
    local pathQuoted = string.format('"%s"', projectFile)
    local command

    if dotnetCommand == "run" then
        command = "dotnet " .. dotnetCommand .. " --project " .. pathQuoted
    else
        command = "dotnet " .. dotnetCommand .. " " .. pathQuoted
    end

    term.sendCommand(cmdNo, command .. "\r")
    print("Starting", dotnetCommand, "...")
end

vim.keymap.set("n", "<C-B>", function() sendDotnetCommand("build", 1) end, { desc = "[B]uild project" })
vim.keymap.set("n", "<C-R>", function() sendDotnetCommand("run", 1) end, { desc = "[R]un project" })
vim.keymap.set("n", "<C-T>", function() sendDotnetCommand("test", 2) end, { desc = "[T]est project" })
vim.keymap.set("n", "<leader>tf", function()
    local curFileName = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    local cmd = "test " .. "--filter " .. curFileName
    sendDotnetCommand(cmd, 2)
    print("Start testing ", curFileName)
end, { desc = "[t]est [f]ile - runs dotnet test for the file" })
