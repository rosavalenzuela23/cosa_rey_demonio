local GlobalState     = require("classes.GlobalState")
local EventBus        = require("classes.EventBus")
local EventDispatcher = require("classes.EventDispatcher")

local Player          = {}
Player.__index        = Player

local instance        = nil

local PlayerState     = {
    STANDING = "standing",
    WALKING  = "walking",
    RUNNING  = "running",
    TALKING  = "talking"
}

Player.getInstance    = function()
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
                run = globalState.state.config.keyboard.run,
                interact = globalState.state.config.keyboard.interact
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

        EventBus.getInstance():addEventListener(instance)
        EventDispatcher.getInstance():addEventListener("keypressed", instance)
    end

    return instance
end

function Player:setWorld(world)
    local bodyCollider = world:createRectangleCollider(0, 0, self.size.width, self.size.height)
    bodyCollider:setFixedRotation(true)
    self.body = bodyCollider

    return self
end

function Player:getPosition()
    return self.body:getPosition()
end

function Player:isInRadius(radius, x, y)
    local playerX, playerY = self:getPosition()

    local isInX = x > playerX - radius and x < playerX + radius
    local isInY = y > playerY - radius and y < playerY + radius

    return isInX and isInY
end

function Player:_getCurrentAnimation()
    
    if self.state == PlayerState.TALKING then
        return self.animations.standing
    end

    return self.animations[self.state]
end

function Player:updateAnimation(dt)
    local animation = self:_getCurrentAnimation()
    if animation.speed == nil then
        return
    end

    animation.currentTime = animation.currentTime + dt

    if (animation.currentTime >= animation.speed) then
        animation.currentTime = 0
        animation.currentFrame = animation.currentFrame + 1

        if (animation.currentFrame > #animation.order) then
            animation.currentFrame = 1
        end
    end
end

function Player:_keyboardPressed(key, scancode, isrepeat)
    if self.state == PlayerState.TALKING then
        return
    end

    if key == self.controls.interact.primary or key == self.controls.interact.secondary then
        EventBus.getInstance():dispatchEvent("PlayerAction")
    end
end

function Player:notify(event, ...)
    if event == 'keypressed' then
        self:_keyboardPressed(...)
        return
    end

    if event == "bus-DialogStarted" then
        self.state = PlayerState.TALKING
        return
    end

    if event == "bus-DialogEnded" then
        self.state = PlayerState.STANDING
        return
    end
end

function Player:update(dt)
    if not self.body or self.state == PlayerState.TALKING then
        return
    end
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

    local right = love.keyboard.isDown(self.controls.right.primary) or love.keyboard.isDown(self.controls.right.secondary)
    local left = love.keyboard.isDown(self.controls.left.primary) or love.keyboard.isDown(self.controls.left.secondary)
    local down = love.keyboard.isDown(self.controls.down.primary) or love.keyboard.isDown(self.controls.down.secondary)
    local up = love.keyboard.isDown(self.controls.up.primary) or love.keyboard.isDown(self.controls.up.secondary)
    local running = love.keyboard.isDown(self.controls.run.primary) or love.keyboard.isDown(self.controls.run.secondary)

    if right then
        vector_x = vector_x + 1
    end
    if left then
        vector_x = vector_x - 1
    end
    if down then
        vector_y = vector_y + 1
    end
    if up then
        vector_y = vector_y - 1
    end

    if running then
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

    local animation = self:_getCurrentAnimation()

    local x, y = self.body:getPosition()
    local image = animation.order[animation.currentFrame]
    local playerWidth = self.size.width
    local playerHeight = self.size.height
    love.graphics.draw(image, x, y, nil, nil, nil, playerWidth / 2, playerHeight / 2)
end

return Player
