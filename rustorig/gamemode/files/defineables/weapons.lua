BluePrint_Make(GetLanguage("Salvaged Machete"), {
    name = GetLanguage("Salvaged Machete"),
    Class = "rust_machete",
    Mdl = "models/weapons/darky_m/rust/w_salvaged_Cleaver.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("SalvedgeMach_Info"),
})

BluePrint_Make(GetLanguage("Salvaged Sword"), {
    name = GetLanguage("Salvaged Sword"),
    Class = "rust_salvaged_sword",
    Mdl = "models/weapons/darky_m/rust/w_salvaged_sword.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_sword.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("SalvedgeSword_Info")
})

BluePrint_Make(GetLanguage("Bone Club"), {
    name = GetLanguage("Bone Club"),
    Class = "rust_bone_knife",
    Mdl = "models/weapons/darky_m/rust/w_boneclub.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Bone Fragments",
            amt = 20,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("bone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/bone_club.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Bone Club info"),
})

BluePrint_Make(GetLanguage("Wooden Spear"), {
    name = GetLanguage("Wooden Spear"),
    Class = "rust_wooden_spear",
    Mdl = "models/weapons/darky_m/rust/w_wooden_spear.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Wood",
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/wooden_spear.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("woodenspear_info"),
})

BluePrint_Make(GetLanguage("Stone Spear"), {
    name = GetLanguage("Stone Spear"),
    Class = "rust_stone_spear",
    Mdl = "models/weapons/darky_m/rust/w_stone_spear.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Stone",
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("stone", 0)) or 0,
        },
    },
    img = "materials/items/weapons/stone_spear.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Stone Spear info"),
})

BluePrint_Make(GetLanguage("Assault Rifle"), {
    name = GetLanguage("Assault Rifle"),
    Class = "rust_ak47u",
    Mdl = "models/weapons/darky_m/rust/w_ak47u.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 100,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/assault_rifle.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Assault Rifle Info"),
})

BluePrint_Make(GetLanguage("Rocket Launcher"), {
    name = GetLanguage("Rocket Launcher"),
    Class = "rust_rocketlauncher",
    Mdl = "models/weapons/darky_m/rust/w_rocketlauncher.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Rocker Launcher info"),
})

BluePrint_Make(GetLanguage("M39 Rifle"), {
    name = GetLanguage("M39 Rifle"),
    Class = "rust_m39emr",
    Mdl = "models/weapons/darky_m/rust/w_m39.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m39.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("M39 Rifle info"),
})

BluePrint_Make(GetLanguage("M92 Pistol"), {
    name = GetLanguage("M92 Pistol"),
    Class = "rust_m92",
    Mdl = "models/weapons/darky_m/rust/w_m92.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m92.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("M92 Pistol Info"),
})

BluePrint_Make(GetLanguage("M249"), {
    name = GetLanguage("M249"),
    Class = "rust_m249",
    Mdl = "models/weapons/darky_m/rust/w_m249.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/m249.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("M249 Info"),
})

BluePrint_Make(GetLanguage("MP5A4"), {
    name = GetLanguage("MP5A4"),
    Class = "rust_mp5",
    Mdl = "models/weapons/darky_m/rust/w_mp5.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/mp5.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("MP5A4 Info"),
})

BluePrint_Make(GetLanguage("Nailgun"), {
    name = GetLanguage("Nailgun"),
    Class = "rust_nailgun",
    Mdl = "models/weapons/darky_m/rust/w_nailgun.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/nailgun.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Nailgun Info"),
})

BluePrint_Make(GetLanguage("Python Revolver"), {
    name = GetLanguage("Python Revolver"),
    Class = "rust_python",
    Mdl = "models/weapons/darky_m/rust/w_python.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/python.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Python Revolver info"),
})

BluePrint_Make(GetLanguage("Revolver"), {
    name = GetLanguage("Revolver"),
    Class = "rust_revolver",
    Mdl = "models/weapons/darky_m/rust/w_revolver.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/revolver.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Revolver Info"),
})

BluePrint_Make(GetLanguage("Semi-Automatic Rifle"), {
    name = "Semi-Automatic Rifle",
    Class = "rust_sar",
    Mdl = "models/weapons/darky_m/rust/w_sap.mdl",
    ammo = "none",
    amount = 40,
    timers = 25,
    func = function(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "wood",
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "materials/items/weapons/sap.png",
    Where = GetLanguage("Weapons"),
    locked = false,
    Infomation = GetLanguage("Semi-Automatic Rifle info"),
})