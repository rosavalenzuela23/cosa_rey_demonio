local DialogSystem = require("classes.DialogSystem")
local Player       = require("classes.Player")
local EventBus     = require("classes.EventBus")

local NPC          = {}
NPC.__index        = NPC

local dialogSystem = DialogSystem.getInstance()

function NPC.new(name, dialogs, options, events)
    assert(name, "NPC name is required")
    assert(dialogs, "NPC dialogs are required")

    options = options or {
        position = { x = 0, y = 0 },
        sprite_location = nil,
        dialogRadiusThreshold = 20 -- px
    }

    if options.sprite_location then
        options.sprite = love.graphics.newImage(options.sprite_location)
    end

    local instance = setmetatable({
        name = name,
        dialogs = dialogs,
        position = options.position,
        sprite = options.sprite,
        dialogRadiusThreshold = options.dialogRadiusThreshold,
        _dialogSprite = love.graphics.newImage("assets/sprites/npc_sprites/global/interact_dialog.png")
    }, NPC)

    EventBus.getInstance():addEventListener(instance)

    return instance
end

function NPC:_notifyBusEvent(event, ...)
    if event:find("PlayerAction") and Player.getInstance():isInRadius(self.dialogRadiusThreshold, self.position.x, self.position.y) then
        self:showDialog(1)
    end
end

function NPC:notify(event, ...)
    if event:find("bus-") then
        self:_notifyBusEvent(event, ...)
    end
end

function NPC:showDialog(dialogNumber)
    EventBus.getInstance():dispatchEvent("DialogStarted")

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

    if Player.getInstance():isInRadius(self.dialogRadiusThreshold, self.position.x, self.position.y) then
        love.graphics.draw(self._dialogSprite, self.position.x, self.position.y - 40)
    end

    love.graphics.draw(self.sprite, self.position.x, self.position.y)
end

return NPC
