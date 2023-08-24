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
vim.keymap.set({ "n", "t" }, "`1", function() term.gotoTerminal(1) end)
vim.keymap.set({ "n", "t" }, "`2", function() term.gotoTerminal(2) end)
vim.keymap.set({ "n", "t" }, "`3", function() term.gotoTerminal(3) end)
vim.keymap.set({ "n", "t" }, "`4", function() term.gotoTerminal(4) end)
vim.keymap.set({ "n", "t" }, "`5", function() term.gotoTerminal(5) end)

-- dotnetCommand: build|run|watch (not sure watch works)
vim.keymap.set("n", "<C-B>", function() executeProjectCommand("build", 1) end, { desc = "[B]uild project" })
vim.keymap.set("n", "<C-R>", function() executeProjectCommand("run", 1) end, { desc = "[R]un project" })
vim.keymap.set("n", "<C-T>", function() executeProjectCommand("test", 2) end, { desc = "[T]est project" })
vim.keymap.set("n", "<leader>tf", function()
    local curFileName = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    local cmd = "test " .. "--filter " .. curFileName
    executeProjectCommand(cmd, 2)
    print("Start testing ", curFileName)
end, { desc = "[t]est [f]ile - runs dotnet test for the file" })

--   ************************* Functions  *******************************

local ProjectType = {
    CSharp = "*.csproj",
    Gradle = "build.gradle"
}
function sendDotnetCommand(dotnetCommand, cmdNo, projectFile)
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

function sendGradleCommand(commandName, cmdNo, buildFile)
    local command = "gradle " .. commandName;
    term.sendCommand(cmdNo, command .. "\r");
    print("Starting", command, "...")
end

function executeProjectCommand(commandName, cmdNo)
    local type, projectFile = determineProjectType();

    if type ~= nil then
        for k, v in pairs(ProjectType) do
            if type == k and v == ProjectType.CSharp then
                print("Detected type " .. type)
                sendDotnetCommand(commandName, cmdNo, projectFile)
            elseif type == k and v == ProjectType.Gradle then
                print("Detected type " .. type)
                sendGradleCommand(commandName, cmdNo, projectFile)
            end
        end
    else
        print "No buildable project files where found in the current working directory"
    end
end

function determineProjectType()
    for key, value in pairs(ProjectType) do
        local projectFile = nsUtils.findProjectFile({ SearchPattern = value })
        if projectFile ~= nil then
            return key, projectFile
        end
    end
end

function testIf()
    if "CSharp" == ProjectType.CSharp then
        print "csharp yay"
    end
    print("" .. ProjectType.CSharp)
end

vim.keymap.set("n", "<leader>gc", function() testIf() end,
    { desc = "[g]o [c]ommand!!! - runs a lua function for testing purposes" })
