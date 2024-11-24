util.AddNetworkString("SendInventory")
util.AddNetworkString("ForgiveMeInventory")
util.AddNetworkString("Craft_BP")
local MaxInventory = 42
function IsInventoryFull(ply)
    local yup = 0
    for k, v in pairs(ply.inv) do
        yup = yup + 1
    end
    return yup >= MaxInventory
end

local meta = FindMetaTable("Player")
function meta:FirstCreateInv(b_Alive)
    b_Alive = b_Alive or ""
    if not file.IsDir("ginv", "DATA") then file.CreateDir("ginv") end
    if not file.Exists("ginv/inventory_" .. self:SteamID64() .. ".txt", "DATA") then file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON({})) end
    if b_Alive == "b_dead" then file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON({})) end
    local inv = util.JSONToTable(file.Read("ginv/inventory_" .. self:SteamID64() .. ".txt", "DATA"))
    net.Start("SendInventory")
    net.WriteTable(inv)
    net.Send(self)
    return inv
end

function GetAmmoForCurrentWeapon(ply)
    if not IsValid(ply) then return -1 end
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return -1 end
    return ply:GetAmmoCount(wep:GetPrimaryAmmoType())
end

function meta:GetInventory()
    local inv = NULL
    if file.Exists("ginv/inventory_" .. self:SteamID64() .. ".txt", "DATA") then inv = util.JSONToTable(file.Read("ginv/inventory_" .. self:SteamID64() .. ".txt", "DATA")) end
    return inv
end

function meta:GetItem(item)
    local inv = self:GetInventory()
    if inv == NULL then return 0 end
    for k, v in pairs(inv) do
        if v.Name == item then return v end
    end
end

net.Receive("Craft_BP", function(l, ply)
    local str = net.ReadString()
    local plymeta = ply:GetItem("Wood")
    ply.bp = BluePrint_Get(str)
    if type(plymeta) == "table" then
        for k, v in pairs(ply.bp.need) do
            if plymeta.Amount >= v.amt then
                if v.txt == "Stone" then ply:RemoveInventoryRocks(v.amt) end
                if v.txt == "Wood" then ply:RemoveInventoryWood(v.amt) end
            end
        end

        timer.Create("Create" .. tostring(str), ply.bp.timers, 0, function()
            ply:Give(ply.bp.Class)
            timer.Remove("Create" .. tostring(str))
        end)
    end
end)

function meta:AddToInventory(item)
    local inv = self.inv or {}
    local tbl = {}
    local amount = 0
    local altered = false
    local ammo1 = GetAmmoForCurrentWeapon(self)
    for k, v in pairs(inv) do
        if v.Class == item:GetClass() then
            amount = v.Amount + math.random(3, 5)
            tbl.Name = item.Name
            tbl.Class = item:GetClass() or ""
            tbl.WepClass = item:GetClass() or ""
            tbl.Mdl = item:GetModel() or ""
            tbl.Ammo_New = ammo1 or 0
            tbl.Amount = amount or 0
            inv[k] = tbl
            altered = true
        end
    end

    if altered == false then
        amount = math.random(3, 5)
        tbl.Name = item.Name
        tbl.Class = item:GetClass() or ""
        tbl.WepClass = item:GetClass() or ""
        tbl.Mdl = item:GetModel() or ""
        tbl.Ammo_New = ammo1 or 0
        tbl.Amount = amount or 0
        inv[#inv + 1] = tbl
    end

    self.inv = inv
    --net.Start("SendInventory")
    --net.WriteTable(inv)
    --net.Send(self)
    file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON(inv))
end

function meta:AddToInventoryWood(amt)
    local inv = self.inv or {}
    local tbl = {}
    local amount = 0
    local altered = false
    local ammo1 = GetAmmoForCurrentWeapon(self)
    for k, v in pairs(inv) do
        if v.Class == "rust_wood" then
            amount = v.Amount + amt
            tbl.Name = "Wood"
            tbl.Class = "rust_wood" or ""
            tbl.WepClass = "rust_wood" or ""
            tbl.Mdl = "models/props_debris/wood_board04a.mdl" or ""
            tbl.Ammo_New = ammo1 or 0
            tbl.Amount = amount or 0
            self:SetNWFloat("wood", amount)
            inv[k] = tbl
            altered = true
        end
    end

    if altered == false then
        amount = amt
        tbl.Name = "Wood"
        tbl.Class = "rust_wood" or ""
        tbl.WepClass = "rust_wood" or ""
        tbl.Mdl = "models/props_debris/wood_board04a.mdl" or ""
        tbl.Ammo_New = ammo1 or 0
        tbl.Amount = amount or 0
        self:SetNWFloat("wood", amount)
        inv[#inv + 1] = tbl
    end

    self.inv = inv
    --net.Start("SendInventory")
    --/net.WriteTable(inv)
    -- n/et.Send(self)
    file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON(inv))
end

function meta:RemoveInventoryWood(amt)
    local inv = self.inv or {}
    local tbl = {}
    local amount = 0
    local ammo1 = GetAmmoForCurrentWeapon(self)
    for k, v in pairs(inv) do
        if v.Class == "rust_wood" then
            amount = v.Amount - amt
            tbl.Name = "Wood"
            tbl.Class = "rust_wood" or ""
            tbl.WepClass = "rust_wood" or ""
            tbl.Mdl = "models/props_debris/wood_board04a.mdl" or ""
            tbl.Ammo_New = ammo1 or 0
            tbl.Amount = amount or 0
            self:SetNWFloat("wood", amount)
            inv[k] = tbl
        end
    end

    self.inv = inv
    --net.Start("SendInventory")
    --/net.WriteTable(inv)
    -- n/et.Send(self)
    file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON(inv))
end

local function WhatRock(ply, inv, skins)
    local tbl = {}
    local amount = math.random(25, 30)
    local ammo1 = GetAmmoForCurrentWeapon(ply)
    -- 1 metal, 2 sulfur, 3 Rock
    local gRust_Rocks = ""
    if skins == 1 then
        gRust_Rocks = "Metal"
    elseif skins == 2 then
        gRust_Rocks = "Sulfur"
    elseif skins == 3 then
        gRust_Rocks = "Rock"
    end

    tbl.Name = gRust_Rocks
    tbl.Class = "sent_rocks" or ""
    tbl.WepClass = "sent_rocks" or ""
    tbl.Mdl = "models/environment/ores/ore_node_stage1.mdl" or ""
    tbl.Ammo_New = ammo1 or 0
    tbl.Amount = amount or 0
    tbl.Skins = skins
    inv[#inv + 1] = tbl
    return inv
end

function meta:AddToInventoryRocks(skins)
    local inv = self.inv or {}
    local tbl = {}
    local amount = 0
    local altered = false
    local ammo1 = GetAmmoForCurrentWeapon(self)
    for k, v in pairs(inv) do
        if v.Class == "sent_rocks" and v.Skins == skins then
            amount = v.Amount + math.random(25, 30)
            local gRust_Rocks = "Metal"
            if skins == 2 then
                gRust_Rocks = "Sulfur"
            elseif skins == 3 then
                gRust_Rocks = "Rock"
            end

            tbl.Name = gRust_Rocks
            tbl.Class = "sent_rocks" or ""
            tbl.WepClass = "sent_rocks" or ""
            tbl.Mdl = "models/environment/ores/ore_node_stage1.mdl" or ""
            tbl.Ammo_New = ammo1 or 0
            tbl.Amount = amount or 0
            tbl.Skins = v.Skins
            inv[k] = tbl
            altered = true
        end
    end

    if altered == false then inv = WhatRock(self, inv, skins) end
    self.inv = inv
    --net.Start("SendInventory")
    -- net.WriteTable(inv)
    -- net.Send(self)
    file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON(inv))
end

function meta:RemoveInventoryRocks(skins, amt)
    local inv = self.inv or {}
    local tbl = {}
    local amount = 0
    local altered = false
    local ammo1 = GetAmmoForCurrentWeapon(self)
    for k, v in pairs(inv) do
        if v.Class == "sent_rocks" and v.Skins == 3 then
            amount = v.Amount - amt -- math.random(25, 30)
            tbl.Name = "Rock"
            tbl.Class = "sent_rocks" or ""
            tbl.WepClass = "sent_rocks" or ""
            tbl.Mdl = "models/environment/ores/ore_node_stage1.mdl" or ""
            tbl.Ammo_New = ammo1 or 0
            tbl.Amount = amount or 0
            tbl.Skins = v.Skins
            inv[k] = tbl
            altered = true
        end
    end

    if altered == false then inv = WhatRock(self, inv, skins) end
    self.inv = inv
    --net.Start("SendInventory")
    -- net.WriteTable(inv)
    -- net.Send(self)
    file.Write("ginv/inventory_" .. self:SteamID64() .. ".txt", util.TableToJSON(inv))
end

local function BackwardsEnums(enumname)
    local backenums = {}
    for k, v in pairs(_G) do
        if isstring(k) and string.find(k, "^" .. enumname) then backenums[v] = k end
    end
    return backenums
end

hook.Add("EntityTakeDamage", "EntityDamageExample", function(ent, dmginfo)
    local MAT = BackwardsEnums("MAT_")
    local ply = dmginfo:GetAttacker()
    if not IsValid(ply) then return end
    local wep = ply:GetActiveWeapon()
    if not string.find(wep:GetClass(), "hachet") and string.find(wep:GetClass(), "pickaxe") and string.find(wep:GetClass(), "rock") then return end
    if MAT[ent:GetMaterialType()] == "MAT_WOOD" and not string.find(ent:GetClass(), "sent_") then
        if not IsValid(ply) then return end
        if ply:GetActiveWeapon():GetClass() == "rust_rock" then ply:AddToInventoryWood(5) end
    end

    if ent:GetClass() == "sent_rocks" then ply:AddToInventoryRocks(ent:GetSkin()) end
end)

hook.Add("PlayerInitialSpawn", "InventoryLoadout", function(ply)
    ply.inv = ply:FirstCreateInv()
    ply:Give("rust_rock")
    local plymeta = ply:GetItem("Wood")
    --ply:Give("weapon_torch")
    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 10)) do
        if v:GetClass() == "sent_rocks" then ply:SetPos(v:GetPos() + Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMins().z + 12)) end
    end

    ply:SetModel("models/player/Spike/RustGuy.mdl")
    if plymeta == nil then return end
    ply:SetNWFloat("wood", plymeta.Amount)
end)

hook.Add("PlayerSpawn", "GiveITems", function(ply)
    ply.inv = ply:FirstCreateInv()
    ply:Give("rust_rock")
    --ply:Give("weapon_torch")
    for k, v in pairs(ents.FindInSphere(ply:GetPos(), 10)) do
        if v:GetClass() == "sent_rocks" then ply:SetPos(v:GetPos() + Vector(v:OBBMins().x, v:OBBMins().y, v:OBBMins().z + 12)) end
    end

    ply:SetModel("models/player/Spike/RustGuy.mdl")
    local plymeta = ply:GetItem("Wood")
    if plymeta == nil then return end
    ply:SetNWFloat("wood", plymeta.Amount)
end)

hook.Add("PlayerDeath", "RemoveItems", function(ply) ply.inv = ply:FirstCreateInv("b_dead") end)
hook.Add("PlayerUse", "USeInventory", function(ply, ent)
    if ent.IsItem == true then
        ply:AddToInventory(ent)
        ent:Remove()
    end
end)

net.Receive("SendInventory", function(len, ply)
    if ply.CoolDowngrust == nil then ply.CoolDowngrust = 0 end
    if ply.CoolDowngrust >= CurTime() then return end
    ply.CoolDowngrust = CurTime() + 1
    net.Start("ForgiveMeInventory")
    net.WriteTable(ply.inv)
    net.Send(ply)
end)