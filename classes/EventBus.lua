local EventBus = {}
EventBus.__index = EventBus

local instance = nil

function EventBus.getInstance()
    if (not instance) then
        instance = setmetatable({
            listeners = {},
            queue = {}
        }, EventBus)
    end

    return instance
end

function EventBus:addEventListener(listener)
    table.insert(self.listeners, listener)
end

function EventBus:removeEventListener(listener)
    table.remove(self.listeners, listener)
end

function EventBus:update(dt)    
    for _, event in ipairs(self.queue) do
        for _, listener in ipairs(self.listeners) do
            listener:notify(event.event, unpack(event.args)) 
        end
    end

    -- clear queue
    self.queue = {}
end

function EventBus:dispatchEvent(event, ...)
    assert(type(event) == "string", "event must be a string")
    table.insert(self.queue, { event = "bus-"..event, args = { ... } })
end

return EventBus
