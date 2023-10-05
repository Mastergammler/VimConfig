local MARKDOWN_TEST_FILE = "lua/tooling/testing/res/simplemarkdown.md"
local BIG_FILE = "lua/tooling/testing/res/bigfile.md"


function get_file(bigFile)
    local bigFile = bigFile or false
    local file = nil
    if bigFile then
        file = io.open(BIG_FILE, "r")
    else
        file = io.open(MARKDOWN_TEST_FILE, "r")
    end
    return file
end

function loadFileContent(bigFile)
    local file = get_file(bigFile)
    if file then
        return file:read("*a")
    else
        print("Error reading file ..")
    end
end

function loadFileInLines(bigFile)
    local file = get_file(bigFile)
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end
        return lines
    else
        print("Error reading file ..")
    end
end

return {
    loadFileContent = loadFileContent,
    loadFileInLines = loadFileInLines
}
