-- this is the way to load a file directly
-- local xmlUtils = dofile(vim.fn.stdpath('config') .. '\\examples\\nsTest\\testingFunctions.lua')
local nsUtils = require('examples.nsTest.testingFunctions')

local ls = require 'luasnip'
local types = require 'luasnip.util.types'
local s, t, i = ls.snippet, ls.text_node, ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt;
local rep = require("luasnip.extras").rep

ls.config.set_config {

    -- remembering the last snippet somehow
    history = true,

    -- dynamic snippets, update as you type
    updateevents = "TextChanged, TextChangedI",

    -- what are those?
    enable_autosnippets = true,

    -- advanced stuff for later
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "<- Current choice", "Info" } },
            }
        }
    }
}


-- -------------------- FUNCTIONS --------------------


-- ------------------------------- SNIPPETS ------------------------
-- FIXME: loads every snippet multiple times / every time the file is sourced

ls.add_snippets("all", {
    ls.parser.parse_snippet("/os", "-- testing other style!"),
    s('/ns', f(function() return nsUtils.getNamespace({ SearchPattern = "test.xml", XmlTag = "Root" }) end))
})

ls.add_snippets("cs", {
    ls.parser.parse_snippet("/sum", "/// <summary>\n///    $0\n/// </summary>"),
    s('/ns', f(function()
        local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
        return "namespace " .. namespaceByFileLocation .. ";"
    end)),

    -- FIXME: this is not working because of the whitespaces essentialy
    -- Or rather it is not formating the text correctly
    s("/nunit",
        fmt([[
        [Test]
        public void {}()
        {{
            {}
        }}
        ]], {

            i(1), c(0, {
            fmt([[

            //----------------
            //    GIVEN

            //----------------
            //    WHEN

            //----------------
            //    THEN

            ]], {}),
            t('')
        })
        })
    ),
    -- FIXME: this is not working either, get an error during expansion
    -- luasnippets really doesn't like this it seems
    s("/nu",
        fmt([[
        [Test]
        public void {}()
        {{
            {}
        }}
        ]],
            {
                i(1), c(0, { t('hello something'), t('') })
            })
    )
})

ls.add_snippets("lua", {
    -- variable ref / $0 is the last jump point
    ls.parser.parse_snippet("/eg", "-- Defined in $TM_FILENAME $1\n$0\n"),
    -- repeat the first insert
    s("/req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
    s("/test", fmt("local {} =  {} ", { i(1), c(2, { t 'hello', t 'world' }) }))
})


-- -------------------------------- KEYMAPS -----------------------

-- keymaps for this
vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true, desc = "Goto next snippet position" })
vim.keymap.set({ "i", "s" }, "<c-h>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true, desc = "Goto previous snippet position" })

vim.keymap.set({ "i", "s" }, "<M-.>", function()
    print("trying to find next")
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { desc = "Show next snippet choice" })





-- reload snippets after editing them / on windows
vim.keymap.set("n", "<leader>so", "<cmd>source ~/appdata/local/nvim/after/plugin/luasnip.lua<CR>",
    { desc = "relaod snippets after change" })

print("Snippets reloaded!")
