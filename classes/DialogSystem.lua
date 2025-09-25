local TALKIES = require 'libraries.talkies.talkies'
local EventDispatcher = require("classes.EventDispatcher")
local EventBus        = require("classes.EventBus")
local State = require("classes.State")

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

    local keyboard = State.config.keyboard

    if key == keyboard.up.primary or key == keyboard.up.secondary then
        TALKIES.prevOption()
    end

    if key == keyboard.down.primary or key == keyboard.down.secondary then
        TALKIES.nextOption()
    end

    if key == keyboard.interact.primary or key == keyboard.interact.secondary then
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
    if not TALKIES.isOpen() then
        EventBus.getInstance():dispatchEvent("DialogEnded")
    end
end

function DialogSystem:showMessage(title, message, config, options)
    config = config or {}

    self.active = true
    TALKIES.say(title, message, {
        onstart = self._onStart,
        oncomplete = function(dialog)
            self:_onComplete(dialog, config.oncomplete)
        end,
        options = options
    })
end

return DialogSystem
