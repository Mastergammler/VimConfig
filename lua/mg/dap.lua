-- debugging configuration
local dap = require('dap');
local dapui = require('dapui')
vim.keymap.set("n", "<F5>", dap.continue, { desc = "debugger" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "debugger" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "debugger" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "debugger" })
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "debugger toogle [b]reakpoint" })
vim.keymap.set("n", "<leader>B", function()
    dap.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "debugger [B]reakpoint condition" })
vim.keymap.set("n", "<leader>dl", function()
    dap.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { desc = "debug log messag" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "debug repl open" })

-- dap / delete around paragraph
-- ap = around paragraph

dap.adapters.coreclr = {
    type = "executable",
    -- TODO: independant pull -> based on nvim dir? (but that would differ on linux and windows right?)
    -- just find the mason bin dir -> that should do it!
    --command = 'C:/Users/MG/AppData/Local/nvim-data/mason/bin/netcoredbg',
    --command = 'c:/users/mg/appdata/local/nvim-data/mason/bin/netcoredbg',
    -- so i can't use the mason one, i have to link to the path directly'
    command = 'C:/Users/MG/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.set_log_level('DEBUG')

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - notcoredbg",
        request = "launch",
        program = function()
            -- TODO: use my find project dir folder -> get the project name, get the dll name from there!
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end
    }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_existed["dapui_config"] = function()
    dapui.close()
end
