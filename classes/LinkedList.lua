local DirectedTree = {}
DirectedTree.__index = DirectedTree

function DirectedTree.new(dialogTree)
    assert(dialogTree, "dialogTree is nil")

    return setmetatable({
        rootDialog = dialogTree[1],
    }, DirectedTree)

end



return DirectedTree