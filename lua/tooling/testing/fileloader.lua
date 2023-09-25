local MARKDOWN_TEST_FILE = "lua/tooling/testing/res/simplemarkdown.md"
local BIG_FILE = "lua/tooling/testing/res/bigfile.md"

function loadFileContent()
    local file = io.open(MARKDOWN_TEST_FILE, "r")
    if file then
        return file:read("*a")
    else
        print("Error reading file ..")
    end
end

function loadFileInLines()
    local file = io.open(MARKDOWN_TEST_FILE, "r")
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

