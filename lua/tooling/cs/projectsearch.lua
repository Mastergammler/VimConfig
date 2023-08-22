-- todos
-- 1. get root dir
-- 2. traverse each directory & search for specific file
-- 3. accumulate paths & names
-- 4. make the choose menu for it

print("Loading projectsearch")


function execTest()
    local rootDir = vim.fn.getcwd();
    print('Root dir: ', rootDir)

    -- dunno what the parameters are for ...
    local luaFiles = vim.fn.glob(rootDir .. "\\" .. "*.lua", 0, 4)

    if #luaFiles == 0 then
        print("No files found")
    end

    print("Found " .. #luaFiles .. " lua files")

    for _, file in ipairs(luaFiles) do
        print(file)
    end

    print('finished')
end

--[[return {
    getRootDir = getRootDir
}]]
--

vim.keymap.set("n", "<leader>tt", execTest, { desc = "[t]est [t]est" })
