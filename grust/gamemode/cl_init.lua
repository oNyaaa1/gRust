include("shared.lua")
include("ui/threegrid.lua")
include("sharity.lua")
include("cl_inventory.lua")
include("escmenu.lua")
include("circles.lua")
local AZN_RadialMenu = {}
AZN_RadialMenu.utils = AZN_RadialMenu.utils or {}
AZN_RadialMenu.utils.math = AZN_RadialMenu.utils.math or {}
AZN_RadialMenu.Selected = AZN_RadialMenu.Selected or {}
Map = Map or {}
local math = math
local ipairs = ipairs
local table = table
local surface = surface
local draw = draw
local noTexture = draw.NoTexture
local drawText = draw.DrawText
local setDrawColor = surface.SetDrawColor
local Color = Color
local sqrt = math.sqrt
local ease = math.ease
local max = math.max
local rad = math.rad
local cos = math.cos
local sin = math.sin
local abs = math.abs
local floor = math.floor
local drawPoly = surface.DrawPoly
local insert = table.insert
AZN_RadialMenu.ShowMenu = false
-- perform a linear interpolation but with colors
function AZN_RadialMenu.utils.math.lerpColor(t, from, to)
    local fr, fg, fb, fa = from.r, from.g, from.b, from.a or 255
    local tr, tg, tb, ta = to.r, to.g, to.b, to.a or 255
    local r = fr + (tr - fr) * t
    local g = fg + (tg - fg) * t
    local b = fb + (tb - fb) * t
    local a = fa + (ta - fa) * t
    return r, g, b, a
end

function AZN_RadialMenu.utils.math.easedLerpColor(frac, from, to)
    return AZN_RadialMenu.utils.math.lerpColor(ease.InSine(frac), from, to)
end

-- computes area using determinant
-- A := [ x1 y1 1  
--         x2 y2 1  
--         x3 y3 1 ]
-- Area = 1/2 * detA
function AZN_RadialMenu.utils.math.triangleArea(p1, p2, p3)
    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local x3, y3 = p3.x, p3.y
    return 0.5 * (x1 * (y2 - y3) - x2 * (y1 - y3) + x3 * (y1 - y2))
end

-- for each triangle, check using barycentric coordinates whether P(x, y) lies within the triangle
function AZN_RadialMenu.utils.math.inPolygon(triangles, x, y)
    local p = {
        x = x,
        y = y
    }

    for _, t in ipairs(triangles) do
        if #t == 3 then
            local alpha = ((t[2].y - t[3].y) * (x - t[3].x) + (t[3].x - t[2].x) * (y - t[3].y)) / ((t[2].y - t[3].y) * (t[1].x - t[3].x) + (t[3].x - t[2].x) * (t[1].y - t[3].y))
            local beta = ((t[3].y - t[1].y) * (x - t[3].x) + (t[1].x - t[3].x) * (y - t[3].y)) / ((t[2].y - t[3].y) * (t[1].x - t[3].x) + (t[3].x - t[2].x) * (t[1].y - t[3].y))
            local gamma = 1 - alpha - beta
            if alpha > 0 and beta > 0 and gamma > 0 then return true end
        end
    end
    return false
end

-- find polygon centroid 
function AZN_RadialMenu.utils.math.centroid(triangles)
    local points = {}
    local areas = {}
    local polygonArea = 0
    for k, t in ipairs(triangles) do
        if #t == 3 then
            local area = AZN_RadialMenu.utils.math.triangleArea(t[1], t[2], t[3])
            polygonArea = polygonArea + area
            insert(areas, area)
        end
    end

    for k, t in ipairs(triangles) do
        if #t == 3 then
            local localCentroidX = (t[1].x + t[2].x + t[3].x) / 3
            local localCentroidY = (t[1].y + t[2].y + t[3].y) / 3
            insert(points, {(localCentroidX * areas[k]) / polygonArea, (localCentroidY * areas[k]) / polygonArea})
        end
    end

    local centroid = {
        x = 0,
        y = 0
    }

    for k, v in ipairs(points) do
        centroid.x = centroid.x + v[1]
        centroid.y = centroid.y + v[2]
    end
    return centroid
end

-- >________________< to /\/\/\/\/\/\/\/\
function AZN_RadialMenu.utils.math.triangulate(inner, outer)
    local triangles = {}
    for i = 1, #inner + #outer do
        local p1, p2, p3
        p1 = outer[floor(i / 2) + 1]
        p3 = inner[floor((i + 1) / 2) + 1]
        if i % 2 == 0 then
            p2 = outer[floor((i + 1) / 2)]
        else
            p2 = inner[floor((i + 1) / 2)]
        end

        insert(triangles, {p1, p2, p3})
    end
    return triangles
end

-- Helper function to cache the triangles that will be drawn to the screen
function AZN_RadialMenu.utils.cacheArc(x0, y0, r, start_angle, end_angle, thickness, roughness)
    -- Fails silently
    if not (r > 0) then return {} end
    local triangles
    local step = max(roughness or 1, 1)
    if start_angle > end_angle then step = abs(step) * -1 end
    local inner, outer = {}, {}
    local innerRadius = r - thickness
    for t = start_angle, end_angle, step do
        local trad = rad(t)
        local xt0, yt0 = cos(trad), -sin(trad)
        local inner_xt = x0 + xt0 * innerRadius
        local inner_yt = y0 + yt0 * innerRadius
        local outer_xt = x0 + xt0 * r
        local outer_yt = y0 + yt0 * r
        insert(
            inner,
            {
                x = inner_xt,
                y = inner_yt,
                u = (inner_xt - x0) / r + 0.5,
                v = (inner_yt - y0) / r + 0.5
            }
        )

        insert(
            outer,
            {
                x = outer_xt,
                y = outer_yt,
                u = (outer_xt - x0) / r + 0.5,
                v = (outer_yt - y0) / r + 0.5
            }
        )
    end

    triangles = AZN_RadialMenu.utils.math.triangulate(inner, outer)
    return triangles
end

-- Main function to actually draw arcs (using draw.DrawPoly)
function AZN_RadialMenu.utils.drawArc(polygons)
    for k, polygon in ipairs(polygons) do
        drawPoly(polygon)
    end
end

AZN_RadialMenu.emoteNames = {"sent_foundation", "sent_ceiling", "sent_wall", "sent_doorway", "sent_door"}
AZN_RadialMenu.emotes = {AZN_RadialMenu.emoteNames[1], AZN_RadialMenu.emoteNames[2], AZN_RadialMenu.emoteNames[3], AZN_RadialMenu.emoteNames[4], AZN_RadialMenu.emoteNames[5]}
AZN_RadialMenu.emoteNames2 = {
    "Wood", --, "Stone", "Metal"
    "Rotate"
}

AZN_RadialMenu.emotes2 = {
    AZN_RadialMenu.emoteNames2[1], --, AZN_RadialMenu.emoteNames2[2], AZN_RadialMenu.emoteNames2[3]
    AZN_RadialMenu.emoteNames2[2]
}

local innerCircle = AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 125, 0, 360, 125, 0.5)
local arcs = {}
local angFrac = 360 / #AZN_RadialMenu.emotes
local start = rad(angFrac) / 2
local gap = 2
for i = 1, #AZN_RadialMenu.emotes do
    insert(arcs, AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 300, (i - 1) * angFrac + gap, i * angFrac - gap, 150, 0.5))
end

local centers = {}
for i = 1, #arcs do
    local p = AZN_RadialMenu.utils.math.centroid(arcs[i])
    insert(centers, {p.x, p.y})
end

local innerCircle2 = AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 125, 0, 360, 125, 0.5)
local arcs2 = {}
local angFrac2 = 360 / #AZN_RadialMenu.emotes2
local start = rad(angFrac2) / 2
local gap = 2
for i = 1, #AZN_RadialMenu.emotes2 do
    insert(arcs2, AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 300, (i - 1) * angFrac + gap, i * angFrac - gap, 150, 0.5))
end

local centers2 = {}
for i = 1, #arcs2 do
    local p = AZN_RadialMenu.utils.math.centroid(arcs2[i])
    insert(centers2, {p.x, p.y})
end

surface.CreateFont(
    "RadialMenu_Big",
    {
        font = "Roboto Condensed Light",
        size = 42
    }
)

surface.CreateFont(
    "RadialMenu_Normal",
    {
        font = "Roboto Condensed Light",
        size = 28
    }
)

local fontHeight = 14
local animStart = SysTime()
local animTime = 0.25
local mouseEnabled
local showMenu = false
concommand.Add("+azrm_showmenu", function() showMenu = true end)
concommand.Add("-azrm_showmenu", function() showMenu = false end)
hook.Add(
    "HUDPaint",
    "AZRM::Render2D",
    function()
        if not LocalPlayer():Alive() then return end
        local wep = LocalPlayer():GetActiveWeapon()
        if IsValid(wep) then
            if wep:GetClass() == "hands_hammer" then
                if showMenu then
                    if not mouseEnabled then
                        gui.EnableScreenClicker(true)
                        mouseEnabled = true
                    end

                    noTexture()
                    for i = 1, #arcs2 do
                        local withinPoly = AZN_RadialMenu.utils.math.inPolygon(arcs[i], gui.MouseX(), gui.MouseY())
                        if withinPoly and input.IsMouseDown(MOUSE_LEFT) then
                            Map.Str2 = AZN_RadialMenu.emotes2[i]
                            net.Start("gRust_ServerModel_new")
                            net.WriteString(AZN_RadialMenu.emotes2[i])
                            net.SendToServer()
                            showMenu = false
                            return
                        end

                        if withinPoly then
                            setDrawColor(AZN_RadialMenu.utils.math.easedLerpColor((SysTime() - animStart) / animTime, Color(56, 58, 64, 200), Color(103, 112, 218, 200)))
                            drawText(AZN_RadialMenu.emotes2[i], "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                        else
                            setDrawColor(56, 58, 64, 200)
                        end

                        AZN_RadialMenu.utils.drawArc(arcs2[i])
                    end

                    setDrawColor(56, 58, 64, 200)
                    AZN_RadialMenu.utils.drawArc(innerCircle2)
                    --drawText( "Selection", "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                    for i = 1, #centers2 do
                        if i > 1 then
                            drawText(tostring(AZN_RadialMenu.emotes2[i]), "RadialMenu_Normal", centers2[i][1], centers2[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                        else
                            drawText(tostring(AZN_RadialMenu.emotes2[i]), "RadialMenu_Normal", centers2[i][1], centers2[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                        end
                    end
                else
                    if mouseEnabled then
                        gui.EnableScreenClicker(false)
                        mouseEnabled = false
                    end
                end
                return
            end

            if showMenu then
                if not mouseEnabled then
                    gui.EnableScreenClicker(true)
                    mouseEnabled = true
                end

                noTexture()
                for i = 1, #arcs do
                    local withinPoly = AZN_RadialMenu.utils.math.inPolygon(arcs[i], gui.MouseX(), gui.MouseY())
                    if withinPoly and input.IsMouseDown(MOUSE_LEFT) then
                        Map.Str = AZN_RadialMenu.emotes[i]
                        net.Start("gRust_ServerModel")
                        net.WriteString(AZN_RadialMenu.emotes[i])
                        net.SendToServer()
                        showMenu = false
                        return
                    end

                    if withinPoly then
                        setDrawColor(AZN_RadialMenu.utils.math.easedLerpColor((SysTime() - animStart) / animTime, Color(56, 58, 64, 200), Color(103, 112, 218, 200)))
                        drawText(AZN_RadialMenu.emotes[i], "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    else
                        setDrawColor(56, 58, 64, 200)
                    end

                    AZN_RadialMenu.utils.drawArc(arcs[i])
                end

                setDrawColor(56, 58, 64, 200)
                AZN_RadialMenu.utils.drawArc(innerCircle)
                --drawText( "Selection", "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                for i = 1, #centers do
                    if i > 1 then
                        drawText(tostring(scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName), "RadialMenu_Normal", centers[i][1], centers[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    else
                        drawText(tostring(scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName), "RadialMenu_Normal", centers[i][1], centers[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    end
                end
            else
                if mouseEnabled then
                    gui.EnableScreenClicker(false)
                    mouseEnabled = false
                end
            end
        end
    end
)

surface.CreateFont(
    "StringFont",
    {
        font = "Roboto",
        size = 23,
        weight = 700
    }
)

local function HUDHide(myhud)
    for k, v in pairs{'CHudHealth', 'CHudBattery', 'CHudAmmo', 'CHudDeathNotice', 'CHUDQuickInfo', 'CHudHintDisplay'} do
        if myhud == v then return false end
    end
end

hook.Add('HUDShouldDraw', 'HudHide', HUDHide)
local start, oldhp, newhp = 0, -1, -1
local barW = 200
local animationTime = 0.9
local startar, oldar, newar = 0, -1, -1
local VoodStn = {}
VoodStn[1] = {false, "", 0}
local BarMove = 0
net.Receive(
    "Sent_Vood",
    function()
        local sent = net.ReadBool()
        local what_then = net.ReadString()
        local seed = net.ReadFloat()
        local seeds = net.ReadFloat()
        VoodStn[1] = {
            bool = sent or false,
            str = what_then,
            amt = seed
        }

        BarMove = seeds
    end
)

local function hud()
    local ply = LocalPlayer()
    local hp = LocalPlayer():Health()
    local maxhp = LocalPlayer():GetMaxHealth()
    local color_blue = Color(74, 159, 221)
    local color_g = Color(150, 198, 62)
    local color_b = Color(49, 47, 42, 225)
    local color_h = Color(217, 135, 79)
    local ar = LocalPlayer():Armor()
    local scrw = ScrW()
    local scrh = ScrH()
    local testmterial = Material("icons/health.png")
    local armor = Material("icons/cup.png")
    local hungr = Material("icons/medical.png")
    local smoothHP = Lerp((SysTime() - start) / animationTime, oldhp, newhp)
    local smoothAR = Lerp((SysTime() - startar) / animationTime, oldar, newar)
    if hp <= 0 then return end
    if oldhp == -1 and newhp == -1 then
        oldhp = hp
        newhp = hp
    end

    if newhp ~= hp then
        if smoothHP ~= hp then newhp = smoothHP end
        oldhp = newhp
        start = SysTime()
        newhp = hp
    end

    if newar ~= ar then
        if smoothAR ~= ar then newar = smoothAR end
        oldar = newar
        startar = SysTime()
        newar = ar
    end

    draw.RoundedBoxEx(15, ScrW() - 306, scrh - 162, 238, 32, color_b, false, false, false, false)
    draw.RoundedBoxEx(15, ScrW() - 270, scrh - 159, math.Clamp(0, 100, smoothHP) / maxhp * barW, 25, color_g, false, false, false, false)
    draw.SimpleText(hp, "StringFont", ScrW() - 270, scrh - 159, color_white)
    if VoodStn[1].bool == true then
        draw.RoundedBoxEx(15, ScrW() - 306, scrh - 196, 238, 32, color_b, false, false, false, false)
        draw.RoundedBoxEx(15, ScrW() - 270, scrh - 196, math.Clamp(0, 100, tonumber(BarMove)) / 100 * barW, 25, color_g, false, false, false, false)
        draw.SimpleText(tostring(VoodStn[1].str) .. ": " .. tostring(VoodStn[1].amt), "StringFont", ScrW() - 270, scrh - 196, color_white)
    end

    draw.RoundedBoxEx(15, ScrW() - 306, scrh - 128, 238, 32, color_b, false, false, false, false)
    draw.RoundedBoxEx(15, ScrW() - 270, scrh - 125, math.Clamp(0, 100, smoothAR) * 2, 25, color_blue, false, false, false, false)
    draw.SimpleText(ar, "StringFont", ScrW() - 270, scrh - 125, color_white)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(testmterial)
    surface.DrawTexturedRect(ScrW() - 303, scrh - 160, 25, 25)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(armor)
    surface.DrawTexturedRect(ScrW() - 303, scrh - 125, 30, 30)
    --[[local wep = ply:GetActiveWeapon()
    if !IsValid(wep) or !ply:Alive() or !wep:IsWeapon() then 
        return 
    else
        draw.RoundedBoxEx( 15, 164, scrh - 94,  90, 32, color_b, false, false, false, false )
        draw.SimpleText( wep:Clip1() .. '/' .. ply:GetAmmoCount(wep:GetPrimaryAmmoType()), 'StringFont', 210, scrh-80, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end]]
end

hook.Add('HUDPaint', 'rhud', hud)
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
local Crafting = {}
local text_to_glow = ""
Crafting.Table = {
    {
        Textation = "Hammer",
        func = function(txt)
            print(txt)
            net.Start("gRust_Queue_Crafting")
            net.WriteString(txt)
            net.SendToServer()
        end,
        gotob = function(txt) print(txt, "cancelled") end,
        need = {
            txt = "Wood",
            amt = 50
        },
        timers = 20,
        img = "items/tools/hammer.png",
        Where = "Construction",
        locked = false,
    },
    {
        Textation = "BluePrint",
        func = function(txt)
            net.Start("gRust_Queue_Crafting")
            net.WriteString(txt)
            net.SendToServer()
        end,
        gotob = function(txt) print(txt, "cancelled") end,
        need = {
            txt = "Wood",
            amt = 40
        },
        timers = 25,
        img = "items/tools/building_plan.png",
        Where = "Construction",
        locked = false,
    },
}

local Paneln_Crafttb = {}
local Panelnb = {}
function AddItemPanel_2(txt, Craft, CancelCraft, where, img, num, newpnl, timers)
    local pass = false
    for k, v in pairs(Crafting.Table) do
        if v.Where == where then
            pass = true
        end
    end

    if pass == false then return end
    Panelnb[num] = vgui.Create("DImageButton")
    Panelnb[num].Text = txt
    Panelnb[num].Clause = where
    Panelnb[num].locked = false
    Panelnb[num]:SetText(Panelnb[num].Text)
    Panelnb[num]:SetSize(100, 100)
    Panelnb[num]:SetImage(img)
    local time = CurTime() + 60
    --Paneln:SetPos(50, 50)
    --Paneln:SetSize(150, 100)
    Panelnb[num].DoClick = function()
        --AddQueueItem("items/tools/building_plan.png", 10, 6, 1)
        Craft(Panelnb[num].Text)
        Crafting.Panel2b = vgui.Create("XeninUI.Panel", newpnl)
        Crafting.Panel2b:Dock(LEFT)
        Crafting.Panel2b:SetSize(150, newpnl:GetTall())
        Crafting.Panel2bc = vgui.Create("XeninUI.Panel", Crafting.Panel2b)
        Crafting.Panel2bc:SetSize(150, 150)
        Crafting.Panel2bc:SetSize(150, newpnl:GetTall())
        local Paneln_Craft = vgui.Create("DImageButton", Crafting.Panel2bc)
        Paneln_Craft:SetImage(img)
        Paneln_Craft:SetPos(0, 0)
        Paneln_Craft:SetSize(150, Crafting.Panel2bc:GetTall() - 10)
        Paneln_Craft.Paint = function(s, w, h)
            Panelnb[num].Timer = timers
            draw.RoundedBox(0, 0, 0, w, h - 10, Color(100, 100, 100, 100))
            draw.DrawText(txt .. " Timeleft: " .. math.Round(CurTime() - Panelnb[num].Timer), "Default", Panelnb[num]:GetWide() * 0.05, 70, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            if math.Round(CurTime() - Panelnb[num].Timer) >= 0 then Panelnb[num]:Remove() end
        end

        Paneln_Crafttb[num] = {
            pnl = Paneln_Craft,
            Image = img,
            Text = txt,
            Timer = timers,
        }
    end

    Panelnb[num].DoRightClick = function() CancelCraft(Panelnb[num].Text) end
    return Panelnb[num]
end

function GM:ScoreboardShow()
    gui.EnableScreenClicker(true)
    Crafting.Panel = vgui.Create("XeninUI.Panel")
    Crafting.Panel:SetPos(50, 50)
    Crafting.Panel:SetSize(ScrW() - 100, ScrH() - 300)
    Crafting.Panel.Paint = function(s, w, h)
        surface.SetDrawColor(26, 25, 22, 245)
        surface.DrawRect(0, 0, w, h)
    end

    Crafting.Panel:Center()
    Crafting.Panel2 = vgui.Create("XeninUI.Panel", Crafting.Panel)
    Crafting.Panel2:SetPos(0, 1)
    Crafting.Panel2:SetSize(Crafting.Panel:GetWide(), Crafting.Panel:GetTall())
    Crafting.Panel3 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel3:SetPos(0, 1)
    Crafting.Panel3:SetSize(Crafting.Panel2:GetWide() / 2 - 300, Crafting.Panel2:GetTall() - 100)
    Crafting.Panel3.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 255)) end
    Crafting.Panel4 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel4:SetPos(Crafting.Panel3:GetWide() + 10, 1)
    Crafting.Panel4:SetSize(Crafting.Panel2:GetWide(), Crafting.Panel2:GetTall() - 100)
    Crafting.Panel4.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 255)) end
    Crafting.Panel5 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel5:Dock(BOTTOM)
    Crafting.Panel5:SetSize(Crafting.Panel2:GetWide(), Crafting.Panel2:GetTall() - 510)
    Crafting.Panel5.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 255)) end
    local grid = vgui.Create("DGrid", Crafting.Panel4)
    grid:SetPos(10, 30)
    grid:SetCols(5)
    grid:SetColWide(102)
    grid:SetRowHeight(102)
    local Paneln = {}
    if table.Count(Paneln_Crafttb) > 0 then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2b = vgui.Create("XeninUI.Panel", Crafting.Panel5)
            Panel2b:Dock(LEFT)
            Panel2b:SetSize(150, Crafting.Panel5:GetTall())
            local Panel2bc = vgui.Create("XeninUI.Panel", Panel2b)
            Panel2bc:SetSize(150, 150)
            Panel2bc:SetSize(150, Panel2b:GetTall())
            local Paneln_Craft = vgui.Create("DImageButton", Panel2bc)
            Paneln_Craft:SetImage(v.Image)
            Paneln_Craft:SetPos(0, 0)
            Paneln_Craft:SetSize(150, Panel2bc:GetTall() - 10)
            Paneln_Craft.Paint = function(s, w, h)
                draw.RoundedBox(0, 0, 0, w, h - 10, Color(100, 100, 100, 100))
                draw.DrawText(v.Text .. " Timeleft: " .. tostring(math.Round(CurTime() - v.Timer)), "Default", Panel2bc:GetWide() * 0.05, 70, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                if math.Round(CurTime() - v.Timer) >= 0 then Panel2b:Remove() end
            end
        end
    end

    for i, new in SortedPairs(Tbl) do
        Paneln[i] = vgui.Create("DImageButton", Crafting.Panel3)
        Paneln[i]:SetText("")
        Paneln[i]:Dock(TOP)
        Paneln[i]:DockPadding(10, 0, 0, 10)
        Paneln[i].Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 100))
            draw.DrawText(new[1], "Default", Paneln[i]:GetWide() * 0.45, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        local itm = {}
        for k, v in pairs(Crafting.Table) do
            v.locked = false
        end

        Paneln[i].DoClick = function(self)
            for k, v in pairs(Crafting.Table) do
                text_to_glow = v.Where
                if IsValid(itm[k]) then return end
                itm[k] = AddItemPanel_2(v.Textation, v.func, v.gotob, new[1], v.img, k, Crafting.Panel5, CurTime() + v.timers + 1)
                v.locked = true
                grid:AddItem(itm[k])
            end
        end

        local img = Paneln[i]:Add("DImage")
        img:SetImage(new[2])
        img:Dock(LEFT)
        img:SetTall(32)
        img:SetWide(32)
        img:SetImageColor(Color(255, 255, 255))
    end
end

function GM:ScoreboardHide()
    gui.EnableScreenClicker(false)
    Crafting.Panel:Remove()
end