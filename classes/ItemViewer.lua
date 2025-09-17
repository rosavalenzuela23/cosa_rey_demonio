local EventDispatcher = require('classes.EventDispatcher')

local ItemViewer = {}
ItemViewer.__index = ItemViewer

local _, _, w, h = love.window.getSafeArea()

--- Creates a new ItemViewer
---@param sprite string
---@param title string
---@param description string
ItemViewer.new = function (sprite, title, description)
    local imageObject = love.graphics.newImage(sprite)

    return setmetatable({
        sprite = sprite,
        image = imageObject,
        title = title,
        description = description,
        x = (w/2) - (imageObject:getWidth()/2),
        y = h * 0.05,
    }, ItemViewer)

end

function ItemViewer:notify(event, ...)
    if event == "keypressed" then
        self:keypressed(...)
    end
end

function ItemViewer:keypressed(key, scancode, isrepeat)
    if key == "escape" then
        self:hide()
    end
end

function ItemViewer:hide()
    print("I'm hidding!")
end

function ItemViewer:show()
    local eventDispatcher = EventDispatcher.getInstance()
    eventDispatcher:addEventListener("keypressed", self)
end

function ItemViewer:draw()
    love.graphics.draw(self.image, self.x, self.y, 0)

    if self.title == nil then
        return
    end

    -- Donde termina la imagen y le sumamos un 5% del tamaño de la pantalla
    -- Para poder mostrar el texto
    local text_y = self.y + self.image:getHeight() + h * 0.05

    love.graphics.print(self.title, self.x + 10, text_y)
    love.graphics.print(self.description, self.x + 10, text_y + 20)

end

return ItemViewer