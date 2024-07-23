AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ui/threegrid.lua")
AddCSLuaFile("sharity.lua")
AddCSLuaFile("cl_inventory.lua")
AddCSLuaFile("escmenu.lua")
AddCSLuaFile("circles.lua")
AddCSLuaFile("radialmenu.lua")
include("shared.lua")
include("sharity.lua")
include("sv_inventory.lua")
local rocks = include("rust_vecs_rocks.lua")
util.AddNetworkString("gRust_ServerModel_new")
util.AddNetworkString("gRust_Queue_Crafting")
util.AddNetworkString("gRust_Queue_Crafting_Timer")
util.AddNetworkString("inv_snd")
util.AddNetworkString("inv_give")
util.AddNetworkString("WriteInv")
util.AddNetworkString("inventory_Test")
util.AddNetworkString("hands_builder_map")
util.AddNetworkString("Sent_Vood")
util.AddNetworkString("ShowMarker")
util.AddNetworkString("BigBoxLott")
util.AddNetworkString("gRust_GetItmz")
util.AddNetworkString("CheckTheFiles")
net.Receive("CheckTheFiles", function(l, ply)
    local str = net.ReadString()
    local tbl = net.ReadTable()
    if str == "FileCheck" then
        for k, v in pairs(tbl) do
            local sub = string.gsub(v, "@", "")
            local f = file.Exists(sub, "GAME")
            if f == false then print("found: ", f, k, sub) end
        end
    end

    if str == "BanMe" then
        ply:Ban(0, false)
        ply:Kick("Cheating")
        RunConsoleCommand("writeid")
    end
end)

hook.Add("PlayerNoClip", "isInNoClip", function(ply, desiredNoClipState) return ply:IsAdmin() end)
CreateConVar("grust_debug", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
--ply:ShowInventory()
hook.Add("Think", "DSRust", function()
    for k, v in pairs(ents.GetAll()) do
        v:DrawShadow(false)
    end
end)

local NodeTable = {}
local Time = 0
hook.Add("PlayerSpawn", "SetUpModel", function(ply)
    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 10)) do
        if v:GetClass() == "sent_rocks" then ply:SetPos(v:GetPos() + Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMins().z + 12)) end
    end

    ply:DropToFloor()
    ply:SetModel("models/player/darky_m/rust/hazmat.mdl")
end)

hook.Add("PlayerInitialSpawn", "changemap", function(ply)
    print(game.GetMap())
    print(navmesh.IsLoaded())
    if game.GetMap() ~= "rust_highland_v1_3a" then --game.ConsoleCommand( "changelevel rust_highland_v1_3a\n" )
    end
end)

local function BackwardsEnums(enumname)
    local backenums = {}
    for k, v in pairs(_G) do
        if isstring(k) and string.find(k, "^" .. enumname) then backenums[v] = k end
    end
    return backenums
end

hook.Add("EntityTakeDamage", "EntityDamageExample", function(v, dmginfo)
    local MAT = BackwardsEnums("MAT_")
    if MAT[v:GetMaterialType()] == "MAT_WOOD" then
        local ply = dmginfo:GetAttacker()
        local wep = ply:GetActiveWeapon()
        local ent = ply:GetEyeTrace().Entity
        if ent.StackWood == nil then ent.StackWood = 0 end
        if ent.StackWood >= 100 and ent.StackWood >= 100 then timer.Simple(60, function() ent.StackWood = 0 end) end
        if IsValid(ply) and IsValid(wep) and IsValid(ent) and string.find(wep:GetClass(), "hatchet") or string.find(wep:GetClass(), "rock") and ent.StackWood <= 100 then
            --local str, str2 = string.find(ply:GetEyeTrace().Entity:GetClass(), "sent_"), string.find(ply:GetEyeTrace().Entity:GetClass(), "rust_")
            --if str or str2 then return end
            if wep:GetClass() == "metal_hatchet" then
                ent.StackWood = ent.StackWood + mah.random(15, 20)
            elseif wep:GetClass() == "tfa_rustalpha_stone_hatchet" then
                ent.StackWood = ent.StackWood + math.random(10, 15)
            else
                ent.StackWood = ent.StackWood + math.random(1, 5)
            end

            print(ent.StackWood)
            ply.Counter_Vood = math.random(5, 9)
            ply:SetEnoughVood(ply.Counter_Vood)
            net.Start("Sent_Vood")
            net.WriteBool(true)
            net.WriteString("Wood")
            net.WriteFloat(ply:GetEnoughVood())
            net.WriteFloat(ent.StackWood)
            net.Send(ply)
            ply.ResetTime = 0
            ply.NotHitting = true
            timer.Create("SoftWood", 10, 0, function()
                if not IsValid(ply) then return end
                net.Start("Sent_Vood")
                net.WriteBool(false)
                net.WriteString("Wood")
                net.WriteFloat(ply:GetEnoughVood())
                net.WriteFloat(ent.StackWood)
                net.Send(ply)
                timer.Remove("SoftWood")
            end)

            AddToInventory(ply, {
                Name = "Wood",
                WepClass = "none",
                Mdl = "models/galaxy/rust/woodpile1.mdl",
                Ammo_New = "none",
                Amount = ply:GetEnoughVood(),
            }, true)
        end
    end
end)

local Tbl = {}
Tbl[1] = {"Favorite", "icons/favorite_inactive.png"}
Tbl[2] = {"Construction", "icons/construction.png"}
Tbl[3] = {"Items", "icons/extinguish.png"}
Tbl[4] = {"Resources", "icons/servers.png"}
Tbl[5] = {"Clothing", "icons/servers.png"}
Tbl[6] = {"Tools", "icons/tools.png"}
Tbl[7] = {"Medical", "icons/medical.png"}
Tbl[8] = {"Weapons", "icons/weapon.png"}
Tbl[9] = {"Ammo", "icons/ammo.png"}
Tbl[11] = {"Fun", "icons/servers.png"}
Tbl[12] = {"Other", "icons/electric.png"}
net.Receive("gRust_Queue_Crafting", function(len, ply)
    local rs = net.ReadString()
    local timerz = net.ReadFloat()
    local trans = BluePrint_Get(rs)
    if GetConVar("grust_debug"):GetFloat() == 1 then
        AddToInventory(ply, {
            Name = trans.name,
            WepClass = trans.Class,
            Mdl = trans.Mdl,
            Ammo_New = trans.ammo,
            Amount = 1,
        })
        return
    end

    --PrintTable(trans)                                          .amt)
    if trans.need ~= nil and not ply:HasEnoughVood(trans.need.amt or 0) then return end
    if trans.need2 ~= nil and not ply:HasEnoughStone(trans.need2.amt or 0) then return end
    if trans.need ~= nil then ply:DeductVood(trans.need.amt or 0) end
    if trans.need2 ~= nil then ply:DeductStone(trans.need2.amt or 0) end
    net.Start("gRust_Queue_Crafting_Timer")
    net.WriteFloat(trans.timers)
    net.WriteString(trans.Mdl)
    net.WriteString(trans.name)
    net.WriteFloat(trans.timers)
    net.WriteFloat(timerz)
    net.Send(ply)
    -- timer.Simple(trans.timers, function()
    AddToInventory(ply, {
        Name = trans.name,
        WepClass = trans.Class,
        Mdl = trans.Mdl,
        Ammo_New = trans.ammo,
        Amount = 1,
    })
    -- end)
end)

function GM:GetFallDamage()
    return math.random(1, 50)
end

--sv_tfa_attachments_enabled 1; sv_tfa_cmenu 1;
hook.Add("InitPostEntity", "DisableMods", function()
    if game.GetMap() == "rust_highland_v1_3a" then
        for k, v in pairs(rocks) do
            local ent = ents.Create("sent_rocks")
            ent:SetPos(v)
            ent:Spawn()
            ent:Activate()
        end
    end

    print("Disabled attachments")
    timer.Simple(3, function()
        print("Disabled attchments")
        RunConsoleCommand("sv_tfa_attachments_enabled", "0")
        RunConsoleCommand("sv_tfa_cmenu", "0")
    end)
end)

for k, v in pairs(file.Find("gamemodes/grust/gamemode/ui/" .. "*", "GAME")) do
    print("Adding " .. v)
    AddCSLuaFile("ui/" .. v)
end

hook.Add("EntityTakeDamage", "gRustEntitytDmg", function(target, dmginfo)
    if target:IsPlayer() and target:LastHitGroup() == HITGROUP_HEAD then
        local attk = dmginfo:GetAttacker()
        attk:EmitSound("combat/headshot.wav")
        net.Start("ShowMarker")
        net.WriteEntity(target)
        net.Send(attk)
    end
end)