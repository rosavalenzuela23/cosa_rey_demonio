local WF = require 'libraries.windfield.windfield'
local World = {}
World.__index = World

function World.new()
    return setmetatable({
        wfWorld = WF.newWorld(0, 0, true)
    }, World)
end

--- func desc
---@param collisionClassName any
---@param collisionClassOptions { ignores = {name: string} }
function World:addCollisionClass(collisionClassName, collisionClassOptions)
    self.wfWorld:addCollisionClass(collisionClassName, collisionClassOptions)
end

function World:createRectangleCollider(x, y, w, h)
    return self.wfWorld:newRectangleCollider(x, y, w, h)
end

function World:draw()
    self.wfWorld:draw()
end

function World:update(dt)
    self.wfWorld:update(dt)
end

return World
