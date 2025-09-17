local json = require('libraries.dkjson.dkjson')
local stateFile = require("dialogs.state")
local dialogFile = require("dialogs.start")

local GlobalState = {}
GlobalState.__index = GlobalState

local instance = nil

GlobalState.getInstance = function()
    if instance == nil then

        local saveFile = io.open("current_state.txt", "r")
        if saveFile ~= nil then
            stateFile = json.decode(saveFile:read("*a"))
            saveFile:close()
        end

        instance = setmetatable({
            state = stateFile,
            dialog = dialogFile
        }, GlobalState)
        
    end

    return instance
end

function GlobalState:saveSate()
    local saveFile = io.open("current_state.txt", "w")
    saveFile:write(
        json.encode(self.state, { indent = true })
    )
    saveFile:close()
end

function GlobalState:getCurrentState()
    return self.state
end

return GlobalState
