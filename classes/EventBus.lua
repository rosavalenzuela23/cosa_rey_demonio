local EventBus = {}
EventBus.__index = EventBus

local instance = nil

function EventBus.getInstance()
    if (not instance) then
        instance = setmetatable({
            listeners = {}
        }, EventBus)
    end

    return instance
end

function EventBus:addEventListener(listener)
    table.insert(self.listeners, listener)
end

function EventBus:dispatchEvent(event, ...)
    assert(type(event) == "string", "event must be a string")

    for _, listener in ipairs(self.listeners) do
        listener:notify("bus-" .. event, ...)
    end
end

return EventBus
