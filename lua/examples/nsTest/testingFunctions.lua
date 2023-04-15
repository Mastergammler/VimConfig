local function getBufferFilePath()
    local bufferFilePath = vim.api.nvim_buf_get_name(0);
    print("curBuf-FilePath", bufferFilePath)
    return bufferFilePath
end

local function examples(filePath)
    -- getting file nme from path
    local fileName = vim.fn.fnamemodify(filePath, ":t:r")
    print("fileName", fileName)

    -- getting current working dir
    local rootDir = vim.fn.getcwd()
    print(rootDir)

    -- getting relative dir of current file
    -- TODO: not really this only gets rel dir for root dir
    local relDir = vim.fn.fnamemodify(filePath, ":." .. rootDir .. ":")
    print(relDir)
end

--[[
Gets the parent directory from either a file or directory
This is just a string modification function, it doens't actually check for existing paths

@param path (string) The path from which to get the parent directory from
]]
local function getParentDir(path)
    return vim.fn.fnamemodify(path, ":h")
end

local function searchPatternInDir(searchPattern, dir)
    -- NOTE: returns a string containing the file paths
    local foundFiles = vim.fn.glob(dir .. "\\" .. searchPattern)

    if foundFiles and foundFiles ~= "" then
        return foundFiles
    end

    -- not found just return null
    return nil
end


local function findFilePathUptree(searchFile, startSearchDir)
    local currentSearchDir = startSearchDir
    local workspaceRootDir = vim.fn.getcwd()
    local currentFileToCheck = nil

    while currentSearchDir ~= '' do
        currentFileToCheck = searchPatternInDir(searchFile, currentSearchDir)
        if currentFileToCheck then break end

        assert(#currentSearchDir > #workspaceRootDir,
            "Did not find the file " .. searchFile .. " within the scope of the workspace " .. workspaceRootDir)
        currentSearchDir = getParentDir(currentSearchDir)
    end

    print("File ", searchFile, " found in dir ", currentSearchDir)

    return currentFileToCheck
end

local function readTagFromXml(path, xmlTag)
    local xmlFile = io.open(path, "r")
    assert(xmlFile ~= nil, "ERROR: File " .. path .. " not found!")

    local xmlData = xmlFile:read("*all")
    xmlFile:close()

    local startFirst_idx, startLast_idx = xmlData:find("<" .. xmlTag .. ">")
    local endFirst_idx, _ = xmlData:find("</" .. xmlTag .. ">")

    if startFirst_idx ~= nil then
        return xmlData:sub(startLast_idx + 1, endFirst_idx - 1)
    else
        warning("Tag " .. xmlTag .. " not fonud in " .. path)
        return ""
    end
end

local function buildCurrentFileNamespace(currentFile, searchFile, rootNamespace)
    local currentFileNs = string.gsub(getParentDir(currentFile), "[/\\]", ".")
    local projectFileNs = string.gsub(getParentDir(searchFile), "[/\\]", ".")

    -- not quite sure why +2 -> +1 is because of the .
    -- dunno why the length doesn't correspond to the next char
    local relNamespace = currentFileNs:sub(#projectFileNs + 2)

    if #rootNamespace > 0 then
        return rootNamespace .. "." .. relNamespace
    else
        return relNamespace
    end
end

local function showExecutionTime(startTime, finishedTime)
    local timeSeconds = finishedTime - startTime
    local timeMillsecond = timeSeconds * 1000
    -- NOTE: it seems like it only tracks to ms precision
    print(string.format("The operation took %d ms", timeMillsecond));
end

local function getFileNamespace(opt)
    local operationStart = os.clock()

    local currentFilePath = getBufferFilePath()
    local startSearchDir = getParentDir(currentFilePath)
    local searchFile = findFilePathUptree(opt.SearchPattern, startSearchDir)
    local xmlSpecifiedNamespace = readTagFromXml(searchFile, opt.XmlTag)
    local namespace = buildCurrentFileNamespace(currentFilePath, searchFile, xmlSpecifiedNamespace)

    local operationEnd = os.clock()
    showExecutionTime(operationStart, operationEnd)

    return namespace
end

-- debug etc
-- print(getFileNamespace({ SearchPattern = "*.xml", XmlTag = "Root" }))

return {
    getNamespace = getFileNamespace,
    parentDirOf = getParentDir
}
