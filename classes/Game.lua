local EventBus = require("classes.EventBus")
local Player   = require("classes.Player")

local Game     = {}
Game.__index   = Game

local instance = nil

function Game.getInstance()
    if instance == nil then
        instance = {
            maps = {

            },
            currentMap = nil
        }

        EventBus.getInstance():addEventListener(instance)

        setmetatable(instance, Game)
    end
    return instance
end

--- func desc
---@param event string
---@param data table
function Game:_notifyEventBus(event, data)
    if (event:find("ChangeMap")) then
        self:loadMap(data.mapName)
    end
end

--- func desc
---@param event string
function Game:notify(event, ...)
    if (string.find(event, "bus-")) then
        self:_notifyEventBus(event, ...)
    end
end

function Game:getMap(mapName)
    return self.maps[mapName]
end

--- func desc
---@param mapName string
function Game:loadMap(mapName)
    self.currentMap = self:getMap(mapName)
    Player.getInstance():setWorld(self.currentMap:getWorld())
end

function Game:addMap(mapName, map)
    self.maps[mapName] = map
    return self
end

function Game:draw()
    if (self.currentMap) then
        self.currentMap:draw()
    end
end

function Game:update(dt)
    Player.getInstance():update(dt)

    if (self.currentMap ~= nil) then
        self.currentMap:update(dt)
    end
end

return Game
