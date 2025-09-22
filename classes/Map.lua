local Sti = require 'libraries.sti'
local World = require 'classes.World'
local EventBus = require 'classes.EventBus'
local Player   = require 'classes.Player'

local Map = {}
Map.__index = Map

--- func desc
---@param tilemapPath string
---@param npcList table
function Map.new(tilemapPath, npcList)
    assert(tilemapPath, 'tilemapPath is required')

    local world = World.new()
    local map = Sti(tilemapPath, { 'box2d' })
    local love2dMap = love.physics.newWorld(0, 0, true)
    map:box2d_init(love2dMap)

    local obj = setmetatable({
        npcList = npcList,
        _world = world,
        _tileMap = map
    }, Map)

    EventBus.getInstance():addEventListener(obj)

    return obj
end

function Map:update(dt)
    self._world:update(dt)
end

function Map:getWorld()
    return self._world
end

--- func desc
---@param npcName string
---@param dialogNumber number
function Map:_showNpcDialog(npcName, dialogNumber)
    for _, npc in pairs(self.npcList) do
        if npc.name == npcName then
            npc:showDialog(dialogNumber)
        end
    end
end

function Map:_notifyBusEvent(event, data)
    if event:find("NextDialog") then
        self:_showNpcDialog(data.npcName, data.dialog)
    end
end

function Map:draw()
    self._tileMap.layers['ground']:draw()
    self._tileMap.layers['trees']:draw()
    Player.getInstance():draw()
    self._tileMap.layers['sky']:draw()
end

--- func desc
---@param event string
function Map:notify(event, ...)
    if (string.find(event, "bus-")) then
        self:_notifyBusEvent(event, ...)
        return
    end
end

return Map
