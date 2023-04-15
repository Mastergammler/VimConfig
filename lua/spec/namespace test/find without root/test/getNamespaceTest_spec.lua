local cs_ns_finder = require("examples.nsTest.testingFunctions")

describe("TEST getFileNamespace :: no root", function()
    local searchOpts = {
        SearchPattern = "*.xml",
        XmlTag = "Root",
        TargetFilePath = "home/mg/.config/nvim/lua/spec/namespace test/find without root/test/getNamespaceTest_spec.lua"
    }

    it("getNamespace", function()
        local actual = cs_ns_finder.getNamespace(searchOpts)
        print(actual)
        assert.equals("mydir\\something", actual)
    end)
end)
