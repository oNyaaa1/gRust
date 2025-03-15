BluePrint_Make(GetLanguage("Sleeping Bag"), {
    name = GetLanguage("Sleeping Bag"),
    Class = "sleeper_bag",
    Mdl = "models/galaxy/rust/sleepingbag.mdl",
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
            txt = "Cloth",
            amt = 30,
            yours = CLIENT and IsValid(LocalPlayer()) and tostring(LocalPlayer():GetNWFloat("cloth", 0)) or 0,
        },
    },
    need2 = {},
    img = "materials/items/weapons/salvaged_cleaver.png",
    Where = GetLanguage("Resources"),
    locked = false,
    Infomation = GetLanguage("Sleeping Bag Info"),
})