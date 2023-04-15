local cs_ns_finder = require("examples.nsTest.testingFunctions")

describe("Namespace finder utils test", function()
    it("TestParentDir HP", function()
        local testPath = "mydir/path/myfile.lua"
        local parentDir = cs_ns_finder.parentDirOf(testPath)
        assert.equals("mydir/path", parentDir)
    end)
end)
