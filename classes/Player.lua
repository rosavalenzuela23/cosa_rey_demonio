local GlobalState = require("classes.GlobalState")

local Player = {}
Player.__index = Player

local instance = nil

local PlayerState = {
    STANDING = 0,
    WALKING = 1,
}

Player.getInstance = function()
    local globalState = GlobalState.getInstance()

    if not instance then
        instance = setmetatable({
            position = {
                x = 0,
                y = 0,
            },
            controls = {
                up = globalState.config.keyboard.up,
                down = globalState.config.keyboard.down,
                left = globalState.config.keyboard.left,
                right = globalState.config.keyboard.right
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
            movementSpeed = 100 -- Pixels per second
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
    assert(#vector == 2, "vector must be a 2D vector")
    assert(type(vector) == "table", "vector must be a table")

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

    local finalVector = normalizeVector2D({x = vector_x, y = vector_y})

    player.position.x  = player.position.x + finalVector * player.movementSpeed * dt
    player.position.y  = player.position.y + finalVector * player.movementSpeed * dt

    if (vector_x == 0 and vector_y == 0) then
        self.state = PlayerState.STANDING
    else
        self.state = PlayerState.WALKING
    end
    
end

function Player:draw()
    
end

return Player
