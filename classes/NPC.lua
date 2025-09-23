local DialogSystem = require("classes.DialogSystem")

local NPC = {}
NPC.__index = NPC

local dialogSystem = DialogSystem.getInstance()

function NPC.new(name, dialogs, options)
    assert(name, "NPC name is required")
    assert(dialogs, "NPC dialogs are required")

    options = options or {
        position = { x = 0, y = 0 },
        sprite_location = nil
    }

    if options.sprite_location then
        options.sprite = love.graphics.newImage(options.sprite_location)
    end

    return setmetatable({
        name = name,
        dialogs = dialogs,
        position = options.position,
        sprite = options.sprite
    }, NPC)

end

function NPC:showDialog(dialogNumber)
    if self.dialogs[dialogNumber].list then
        for _, message in pairs(self.dialogs[dialogNumber].messages) do
            dialogSystem:showMessage(self.name, message.message, message.config, message.options)
        end

        return
    end

    dialogSystem:showMessage(self.name, self.dialogs[dialogNumber].message, self.dialogs[dialogNumber].config,
        self.dialogs[dialogNumber].options)
end

function NPC:update(dt)

end

function NPC:draw()
    if not self.sprite then
        return
    end

    love.graphics.draw(self.sprite, self.position.x, self.position.y)
end

return NPC
