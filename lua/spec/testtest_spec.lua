describe("testing the testing", function()
    local hello = function(boo)
        return "bello " .. boo
    end

    it("test1", function()
        assert.equals("bello Brian", hello("Brian"))
    end)
end)
