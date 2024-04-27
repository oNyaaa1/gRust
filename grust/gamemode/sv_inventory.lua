util.AddNetworkString("inv_snd")
util.AddNetworkString("inv_give")
util.AddNetworkString("WriteInv")
util.AddNetworkString("inventory_Test")
util.AddNetworkString("hands_builder_map")
util.AddNetworkString("Sent_Vood")
inventory = {}
inventory.Test = {}
function AddToInventory(ply, item, alter)
    if ply.Inv == nil then ply.Inv = {} end
    alter = alter or false
    --if table.HasValue( ply.Inv, item ) then return end
    --table.insert( ply.Inv, item )
    if item.Name == "" then return end
    --if table.HasValue( ply.Inventory, item.Name ) then
    if item.WepClass ~= "none" then ply:Give(item.WepClass) end
    if item.Ammo_New ~= "none" then ply:GiveAmmo(100, item.Ammo_New) end
    --
    ModifyInventory(ply, item, item.Amount)
    --for k, v in pairs(ply.Inventory) do
    --if v.Name == item.Name then print(v.Name) end --ModifyInventory(ply, item, item.Amount) end
    --end
    net.Start("inventory_Test")
    net.WriteTable(ply.Inventory)
    net.Send(ply)
    --net.Start( "inventory_Test" )
    --net.WriteTable( ply.Inventory )
    --net.Send( ply )
    --table.RemoveByValue( ply.Inv, item )
    --end
end

hook.Remove("PlayerButtonDown", "KeyDown_Minimap")
hook.Add(
    "PlayerInitialSpawn",
    "MiniMap",
    function(ply)
        umsg.Start("Minimap", ply)
        umsg.End()
    end
)

util.AddNetworkString("grust_SendItOVa")
function InitializeInventory(ply)
    ply.Inventory = {}
    local wep = ply:GetActiveWeapon()
    if IsValid(wep) then wep.Dropped = true end
    AddToInventory(
        ply,
        {
            Name = "M4",
            WepClass = "tfa_rustalpha_m4",
            Mdl = "items/weapons/lr300.png",
            Ammo_New = "ar2",
            Amount = 1,
        }
    )

    AddToInventory(
        ply,
        {
            Name = "Hatchet",
            WepClass = "tfa_rustalpha_hatchet",
            Mdl = "items/tools/hatchet.png",
            Ammo_New = "none",
            Amount = 1,
        }
    )

    AddToInventory(
        ply,
        {
            Name = "Pickaxe",
            WepClass = "tfa_rustalpha_pickaxe",
            Mdl = "items/tools/pickaxe.png",
            Ammo_New = "none",
            Amount = 1,
        }
    )

    if IsValid(wep) then wep.Dropped = true end
    ply.Spawned = true
    ply.Counter_Vood = 0
    net.Start("grust_SendItOVa")
    net.WriteTable(ply.Inventory)
    net.Send(ply)
end

hook.Add("PlayerSpawn", "InitializeInventory", InitializeInventory)
function RemoveFromInventory(ply, item)
    for k, v in pairs(ply.Inventory) do
        if v.WepClass == item then
            table.remove(ply.Inventory, k)
            net.Start("inventory_Test")
            net.WriteTable(ply.Inventory)
            net.Send(ply)
            break
        end
    end
end

function ModifyInventory(ply, item, amount)
    amount = amount or 1
    local alter = false
    for k, v in pairs(ply.Inventory) do
        if item.Name == v.Name then alter = true end
    end

    if alter == false then
        --ply.Inventory[item] = amount
        table.insert(ply.Inventory, item)
    else
        for k, v in pairs(ply.Inventory) do
            if v.Name == "Scrap" then
                v.Amount = v.Amount + amount
            elseif item.Name == v.Name then
                v.Amount = amount
            end
        end
    end
end

-- Example usage:
--ModifyInventory(LocalPlayer(), "Pistol Ammo", 10)
function FindInInventory(itemName)
    for _, item in pairs(ply.Inventory) do
        if item.name == itemName then return item end
    end
    return nil
end

--RemoveFromInventory(player.GetAll()[1], "Pistol")
inventory.AddItem = function(name, mdl, class, ammo, amt, ply)
    if ply.Inventory == nil then ply.Inventory = {} end
    AddToInventory(
        ply,
        {
            Name = name,
            WepClass = class,
            Mdl = mdl,
            Ammo_New = ammo,
            Amount = amt,
        }
    )

    net.Start("inventory_Test")
    net.WriteTable(ply.Inventory)
    net.Send(ply)
    return item
end

--table.insert( ply.Inventory, item )
function GetInvItems(ply)
    return ply.Inventory
end

--[[
inventory.AddItem( "AK47", "models/weapons/darky_m/rust/c_ak47u.mdl", "rust_ak47u", "ar2" )
inventory.AddItem( "Bolty", "models/weapons/darky_m/rust/c_boltrifle.mdl", "rust_boltrifle", "ar2" )
inventory.AddItem( "Hands", "models/weapons/darky_m/rust/c_hammer.mdl", "hands_builder", "none" )
inventory.AddItem( "Hammer", "models/weapons/darky_m/rust/c_hammer.mdl", "hands_hammer", "none" )
inventory.AddItem( "Sar", "models/weapons/darky_m/rust/c_sar.mdl", "rust_sar", "ar2" )
inventory.AddItem( "LR", "models/weapons/darky_m/rust/c_lr300.mdl", "rust_lr300", "ar2" )
inventory.AddItem( "C4", "models/weapons/darky_m/rust/c_c4.mdl", "rust_c4","rust_c4" )
inventory.AddItem( "Rocket Launcher", "models/weapons/darky_m/rust/c_rocketlauncher.mdl", "rust_rocketlauncher","RPG_Round" )
]]
hook.Add(
    "Tick",
    "checkinv",
    function()
        for k, v in pairs(player.GetAll()) do
            if v.ResetTime == nil then v.ResetTime = 0 end
            if v.ResetTime + CurTime() % 8 == 0 and v.NotHitting == false then
                v.Counter_Vood = 0
                net.Start("Sent_Vood")
                net.WriteBool(false)
                net.WriteString("Wood")
                net.WriteFloat(v:GetEnoughVood())
                net.Send(v)
                v.ResetTime = 8
            end

            if v.ResetTime + CurTime() % 8 == 0 and v.NotHitting == false then
                v.Counter_Metal = 0
                net.Start("Sent_Vood")
                net.WriteBool(false)
                net.WriteString("Metal")
                net.WriteFloat(v:GetEnoughMetal())
                net.Send(v)
                v.ResetTime = 8
            end

            if v.ResetTime + CurTime() % 8 == 0 and v.NotHitting == false then
                v.Counter_Metal = 0
                net.Start("Sent_Vood")
                net.WriteBool(false)
                net.WriteString("Sulfur")
                net.WriteFloat(v:GetEnoughSulfur())
                net.Send(v)
                v.ResetTime = 8
            end

            if v.ResetTime + CurTime() % 8 == 0 and v.NotHitting == false then
                v.Counter_Metal = 0
                net.Start("Sent_Vood")
                net.WriteBool(false)
                net.WriteString("Stone")
                net.WriteFloat(v:GetEnoughStone())
                net.Send(v)
                v.ResetTime = 8
            end

            if v.ResetTime + CurTime() % 6 == 0 then v.NotHitting = false end
            -- for k1, v2 in pairs(v.Inventory) do
            -- if IsValid(v) and v2.WepClass ~= nil then
            -- RemoveFromInventory( v, v2.WepClass ) -- print(v,k1,v2) --table.remove( v.Inventory, k1 ) --net.Start( "inventory_Test" ) --net.WriteTable( v.Inventory ) --net.Send( v )
            --if v:HasWeapon(v2.WepClass) == false then RemoveFromInventory(v, v2.WepClass) end
            -- end
            -- end
        end
    end
)

hook.Add(
    "WeaponEquip",
    "WeaponEquipExample",
    function(wep, ply)
        timer.Simple(
            0,
            function()
                if wep.Dropped == nil then wep.Dropped = false end
                if wep.Dropped == true then return end
                --[[AddToInventory(
                    ply,
                    {
                        Name = wep.PrintName or "",
                        WepClass = wep:GetClass() or "",
                        Mdl = wep:GetModel() or "",
                        Ammo_New = wep.Primary.Ammo or "none",
                    }
                )]]
                wep.Dropped = false
            end
        )
    end
)

hook.Add(
    "PlayerDroppedWeapon",
    "dropwep",
    function(ply, wep)
        if wep.Dropped == nil then wep.Dropped = false end
        wep.Dropped = true
        RemoveFromInventory(ply, wep:GetClass())
    end
)

-- Helper function to build our table of values.
local function BackwardsEnums(enumname)
    local backenums = {}
    for k, v in pairs(_G) do
        if isstring(k) and string.find(k, "^" .. enumname) then backenums[v] = k end
    end
    return backenums
end

--[[
hook.Add(
    "EntityTakeDamage",
    "EntityDamageExample",
    function(v, dmginfo)
        local MAT = BackwardsEnums("MAT_")
        local validClasses = {
            prop_physics = true,
            prop_physics_multiplayer = true,
            prop_dynamic = true
        }

        if MAT[v:GetMaterialType()] == "MAT_WOOD" then
            local ply = dmginfo:GetAttacker()
            if IsValid(ply) then
                ply.Counter_Vood = math.random(5, 9)
                ply:SetEnoughVood(ply.Counter_Vood)
                net.Start("Sent_Vood")
                net.WriteBool(true)
                net.WriteString("Wood")
                net.WriteFloat(ply:GetEnoughVood())
                net.Send(ply)
                ply.ResetTime = 0
                ply.NotHitting = true
            end
        end
    end
)]]
--inventory.AddItem( "Rock", "models/weapons/darky_m/rust/c_rock2.mdl", "rust_rock", "none", ply )
--[[ for k, v in pairs( GetInvItems( ply ) ) do
        ply:Give( v.class )

        if v.ammo ~= "none" then
            ply:GiveAmmo( 100, v.ammo )
        end
    end]]
--net.Start( "inventory_Test" ) --net.WriteTable( GetInvItems( ply ) ) --net.Send( ply )
--ply:SetNWFloat( "wood", 9999 )
--ply:SetNWFloat( "metal", 9999 )
--ply:SetNWFloat( "hqm", 9999 )
--ply:SelectWeapon( "rust_ak47u" )
hook.Add("PlayerDeath", "OnKilled", function(victim, inf, attacker) end)
net.Receive(
    "inv_give",
    function(l, ply)
        local what = net.ReadString()
        ply:SelectWeapon(what)
    end
)