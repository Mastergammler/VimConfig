local bufferWriter = require('tooling.snippets.bufferWriter')
-- TODO: refactor somewhere else
local nsUtils = require('examples.nsTest.testingFunctions')

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

local namespaceLine = function()
    local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
    return "namespace " .. namespaceByFileLocation .. ";"
end

local classSnippet = function()
    local namspaceLine = namespaceLine() .. "\n"
    local curFilename = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    return namspaceLine .. "pubilc class " .. curFilename .. "\n{\n\n}"
end

-- ------------ HACK: injection via lua snippets ------------------

-- creates a empty class file with it's namespace
local classExpander = function()
    bufferWriter.writeToCurrentBuffer(classSnippet())
    return "";
end

-- creates the xaml content and the necessary code behind file for it
local xamlExpander = function()
    local namespaceByFileLocation = nsUtils.getNamespace({ SearchPattern = "*.csproj", XmlTag = "RootNamespace" });
    local fileNameWithoutSuffix = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")

    local namespaceWFilename = namespaceByFileLocation .. "." .. fileNameWithoutSuffix;
    local xaml = string.gsub(xamlStarter, "%$", namespaceWFilename)

    bufferWriter.writeToCurrentBuffer(xaml)

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
    bufferWriter.writeToNewFile(codeBehindFileName, codeBehind)

    return ""
end

return {
    expandNamespaceLine = namespaceLine,
    expandClass = classExpander,
    expandXaml = xamlExpander
}
