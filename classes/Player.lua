local World = require("classes.World")
local GlobalState = require("classes.GlobalState")

local Player = {}
Player.__index = Player

local instance = nil
local worldInstance = World.new()

local PlayerState = {
    STANDING = "standing",
    WALKING = "walking",
    RUNNING = "running"
}

Player.getInstance = function()
    local globalState = GlobalState.getInstance()

    if not instance then
        local playerSize = {
            width = 32,
            height = 64
        }

        instance = setmetatable({
            body = nil,
            size = playerSize,
            controls = {
                up = globalState.state.config.keyboard.up,
                down = globalState.state.config.keyboard.down,
                left = globalState.state.config.keyboard.left,
                right = globalState.state.config.keyboard.right,
                run = globalState.state.config.keyboard.run
            },
            sprites = {
                actual_sprite = nil,
            },
            animations = {
                walking = {
                    speed = 0.4, --ms
                    order = {
                        love.graphics.newImage('assets/sprites/player_sprites/walk_1.png'),
                        love.graphics.newImage('assets/sprites/player_sprites/walk_2.png')
                    },
                    currentFrame = 1,
                    currentTime = 0
                },
                running = {
                    speed = 0.2, --ms
                    order = {
                        love.graphics.newImage('assets/sprites/player_sprites/walk_1.png'),
                        love.graphics.newImage('assets/sprites/player_sprites/walk_2.png')
                    },
                    currentFrame = 1,
                    currentTime = 0
                },
                standing = {
                    order = {
                        love.graphics.newImage('assets/sprites/player_sprites/standing.png')
                    },
                    currentFrame = 1,
                    currentTime = 0
                }
            },
            state = PlayerState.STANDING,
            movementSpeed = 200, -- Pixels per second
            runningSpeed = 300
        }, Player)
    end

    return instance
end

function Player:setWorld(world)

    local bodyCollider = world:createRectangleCollider(0, 0, self.size.width, self.size.height)
    bodyCollider:setFixedRotation(true)
    self.body = bodyCollider

    return self
end

function Player:updateAnimation(dt)
    if self.animations[self.state].speed == nil then
        return
    end

    self.animations[self.state].currentTime = self.animations[self.state].currentTime + dt

    if (self.animations[self.state].currentTime >= self.animations[self.state].speed) then
        self.animations[self.state].currentTime = 0
        self.animations[self.state].currentFrame = self.animations[self.state].currentFrame + 1

        if (self.animations[self.state].currentFrame > #self.animations[self.state].order) then
            self.animations[self.state].currentFrame = 1
        end
    end
end

function Player:update(dt)
    self:move(dt)
    self:updateAnimation(dt)
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
    if not self.body then
        return
    end

    local vector_x = 0
    local vector_y = 0
    local finalSpeed = self.movementSpeed
    self.state = PlayerState.STANDING

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

    if (vector_x ~= 0 or vector_y ~= 0) then
        self.state = PlayerState.WALKING
        if love.keyboard.isDown(self.controls.run) then
            self.state = PlayerState.RUNNING
        end
    end

    local finalVector = normalizeVector2D({ x = vector_x, y = vector_y })

    self.body:setLinearVelocity(finalVector.x * finalSpeed, finalVector.y * finalSpeed)
end

function Player:draw()
    if not self.body then
        return
    end

    local x, y = self.body:getPosition()
    local image = self.animations[self.state].order[self.animations[self.state].currentFrame]
    local playerWidth = self.size.width
    local playerHeight = self.size.height
    love.graphics.draw(image, x, y, nil, nil, nil, playerWidth / 2, playerHeight / 2)
end

return Player
