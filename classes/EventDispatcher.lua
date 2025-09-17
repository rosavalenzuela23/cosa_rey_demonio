local EventDispatcher = {}
EventDispatcher.__index = EventDispatcher

local intance = nil

function EventDispatcher.getInstance()
    if intance == nil then
        intance = setmetatable({
            events = {

            }
        }, EventDispatcher)
    end

    return intance
end

function EventDispatcher:addEventListener(event, listener)
    if not self.events[event] then
        self.events[event] = {}
    end
    table.insert(self.events[event], listener)
end

--- func desc
---@param event string
function EventDispatcher:dispatchEvent(event, ...)
    if not self.events[event] then
        return
    end

    for _, listener in ipairs(self.events[event]) do
        listener:notify(event, ...)
    end

end

return EventDispatcher
