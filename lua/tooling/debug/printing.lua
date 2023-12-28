local OutputBuffer = nil;

function setupBuffer()
    if not OutputBuffer then
        OutputBuffer = vim.api.nvim_create_buf(true, false)
    end

    vim.api.nvim_command("belowright split")
    --vim.api.nvim_command("splitright split")
    vim.api.nvim_command("buffer " .. OutputBuffer)

    return OutputBuffer
end

function buffer_print(lineIndex, text)
    -- use this to append at the end of the buffer
    -- NOTE: -1 as first line skips the first line somehow (because it always appends?)
    -- so the first line stays empty?
    vim.api.nvim_buf_set_lines(OutputBuffer, lineIndex, lineIndex, false, { text })
end

function buffer_append_lines(lines)
    vim.api.nvim_buf_set_lines(OutputBuffer, 0, -1, false, lines)
end

--- tree that has children
--- the nodeStringFunction has to create the string for the node
--- hos to be compatible with it
function print_tree(tree, indent, nodeStringFunction)
    print("Function:", nodeStringFunction)
    buffer_print(-1, string.rep("    ", indent) .. nodeStringFunction(tree))

    if tree.children ~= nil then
        for idx, node in ipairs(tree.children) do
            print_tree(node, indent + 1, nodeStringFunction)
        end
    end
end

return {
    setup_buffer = setupBuffer,
    buffer_append_lines = buffer_append_lines,
    print_tree = print_tree

}
