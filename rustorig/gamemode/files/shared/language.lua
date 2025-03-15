local Language = {
    ["EN"] = {
        ["Hammer"] = "Hammer",
        ["Construction"] = "Construction",
        ["Building Plan"] = "Building Plan",
        ["Mallet_Wep"] = "Mallet there to upgrade stuff\nTime = 20 seconds to make!",
        ["Building_Plan"] = "Building plan there to build stuff\nTime = 25 seconds to make!",
        ["Syringe"] = "Syringe",
        ["Syringe_Info"] = "Healing weapon\nTime = 25 seconds to make!",
        ["Medical"] = "Medical",
        ["Salvaged Machete"] = "Salvaged Machete",
        ["SalvedgeMach_Info"]= "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["SalvedgeSword_Info"] = "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["Salvaged Sword"] = "Salvaged Sword",
        ["Bone Club"] = "Bone Club",
        ["Bone Club info"] = "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["Wooden Spear"] = "Wooden Spear",
        ["woodenspear_info"] = "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["Stone Spear"] = "Stone Spear",
        ["Stone Spear info"] =  "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["Assault Rifle"] = "Assault Rifle",
        ["Assault Rifle Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Rocket Launcher"] = "Rocket Launcher",
        ["Rocker Launcher info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["M39 Rifle"] = "M39 Rifle",
        ["M39 Rifle info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["M92 Pistol"] = "M92 Pistol",
        ["M92 Pistol Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["M249"] = "M249",
        ["M249 Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["MP5A4"] = "MP5A4",
        ["MP5A4 Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Nailgun"] = "Nailgun",
        ["Nailgun Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Python Revolver"] = "Python Revolver",
        ["Python Revolver info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Revolver"] = "Revolver",
        ["Revolver Info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Semi-Automatic Rifle"] = "Semi-Automatic Rifle",
        ["Semi-Automatic Rifle info"] = "A slow, but powerful gun weapon\nTime = 25 seconds to make!",
        ["Stone Hatchet"] = "Stone Hatchet",
        ["Stone Hatchet Info"] = "A slow, but powerful melee weapon\nTime = 25 seconds to make!",
        ["Sleeping Bag"] = "Sleeping Bag",
        ["Resources"] = "Resources",
        ["Sleeping Bag Info"] = "A respawn point\nTime: 25 sec to make!",
        ["Favorite"] = "Favorite",
        ["Construction"] = "Construction",
        ["Items"] = "Items",
        ["Resources"] = "Resources",
        ["Clothing"] = "Clothing",
        ["Tools"] = "Tools",
        ["Medical"] = "Medical",
        ["Weapons"] = "Weapons",
        ["Ammo"] = "Ammo",
        ["Fun"] = "Fun",
        ["Other"] = "Other",

    }
}

Language.Lang = "EN"
function ChangeLanguage(lang)
    Language.Lang = "EN"
end

function GetLanguage(name)
    return Language[Language.Lang][name]
end