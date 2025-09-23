local CameraLibrary = require 'libraries.camera.camera'

local Camera = {}
Camera.__index = Camera

function Camera.new()
    return setmetatable({
        _camera = CameraLibrary()
    }, Camera)
end

function Camera:clamp(finalWidth, finalHeight)
    if self._camera.x < GameDefault.width / 2 then
        self._camera.x = GameDefault.width / 2
    end

    if self._camera.y < GameDefault.height / 2 then
        self._camera.y = GameDefault.height / 2
    end

    if self._camera.x > (finalWidth - GameDefault.width / 2) then
        self._camera.x = finalWidth - GameDefault.width / 2
    end

    if self._camera.y > (finalHeight - GameDefault.height / 2) then
        self._camera.y = finalHeight - GameDefault.height / 2
    end
end

function Camera:getPosition()
    return self._camera:position()
end

function Camera:setX(x)
    self._camera.x = x
end

function Camera:setY(y)
    self._camera.y = y
end

function Camera:lookAt(x, y, limit)
    self._camera:lookAt(x, y)
    if limit then
        if self._camera.x < 0 then
            self._camera.x = limit.x
        end
    end
end

function Camera:englobe(functionToEnglobe)
    self._camera:attach()
    functionToEnglobe()
    self._camera:detach()
end

return Camera
