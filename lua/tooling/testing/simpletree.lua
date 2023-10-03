local nsUtils = require('examples.nsTest.testingFunctions')

local tree = {
    -- string content
    value = nil,
    -- parent node
    parent = nil,
    -- child nodes
    children = nil,
}

function add_child(node, childNode)
    childNode.parent = node

    if node.children == nil then
        node.children = {}
    end

    table.insert(node.children, childNode)
end

local function build_tree()
    tree.value = "root"

    local l1_1 = { value = "child1" }
    local l1_2 = { value = "child2" }
    local l1_3 = { value = "child3" }

    add_child(tree, l1_1)
    add_child(tree, l1_2)
    add_child(tree, l1_3)

    add_child(l1_1, { value = "sub 1" })
    add_child(l1_1, { value = "sub 2" })
    add_child(l1_1, { value = "sub 3" })

    add_child(l1_3, { value = "sub c1" })
    add_child(l1_3, { value = "sub c2" })
    add_child(l1_3, { value = "sub c3" })

    return tree
end

-- PRINTING --

local outputBuffer = nil;

function setupBuffer()
    if not outputBuffer then
        outputBuffer = vim.api.nvim_create_buf(true, false)
    end

    vim.api.nvim_command("belowright split")
    vim.api.nvim_command("buffer " .. outputBuffer)
end

function buffer_print(lineIndex, text)
    -- use this to append at the end of the buffer
    vim.api.nvim_buf_set_lines(outputBuffer, lineIndex, lineIndex, false, { text })
end

local tab = "  "

function print_tree(tree, indent)
    buffer_print(-1, string.rep(tab, indent) .. tree.value)

    if tree.children ~= nil then
        for idx, node in ipairs(tree.children) do
            print_tree(node, indent + 1)
        end
    end
end

-- TREE OPERATIONS --

function run()
    local tree = build_tree()
    setupBuffer()
    print_tree(tree, 0)
end

local startTime = os.clock();
run()
local endTime = os.clock()
nsUtils.printExecutionTime(startTime, endTime)
