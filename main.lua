-- libraries
local talkies = require("libraries.talkies.talkies")

-- classes
local GlobalState = require('classes.GlobalState')
local EventDispatcher = require('classes.EventDispatcher')
local ImageViewer = require('classes.ItemViewer')
local UIRender = require('classes.UIRender')

local draw_queue = {}

function love.load()
    local globalState = GlobalState.getInstance()
    local pistol = ImageViewer.new("sprites/prueba.png", "Pistol", "A handgun");

    table.insert(draw_queue, pistol)

    globalState:saveSate()
end

function love.update(dt)
    talkies.update(dt)
end

function love.draw()
    UIRender.getInstance():draw()
    talkies.draw()
end

function love.keypressed(key, scancode, isrepeat)
    local eventDispatcher = EventDispatcher.getInstance()
    eventDispatcher:dispatchEvent("keypressed", key, scancode, isrepeat)
end

function love.keyreleased(key)

end
