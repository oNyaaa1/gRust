BluePrint_Make(GetLanguage("Hammer"), {
    name = GetLanguage("Hammer"),
    Class = "hands_hammer",
    Mdl = "models/weapons/darky_m/rust/w_hammer.mdl",
    amount = 50,
    ammo = "none",
    timers = 20,
    func = function(txt)
        print(txt)
        net.Start("Craft_BP")
        net.WriteString(txt)
        net.SendToServer()
    end,
    gotob = function(txt) print(txt, "cancelled") end,
    need = {
        {
            txt = "Wood",
            amt = 50,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "items/tools/hammer.png",
    Where = GetLanguage("Construction"),
    locked = false,
    Infomation = GetLanguage("Mallet_Wep"),
})

BluePrint_Make(GetLanguage("Building Plan"), {
    name = GetLanguage("Building Plan"),
    Class = "hands_builder",
    Mdl = "models/darky_m/rust/w_buildingplan.mdl",
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
            amt = 40,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("wood", 0)) or 0,
        },
    },
    img = "items/tools/building_plan.png",
    Where = GetLanguage("Construction"),
    locked = false,
    Infomation = GetLanguage("Building_Plan"),
})
