-- libraries
local talkies = require("libraries.talkies.talkies")

-- classes
local GlobalState = require('classes.GlobalState')
local EventDispatcher = require('classes.EventDispatcher')
local ImageViewer = require('classes.ItemViewer')

local draw_queue = {}

function love.load()
    GlobalState.getInstance()
    local pistol = ImageViewer.new("sprites/prueba.png", "Pistol", "A handgun");
    pistol:show()
    table.insert(draw_queue, pistol)
end

function love.update(dt)
    talkies.update(dt)
end

function love.draw()
    talkies.draw()

    for _, item in ipairs(draw_queue) do
        item:draw()
    end

end

function love.keypressed(key, scancode, isrepeat)
    local eventDispatcher = EventDispatcher.getInstance()
    eventDispatcher:dispatchEvent("keypressed", key, scancode, isrepeat)
end

function love.keyreleased(key)

end