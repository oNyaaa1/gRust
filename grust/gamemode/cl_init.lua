include("shared.lua")
include("ui/threegrid.lua")
include("sharity.lua")
include("cl_inventory.lua")
include("escmenu.lua")
include("circles.lua")
include("radialmenu.lua")
local cleared = {}
local once = false
surface.CreateFont("StringFont", {
    font = "Roboto",
    size = 23,
    weight = 700
})

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
net.Receive("Sent_Vood", function()
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
end)

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
local text_to_glow = ""
local Paneln_Crafttb = {}
local DLabel = nil
surface.CreateFont("MyFont", {
    font = "Arial",
    extended = false,
    size = 23,
    weight = 500,
})

local DLabel2 = nil
Crafting.Panel2b = nil
Crafting.Panel2bc = nil
Crafting.Panel2bcc = nil
net.Receive("gRust_Queue_Crafting_Timer", function()
    local timerz = net.ReadFloat()
    local img = net.ReadString()
    local txt = net.ReadString()
    local num = net.ReadFloat()
    local fndnum = net.ReadFloat()
    Paneln_Crafttb[#Paneln_Crafttb + 1] = {
        pnl = Paneln_Craft,
        Image = img,
        Text = txt,
        Timer = timerz,
    }

    if table.Count(Paneln_Crafttb) > 0 then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2basdsad = vgui.Create("XeninUI.Panel", Crafting.Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Crafting.Panel5:GetTall())
            local Panel2bc = vgui.Create("XeninUI.Panel", Panel2basdsad)
            Panel2bc:SetSize(150, 150)
            Panel2bc:SetSize(150, Panel2basdsad:GetTall())
            local modelPanel = vgui.Create("DModelPanel", Panel2bc)
            modelPanel:SetSize(150, Panel2bc:GetTall() - 10)
            local fnd = string.find(v.Image, ".mdl")
            if fnd ~= nil then
                modelPanel:SetModel(v.Image)
            else
                modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
            end

            function modelPanel:LayoutEntity(Entity)
                return
            end

            local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
            modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
        end
    end
end)

local Panelnb = {}
function AddItemPanel_2(txt, Craft, CancelCraft, where, img, num, newpnl, timers, rightpnl, info, inf, amt, your_amt, modelz)
    for k, v in pairs(GMRustTable) do
        if v.Where == where and v.name == txt then
            Panelnb[num] = vgui.Create("DModelPanel")
            Panelnb[num].Text = v.name
            Panelnb[num].Clause = v.Where
            Panelnb[num].locked = false
            Panelnb[num]:SetText("")
            Panelnb[num]:SetSize(100, 100)
            Panelnb[num]:SetModel(modelz)
            print(modelz)
            Panelnb[num].LayoutEntity = function(Entity) return end
            local PrevMins, PrevMaxs = Panelnb[num].Entity:GetRenderBounds()
            Panelnb[num]:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            Panelnb[num]:SetLookAt((PrevMaxs + PrevMins) / 2)
            Panelnb[num].ColumnNumber = k
            local time = CurTime() + 60
            Panelnb[num].DoClick = function()
                if IsValid(Crafting.Panel2b) then Crafting.Panel2b:Remove() end
                if IsValid(DLabel) then DLabel:Remove() end
                if IsValid(Crafting.Panel2bc) then Crafting.Panel2bc:Remove() end
                if IsValid(DLabel2) then DLabel2:Remove() end
                if IsValid(Crafting.Panel2bcc) then Crafting.Panel2bcc:Remove() end
                if IsValid(Crafting.Panel2bcn) then Crafting.Panel2bcn:Remove() end
                Crafting.Panel2b = vgui.Create("XeninUI.Panel", rightpnl)
                Crafting.Panel2b:Dock(TOP)
                Crafting.Panel2b:SetSize(150, newpnl:GetTall())
                Crafting.Panel2b.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(100, 100, 100, 0)) end
                DLabel = vgui.Create("DLabel", rightpnl)
                DLabel:SetPos(Crafting.Panel2b:GetWide() * 1.5, 40)
                DLabel:SetFont("MyFont")
                DLabel:SetText(txt)
                DLabel:SizeToContents()
                Crafting.Panel2bc = vgui.Create("XeninUI.Panel", rightpnl)
                Crafting.Panel2bc:Dock(TOP)
                Crafting.Panel2bc:SetSize(150, 250)
                Crafting.Panel2bc.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(0, 255, 0, 0)) end
                DLabel2 = vgui.Create("DLabel", Crafting.Panel2bc)
                DLabel2:SetPos(1, 10)
                DLabel2:SetFont("MyFont")
                DLabel2:SetText(info)
                DLabel2:SizeToContents()
                Crafting.Panel2bcc = vgui.Create("XeninUI.Panel", rightpnl)
                Crafting.Panel2bcc:Dock(TOP)
                Crafting.Panel2bcc:SetSize(150, 150)
                Crafting.Panel2bcc.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(255, 0, 0, 0)) end
                local AppList = vgui.Create("DListView", Crafting.Panel2bcc)
                AppList:Dock(FILL)
                AppList:SetMultiSelect(false)
                AppList:AddColumn("Need")
                AppList:AddColumn("Item Type")
                AppList:AddColumn("Your Wood/Amount")
                AppList:AddColumn("Your Amount")
                AppList:AddLine(amt, inf, your_amt .. "/" .. amt, your_amt)
                AppList.OnRowSelected = function(lst, index, pnl) print("Selected " .. pnl:GetColumnText(1) .. " ( " .. pnl:GetColumnText(2) .. " ) at index " .. index) end
                Crafting.Panel2bcn = vgui.Create("XeninUI.Panel", rightpnl)
                Crafting.Panel2bcn:Dock(BOTTOM)
                Crafting.Panel2bcn:SetSize(150, 100)
                Crafting.Panel2bcn.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(0, 255, 0, 0)) end
                Paneln_Craft = vgui.Create("DButton", Crafting.Panel2bcn)
                Paneln_Craft:SetText("Craft")
                Paneln_Craft:SetFont("MyFont")
                Paneln_Craft:SetPos(Crafting.Panel2bcn:GetWide() * 2.8, Crafting.Panel2bcn:GetTall() * 0.2)
                Paneln_Craft:SetWide(100)
                Paneln_Craft:SetTall(50)
                Paneln_Craft.DoClick = function()
                    if not LocalPlayer():HasEnoughVood(amt) and GetConVar("grust_debug") == 0 then
                        LocalPlayer():PrintMessage(HUD_PRINTCENTER, "Cannot afford")
                        return
                    end

                    Craft(Panelnb[num].Text, num)
                end
            end

            Panelnb[num].DoRightClick = function() CancelCraft(Panelnb[num].Text) end
        end
    end
    return Panelnb[num]
end

function GM:ScoreboardShow()
    gui.EnableScreenClicker(true)
    Crafting.Panel = vgui.Create("XeninUI.Panel")
    Crafting.Panel:SetPos(50, 50)
    Crafting.Panel:SetSize(ScrW() - 100, ScrH() - 300)
    Crafting.Panel.Paint = function(s, w, h)
        surface.SetDrawColor(26, 25, 22, 0)
        surface.DrawRect(0, 0, w, h)
    end

    Crafting.Panel:Center()
    Crafting.Panel2 = vgui.Create("XeninUI.Panel", Crafting.Panel)
    Crafting.Panel2:SetPos(0, 1)
    Crafting.Panel2:SetSize(Crafting.Panel:GetWide() / 2 + 200, Crafting.Panel:GetTall())
    Crafting.Panel3 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel3:SetPos(0, 1)
    Crafting.Panel3:SetSize(Crafting.Panel2:GetWide() / 2 - 150, Crafting.Panel2:GetTall() - 100)
    Crafting.Panel3.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 0)) end
    Crafting.Panel4 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel4:SetPos(Crafting.Panel3:GetWide() + 10, 1)
    Crafting.Panel4:SetSize(Crafting.Panel2:GetWide(), Crafting.Panel2:GetTall() - 100)
    Crafting.Panel4.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    Crafting.Panel5 = vgui.Create("XeninUI.Panel", Crafting.Panel2)
    Crafting.Panel5:Dock(BOTTOM)
    Crafting.Panel5:SetSize(Crafting.Panel2:GetWide(), Crafting.Panel2:GetTall() - 510)
    Crafting.Panel5.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    Crafting.Panel6 = vgui.Create("XeninUI.Panel", Crafting.Panel)
    Crafting.Panel6:Dock(RIGHT)
    Crafting.Panel6:SetSize(Crafting.Panel2:GetWide() / 2 + 60, Crafting.Panel2:GetTall() - 510)
    Crafting.Panel6.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    local grid = vgui.Create("DGrid", Crafting.Panel4)
    grid:SetPos(10, 30)
    grid:SetCols(5)
    grid:SetColWide(102)
    grid:SetRowHeight(102)
    local Paneln = {}
    if table.Count(Paneln_Crafttb) > 0 then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2basdsad = vgui.Create("XeninUI.Panel", Crafting.Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Crafting.Panel5:GetTall())
            local Panel2bc = vgui.Create("XeninUI.Panel", Panel2basdsad)
            Panel2bc:SetSize(150, 150)
            Panel2bc:SetSize(150, Panel2basdsad:GetTall())
            local modelPanel = vgui.Create("DModelPanel", Panel2bc)
            modelPanel:SetSize(150, Panel2bc:GetTall() - 10)
            //modelPanel:SetSize(pnl[k]:GetWide(), pnl[k]:GetTall())
            local fnd = string.find(v.Image, ".mdl")
            if fnd ~= nil then
                modelPanel:SetModel(v.Image)
            else
                modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
            end

            function modelPanel:LayoutEntity(Entity)
                return
            end

            local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
            modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
            modelPanel.Paint = function(s, w, h)
                print(math.Round(CurTime() - v.Timer))
                draw.RoundedBox(0, 0, 0, w, h - 10, Color(74, 74, 74, 100))
                draw.DrawText(v.Text .. " Timeleft: " .. tostring(math.Round(CurTime() - v.Timer)), "Default", Panel2bc:GetWide() * 0.05, 70, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                if math.Round(CurTime() - v.Timer) >= 0 then Panel2basdsad:Remove() end
            end
        end
    end

    for i, new in SortedPairs(Tbl) do
        Paneln[i] = vgui.Create("DImageButton", Crafting.Panel3)
        Paneln[i]:SetText("")
        Paneln[i]:Dock(TOP)
        Paneln[i]:SetTall(45)
        Paneln[i]:DockPadding(22, 0, 0, 2)
        --Paneln[i]:DockMargin(11, 19, 10, 0)
        Paneln[i].Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 110))
            draw.DrawText(new[1], "Default", Paneln[i]:GetWide() * 0.45, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        local itm = {}
        for k, v in pairs(GMRustTable) do
            v.locked = false
        end

        Paneln[i].DoClick = function(self)
            for k, v in pairs(Panelnb) do
                if IsValid(v) then v:Remove() end
            end

            table.Empty(Panelnb)
            for k, v in pairs(GMRustTable) do
                text_to_glow = v.Where
                if IsValid(itm[k]) then return end
                itm[k] = AddItemPanel_2(v.name, v.func, v.gotob, new[1], v.img, k, Crafting.Panel5, CurTime() + v.timers + 1, Crafting.Panel6, v.Infomation, v.need.txt, v.need.amt, tostring(LocalPlayer():GetNWFloat("wood", 0)), v.Mdl)
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
    if IsValid(Crafting.Panel) then Crafting.Panel:Remove() end
end
--[[jit.attach(function(fn)
    local source = jit.util.funcinfo(fn)
    local sn = source.source
    if not table.HasValue(cleared, sn) then cleared[#cleared + 1] = sn end
    if source == nil or not table.HasValue(cleared, sn) then print("bypass", sn) end
end, "bc")

timer.Simple(5, function()
    net.Start("CheckTheFiles")
    net.WriteString("FileCheck")
    net.WriteTable(cleared)
    net.SendToServer()
    if #cleared == 0 and once == false then
        once = true
        net.Start("CheckTheFiles")
        net.WriteString("BanMe")
        net.WriteTable(cleared)
        net.SendToServer()
    end
end)]]