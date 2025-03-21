DeriveGamemode("base")
GM.Name = "Rust"
local meta = FindMetaTable("Player")
function meta:DeductVood(amt)
    self:RemoveInventoryWood(amt)
end

if CLIENT then
    local debugz = 0
    hook.Add("HUDPaint", "draw", function()
        if debugz == 0 then return end
        for k, v in pairs(ents.FindByClass("npc_vj_felt_chicken")) do
            local pos = v:GetPos():ToScreen()
            draw.RoundedBox(0, pos.x, pos.y, 20, 20, Color(255, 0, 0))
        end
    end)
end