local JSON = require('libraries.dkjson.dkjson')
local StateFile = require("classes.State")
local DialogFile = require("dialogs.start")

local GlobalState = {}
GlobalState.__index = GlobalState

local instance = nil
local fileName = "current_state.txt"

--- func desc
---@param filename string
local function loadJsonState(filename)
    local saveFile = io.open(filename, "r")

    if not saveFile then
        return nil
    end

    local stateFile = JSON.decode(saveFile:read("*a"))
    
    saveFile:close()
    return stateFile
end

GlobalState.getInstance = function()

    if not instance then
        local jsonTable = loadJsonState(fileName)
        local state = StateFile

        if jsonTable then
            state = jsonTable
        end

        instance = setmetatable({
            state = state,
            dialog = DialogFile
        }, GlobalState)
    end

    return instance
end

function GlobalState:saveSate()
    local saveFile = io.open(fileName, "w")
    local string = JSON.encode(self.state, { indent = true })
    saveFile:write(string)
    saveFile:close()
end

function GlobalState:getCurrentState()
    return self.state
end

return GlobalState
