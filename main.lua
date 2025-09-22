-- libraries

-- classes
local NPC = require 'classes.NPC'
local NPCDialog = require 'dialogs.TESTNpc'
local DialogSystem = require 'classes.DialogSystem'
local EventDispatcher = require 'classes.EventDispatcher'
local Game = require 'classes.Game'
local Map = require 'classes.Map'

function love.load()
    local npc = NPC.new(NPCDialog.npcName, NPCDialog.dialogs, {
        position = { x = 0, y = 0 }
    })

    Game.getInstance():addMap("test1", Map.new("maps/map2.lua", {npc}))
    Game.getInstance():loadMap("test1")
end

function love.update(dt)
    Game.getInstance():update(dt)
    DialogSystem.getInstance():update(dt)
end

function love.draw()
    Game.getInstance():draw()
    DialogSystem.getInstance():draw()
end

function love.keypressed(key, scancode, isrepeat)
    EventDispatcher.getInstance():dispatchEvent("keypressed", key, scancode, isrepeat)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
