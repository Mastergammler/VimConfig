-- todos
-- 1. get root dir
-- 2. traverse each directory & search for specific file
-- 3. accumulate paths & names
-- 4. make the choose menu for it

--[[
    The goal is to search for projects in the root directory
    To not always have to be on a file in the project i have to execute
    But have a simple dialogue with which i can choose the project to execute

    For run  or test projects equally
    Just a simple select dialogue with numbers 1,2,3 etc
]]
function execTest()
    local rootDir = vim.fn.getcwd();
    print('Root dir: ', rootDir)

    -- dunno what the parameters are for ...
    local luaFiles = vim.fn.glob(rootDir .. "\\" .. "*.lua", 0, 4)

    if #luaFiles == 0 then
        print("No files found")
    end

    for _, file in ipairs(luaFiles) do
        print(file)
    end

    print("Found " .. #luaFiles .. " lua files")
end

return {
    getRootDir = execTest
}
