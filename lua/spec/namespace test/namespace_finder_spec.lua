local cs_ns_finder = require("examples.nsTest.testingFunctions")

describe("TEST parentDirOf ::", function()
    it("HP - file", function()
        local testPath = "mydir/path/myfile.lua"
        local parentDir = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/path", parentDir)
    end)

    it("path with spaces", function()
        local testPath = "mydir/dumb path/myfile.lua"
        local actualDir = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/dumb path", actualDir)
    end)

    it("HP - directory", function()
        local testPath = "mydir/something/another"
        local actual = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/something", actual)
    end)

    it("last dir with space", function()
        local testPath = "mydir/something/dumb path"
        local actual = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/something", actual)
    end)

    it("removes stuff until last dirpath", function()
        local testPath = "mydir/something/"
        local actual = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/something", actual)
    end)

    -- NOTE: would be interesting to see if it would work on windows
    -- if it is system dependant (which would be expected)
    it("works with backslashes", function()
        local testPath = "mydir\\something\\myfile.lua"
        local actual = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir\\something", actual)
    end)
end)
