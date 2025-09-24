local Map = require "classes.Map"
local NPC = require "classes.NPC"
local TESTDialogs = require "dialogs.TESTNpc"
local RositaValenzuelaDialogs = require "dialogs.RosaNPC"

return Map.new("maps/map_objects/tiles.lua", {
    NPC.new(TESTDialogs.npcName, TESTDialogs.dialogs, {
        position = { x = 256, y = 64 },
        dialogRadiusThreshold = 60,
        sprite_location = "assets/sprites/npc_sprites/extra_1/extra1_standing.png"
    }),
    NPC.new(RositaValenzuelaDialogs.npcName, RositaValenzuelaDialogs.dialogs, {
        position = { x = 654, y = 432 },
        dialogRadiusThreshold = 60,
        sprite_location = "assets/sprites/npc_sprites/rosa_sprites/rosa_standing.png"
    })
});
