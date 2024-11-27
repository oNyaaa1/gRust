GMRustTable = GMRustTable or {}
Crafting = Crafting or {}
player_manager.AddValidModel("RustGuy", "models/player/Spike/RustGuy.mdl")
list.Set("PlayerOptionsModel", "RustGuy", "models/player/Spike/RustGuy.mdl")
player_manager.AddValidHands("RustGuy", "models/player/spike/RustGuyArms.mdl", 0, "00000000")
Translation = function(txt) return GMRustTable[txt] or {} end
function BluePrint_Make(txt, tbl)
    local hasItem = false
    for k, v in pairs(GMRustTable) do
        if v.name == txt then hasItem = true end
    end

    if hasItem == true then return end
    GMRustTable[#GMRustTable + 1] = tbl
end

function BluePrint_Get(txt)
    local data = {}
    for k, v in pairs(GMRustTable) do
        if v.name == txt then data = v end
    end
    return data
end

local meta = FindMetaTable("Player")
function meta:GetEnoughVood()
    return self:GetNWFloat("wood", 0)
end

function meta:HasEnoughVood(amt)
    return self:GetNWFloat("wood", 0) >= amt
end
