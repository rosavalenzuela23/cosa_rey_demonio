local DialogSystem = require("classes.DialogSystem")

local NPC = {}
NPC.__index = NPC

local dialogSystem = DialogSystem.getInstance()

function NPC.new(name, dialogs, options)
    assert(name, "NPC name is required")
    assert(dialogs, "NPC dialogs are required")

    options = options or {
        position = { x = 0, y = 0 }
    }

    return setmetatable({
        name = name,
        dialogs = dialogs,
        position = options.position
    }, NPC)
end

function NPC:showDialog(dialogNumber)
    dialogSystem:showMessage(self.name, self.dialogs[dialogNumber].message, self.dialogs[dialogNumber].config,
        self.dialogs[dialogNumber].options)
end

function NPC:update(dt)

end

function NPC:draw()

end

return NPC
