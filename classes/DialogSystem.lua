local TALKIES = require 'libraries.talkies.talkies'
local EventDispatcher = require("classes.EventDispatcher")

local DialogSystem = {}
DialogSystem.__index = DialogSystem

local instance = nil
local eventDispatcher = EventDispatcher.getInstance()

function DialogSystem.getInstance()
    if not instance then
        instance = setmetatable({
            active = false
        }, DialogSystem)

        eventDispatcher:addEventListener("keypressed", instance)
    end
    return instance
end

function DialogSystem:isActivate()
    return TALKIES.isOpen()
end

function DialogSystem:keypressed(key, scancode, isrepeat)

    if not self:isActivate() then
        return
    end

    if key == "w" then
        TALKIES.prevOption()
    end

    if key == "s" then
        TALKIES.nextOption()
    end

    if key == "space" then
        TALKIES.onAction()
    end
end

function DialogSystem:notify(event, ...)
    if event == "keypressed" then
        self:keypressed(...)
    end
end

function DialogSystem:update(dt)
    TALKIES.update(dt)
end

function DialogSystem:draw()
    TALKIES.draw()
end

function DialogSystem:_onStart() end

function DialogSystem:_onComplete(dialog, onComplete)
    if onComplete then
        onComplete()
    end

    self.active = false
end

function DialogSystem:showMessage(title, message, config, options)
    config = config or {}
    options = options or {}

    self.active = true
    TALKIES.say(title, message, {
        onstart = self._onStart,
        oncomplete = function(dialog)
            self:_onComplete(dialog, config.onComplete)
        end,
        options = options
    })
end

return DialogSystem
