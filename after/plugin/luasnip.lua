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
    --s('/ns', f(function() return nsUtils.getNamespace({ SearchPattern = "test.xml", XmlTag = "Root" }) end))
})

local csNamespaceNode = f(function()
    local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
    return "namespace " .. namespaceByFileLocation .. ";"
end)

local curExtensionlessBufname = f(function()
    local buffname = vim.fn.bufname();
    return vim.fn.fnamemodify(buffname, ":t:r")
end)

local classSnippet = function()
    local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
    local namspaceLine = "namespace " .. namespaceByFileLocation .. ";\n"
    local curFilename = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    return namspaceLine .. "pubilc class " .. curFilename .. "\n{\n\n}"
end

local writeToCurrentBuffer = function(text)
    local currentBuffer = vim.api.nvim_get_current_buf();

    local lines = {};
    for line in string.gmatch(text, "[^\n]+") do
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(currentBuffer, 0, 1, true, lines)
end

local classExpander = function()
    local classString = classSnippet()
    writeToCurrentBuffer(classString)

    return "";
end

local xamlStarter = [[
<UserControl
    x:Class="$"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:mvvm="http://prismlibrary.com/"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    mc:Ignorable="d"
    mvvm:ViewModelLocator.AutoWireViewModel="True">

</UserControl>
]]

local xamlCodeBehind = [[
using System.Windows.Controls;

$

public partial class $ : UserControl
{
    public $()
    {
        InitializeComponent();
    }
}
]]

local writeToNewFile = function(filename, text)
    local currentDir = vim.fn.expand("%:p:h")
    local newFilePath = currentDir .. "/" .. filename

    local file = io.open(newFilePath, "w")

    assert(file, "The file " .. newFilePath .. " could not be created")

    file:write(text)
    file:close()
end


local xamlExpander = function()
    local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
    local fileNameWithoutSuffix = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")

    local namespaceWFilename = namespaceByFileLocation .. "." .. fileNameWithoutSuffix;
    local xaml = string.gsub(xamlStarter, "%$", namespaceWFilename)

    writeToCurrentBuffer(xaml)

    -- now create the code behind
    local namespaceLine = "namespace " .. namespaceByFileLocation .. ";"
    local codeBehindFileName = fileNameWithoutSuffix .. ".xaml.cs"

    local replacements = { namespaceLine, fileNameWithoutSuffix, fileNameWithoutSuffix };
    local index = 1; -- tables are 1 based indexes? yes appearently

    local codeBehind = string.gsub(xamlCodeBehind, "%$", function(match)
        local currentRepl = replacements[index]
        index = index + 1
        return currentRepl
    end)
    writeToNewFile(codeBehindFileName, codeBehind)

    return ""
end


ls.add_snippets("xml", {
    s('/class', f(classExpander)),
    s('/xaml', f(xamlExpander))
})
ls.add_snippets("cs", {
    ls.parser.parse_snippet("/sum", "/// <summary>\n///    $0\n/// </summary>"),
    --ls.parser.parse_snippet("/class", classSnippet),
    --s('/test', fmt("{}", { f(classSnippet) })),

    -- { csNamespaceNode, t("class"), curExtensionlessBufname })
    s('/ns', csNamespaceNode),
    s("/class", f(classExpander)),

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
    s("/test", fmt("local {} =  {} ", { i(1), c(2, { t 'hello', t 'world' }) })),
    s("/t1", { t 'hello', t 'there' }),

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
