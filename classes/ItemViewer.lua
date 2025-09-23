local EventDispatcher = require('classes.EventDispatcher')

local ItemViewer = {}
ItemViewer.__index = ItemViewer

local _, _, w, h = love.window.getSafeArea()

--- Creates a new ItemViewer
---@param sprite string
---@param title string
---@param description string
ItemViewer.new = function(sprite, title, description)
    local imageObject = love.graphics.newImage(sprite)

    return setmetatable({
        sprite = sprite,
        image = imageObject,
        title = title,
        description = description,
        backgroundColor = { 1, 1, 1, 1 },
        textColor = { 1, 1, 1, 1 },
        x = (w / 2) - (imageObject:getWidth() / 2),
        y = h * 0.05,
    }, ItemViewer)

end

--- func desc
---@param color {r: number, g: number, b: number, a: number}
---@return ItemViewer self
function ItemViewer:setTextColor(color)
    assert(type(color) == "table", "Color must be a table")

    self.textColor = color
    return self
end

--- func desc
---@param color {r: number, g: number, b: number, a: number}
---@return ItemViewer self
function ItemViewer:setBackgroundColor(color)
    assert(type(color) == "table", "Color must be a table")

    self.backgroundColor = color
    return self
end

function ItemViewer:notify(event, ...)
    if event == "keypressed" then
        self:keypressed(...)
    end
end

function ItemViewer:keypressed(key, scancode, isrepeat)
    return
end

function ItemViewer:hide()
    return
end

function ItemViewer:show()
    local eventDispatcher = EventDispatcher.getInstance()
    eventDispatcher:addEventListener("keypressed", self)
end

function ItemViewer:draw()
    love.graphics.draw(self.image, self.x, self.y, 0)

    if not self.title then
        return
    end

    -- Donde termina la imagen y le sumamos un 5% del tamaño de la pantalla
    -- Para poder mostrar el texto
    local text_y = self.y + self.image:getHeight() + h * 0.05
    local pixelOffset = 10 -- px
    local innerPadding = 10 -- px

    love.graphics.push()

    -- Dibujar un cuadrado como fondo para el texto
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle(
        "fill",
        self.x - innerPadding,
        text_y - innerPadding,
        self.image:getWidth() + innerPadding * 2,
        h - text_y
    )

    love.graphics.setColor(self.textColor)
    -- Dibujar el texto
    love.graphics.print(self.title, self.x + pixelOffset, text_y)
    love.graphics.print(self.description, self.x + pixelOffset, text_y + pixelOffset * 2)

    love.graphics.pop()
end

return ItemViewer