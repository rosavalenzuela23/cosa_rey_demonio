local World = require("classes.World")
local GlobalState = require("classes.GlobalState")

local Player = {}
Player.__index = Player

local instance = nil
local worldInstance = World.getInstance()

local PlayerState = {
    STANDING = 0,
    WALKING = 1,
}

Player.getInstance = function()
    local globalState = GlobalState.getInstance()

    if not instance then
        local bodyCollider = worldInstance:createRectangleCollider(0, 0, 100, 100)
        bodyCollider:setFixedRotation(true)

        instance = setmetatable({
            body = bodyCollider,
            controls = {
                up = globalState.state.config.keyboard.up,
                down = globalState.state.config.keyboard.down,
                left = globalState.state.config.keyboard.left,
                right = globalState.state.config.keyboard.right,
                run = globalState.state.config.keyboard.run
            },
            sprites = {
                standing = 'sprites/player_sprites/standing.png',
                walk_1 = 'sprites/player_sprites/walk_1.png',
                walk_2 = 'sprites/player_sprites/walk_2.png'
            },
            animations = {
                walking = {
                    speed = 400, --ms
                    order = {
                        love.graphics.newImage('sprites/player_sprites/walk_1.png'),
                        love.graphics.newImage('sprites/player_sprites/walk_2.png')
                    }
                }
            },
            state = PlayerState.STANDING,
            movementSpeed = 200, -- Pixels per second
            runningSpeed = 300
        }, Player)
    end

    return instance
end

function Player:update(dt)
    self:move(dt)
end

--- func desc
---@param vector {x: number, y: number}
---@return {x: number, y: number}
local normalizeVector2D = function(vector)
    assert(#vector ~= 2, "vector must be a 2D vector")
    assert(type(vector) == "table", "vector must be a table")

    if (vector.x == 0 or vector.y == 0) then
        return vector
    end

    local hypotenuse = math.sqrt(vector.x ^ 2 + vector.y ^ 2)
    -- Creo que si si algun vector es 0
    -- La funcion va a tronar feito
    return {
        x = vector.x / hypotenuse,
        y = vector.y / hypotenuse
    }
    
end

function Player:move(dt)
    local vector_x = 0
    local vector_y = 0
    local finalSpeed = self.movementSpeed

    if love.keyboard.isDown(self.controls.right) then
        vector_x = vector_x + 1
    end
    if love.keyboard.isDown(self.controls.left) then
        vector_x = vector_x - 1
    end
    if love.keyboard.isDown(self.controls.down) then
        vector_y = vector_y + 1
    end
    if love.keyboard.isDown(self.controls.up) then
        vector_y = vector_y - 1
    end

    if love.keyboard.isDown(self.controls.run) then
        finalSpeed = self.runningSpeed
    end

    local finalVector = normalizeVector2D({ x = vector_x, y = vector_y })

    self.body:setLinearVelocity(finalVector.x * finalSpeed, finalVector.y * finalSpeed)

    if (vector_x == 0 and vector_y == 0) then
        self.state = PlayerState.STANDING
    else
        self.state = PlayerState.WALKING
    end
end

function Player:draw()
    local x, y = self.body:getPosition()
    love.graphics.rectangle("fill", x - 50, y - 50, 100, 100)
end

return Player
