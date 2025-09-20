-- libraries

-- classes
local World = require 'classes.World'
local Player = require 'classes.Player'

function love.load()
    local world = World.getInstance()

    local rectangle = world:createRectangleCollider(400 - 50/2, 0, 50, 50)
    rectangle:setType("static")

end

function love.update(dt)
    Player.getInstance():update(dt)
    World.getInstance():update(dt)
end

function love.draw()
    World.getInstance():draw()
    Player.getInstance():draw()
end

function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
