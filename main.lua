-- classes
local DialogSystem = require 'classes.DialogSystem'
local EventBus        = require 'classes.EventBus'
local EventDispatcher = require 'classes.EventDispatcher'
local Game = require 'classes.Game'

function love.load()
    
    _G.GameDefault = {
        width = 800,
        height = 600,
        DEBUG = true
    }

    Game.getInstance():addMap("test1", require 'maps.map_objects.ForestMap')
    Game.getInstance():loadMap("test1")
end

function love.update(dt)
    Game.getInstance():update(dt)
    EventBus.getInstance():update(dt)
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
    if key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    if key == "escape" then
        love.event.quit()
    end
end
