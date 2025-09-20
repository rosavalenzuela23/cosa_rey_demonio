-- libraries

-- classes
local STI = require 'libraries.sti'
local World = require 'classes.World'
local Player = require 'classes.Player'
local Camera = require 'libraries.camera.camera'

function love.load()
    local world = World.getInstance()

    local rectangle = world:createRectangleCollider(400 - 50/2, 0, 50, 50)
    rectangle:setType("static")

    _G.map = STI("maps/map2.lua", { "box2d" })
    
    _G.camera = Camera()

    map:box2d_init(love.physics.newWorld(0, 0))

end

function love.update(dt)
    local player = Player.getInstance()
    player:update(dt)
    World.getInstance():update(dt)
 
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    camera:lookAt(player.body:getX(), player.body:getY())

    if camera.x < width / 2 then
        camera.x = width / 2
    end

    if camera.y < height / 2 then
        camera.y = height / 2
    end

    if camera.x > map.width * map.tilewidth - width / 2 then
        camera.x = map.width * map.tilewidth - width / 2
    end

    if camera.y > map.height * map.tileheight - height / 2 then
        camera.y = map.height * map.tileheight - height / 2
    end

end

function love.draw()
    
    camera:attach()
        map:drawLayer(map.layers["Tile Layer 1"])
        World.getInstance():draw()
        Player.getInstance():draw()
    camera:detach()

end

function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end
