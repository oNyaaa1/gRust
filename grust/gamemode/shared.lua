DeriveGamemode("base")
GM.Name = "gRust | By oNyaaaa"
GMRustTable = GMRustTable or {}
Crafting = Crafting or {}
Translation = function(txt) return GMRustTable[txt] or {} end
function BluePrint_Make(txt, tbl)
    GMRustTable[txt] = tbl
end

function BluePrint_Get(txt)
    local data = {}
    for k, v in pairs(GMRustTable) do
        if v.name == txt then data = v end
    end
    return data
end

BluePrint_Make("Hammer", {
    name = "Hammer",
    Class = "hands_hammer",
    Mdl = "models/weapons/darky_m/rust/w_hammer.mdl",
    amount = 50,
    ammo = "none",
    timers = CurTime() + 20,
    func = function(txt)
        print(txt)
        net.Start("gRust_Queue_Crafting")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        txt = "Wood",
        amt = 50,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
    },
    img = "items/tools/hammer.png",
    Where = "Construction",
    locked = false,
    Infomation = "Mallet there to upgrade stuff\nTime = 20 seconds to make!",
})

BluePrint_Make("BluePrint", {
    name = "Building Plan",
    Class = "hands_builder",
    Mdl = "models/darky_m/rust/w_buildingplan.mdl",
    ammo = "none",
    amount = 40,
    timers = CurTime() + 25,
    func = function(txt)
        net.Start("gRust_Queue_Crafting")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        txt = "Wood",
        amt = 40,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
    },
    img = "items/tools/building_plan.png",
    Where = "Construction",
    locked = false,
    Infomation = "Building plan there to build stuff\nTime = 25 seconds to make!",
})

BluePrint_Make("Salvaged Cleaver", {
    name = "Salvaged Cleaver",
    Class = "weapon_sc",
    Mdl = "models/weapons/darky_m/rust/w_salvaged_Cleaver.mdl",
    ammo = "none",
    amount = 40,
    timers = CurTime() + 25,
    func = function(txt)
        net.Start("gRust_Queue_Crafting")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        txt = "Metal Fragments",
        amt = 40,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Rocket Launcher", {
    name = "Rocket Launcher",
    Class = "rust_rocketlauncher",
    Mdl = "models/weapons/darky_m/rust/w_rocketlauncher.mdl",
    ammo = "none",
    amount = 40,
    timers = CurTime() + 25,
    func = function(txt)
        net.Start("gRust_Queue_Crafting")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        txt = "Metal Fragments",
        amt = 40,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("metal", 0)) or 0,
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Weapons",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})

BluePrint_Make("Stone Hatchet", {
    name = "Stone Hatchet",
    Class = "tfa_rustalpha_stone_hatchet",
    Mdl = "models/weapons/yurie_rustalpha/wm-stonehatchet.mdl",
    ammo = "none",
    amount = 40,
    timers = CurTime() + 25,
    func = function(txt)
        net.Start("gRust_Queue_Crafting")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        txt = "Wood",
        amt = 30,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
    },
    need2 = {
        txt = "Stone",
        amt = 20,
        yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("stone", 0)) or 0,
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = "Tools",
    locked = false,
    Infomation = "A slow, but powerful melee weapon\nTime = 15 seconds to make!",
})