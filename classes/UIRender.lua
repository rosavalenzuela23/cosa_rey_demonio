local UIRender = {}
UIRender.__index = UIRender

local instance = nil

UIRender.getInstance = function()

    if not instance then
        instance = setmetatable({
            layers = {
                UI = {},
                TOP = {},
                PLAYER = {},
                BOTTOM = {},
                BACKGROUND = {}
            }
        }, UIRender)
    end

    return instance
end

function UIRender:addUI(uiElement)
    table.insert(self.layers.UI, uiElement)
end

function UIRender:removeUI(uiElement)
    table.remove(self.layers.UI, uiElement)
end

function UIRender:draw()
    for _, layer in ipairs(self.layers) do
        for _, uiElement in ipairs(layer) do
            uiElement:draw()
        end
    end
end

return UIRender