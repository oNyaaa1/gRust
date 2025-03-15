print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) Scr_W, Scr_H = ScrW(), ScrH() end)
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})

local Panel2 = {}
local Panel
local invw = {}
invw.SlotPos = 15
invw.Storage = 0
local Tbl = {}
Tbl[1] = {GetLanguage("Favorite"), "icons/favorite_inactive.png"}
Tbl[2] = {GetLanguage("Construction"), "icons/construction.png"}
Tbl[3] = {GetLanguage("Items"), "icons/extinguish.png"}
Tbl[4] = {GetLanguage("Resources"), "icons/servers.png"}
Tbl[5] = {GetLanguage("Clothing"), "icons/servers.png"}
Tbl[6] = {GetLanguage("Tools"), "icons/tools.png"}
Tbl[7] = {GetLanguage("Medical"), "icons/medical.png"}
Tbl[8] = {GetLanguage("Weapons"), "icons/weapon.png"}
Tbl[9] = {GetLanguage("Ammo"), "icons/ammo.png"}
Tbl[11] = {GetLanguage("Fun"), "icons/servers.png"}
Tbl[12] = {GetLanguage("Other"), "icons/electric.png"}
local vgui_New
local text_to_glow = ""
local Paneln_Crafttb = {}
local DLabel = nil
surface.CreateFont("MyFont", {
    font = "Arial",
    extended = false,
    size = 23,
    weight = 500,
})

Crafting2 = Crafting2 or {}
local DLabel2 = nil
Panel2b = nil
Panel2bc = nil
Panel2bcc = nil
Panel5 = nil
net.Receive("gRust_Queue_Crafting2_Timer", function()
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
            local Panel2basdsad = vgui.Create("DPanel", Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Panel5:GetTall())
            local Panel2bc = vgui.Create("DPanel", Panel2basdsad)
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
function AddItemPanel_2(txt, Craft, CancelCraft, where, img, num, newpnl, timers, rightpnl, info, inf, amt, inf2, amt2, your_amt, modelz)
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
                if IsValid(Panel2b) then Panel2b:Remove() end
                if IsValid(DLabel) then DLabel:Remove() end
                if IsValid(Panel2bc) then Panel2bc:Remove() end
                if IsValid(DLabel2) then DLabel2:Remove() end
                if IsValid(Panel2bcc) then Panel2bcc:Remove() end
                if IsValid(Panel2bcn) then Panel2bcn:Remove() end
                Panel2b = vgui.Create("DPanel", rightpnl)
                Panel2b:Dock(TOP)
                Panel2b:SetSize(150, newpnl:GetTall())
                Panel2b.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(100, 100, 100, 0)) end
                DLabel = vgui.Create("DLabel", rightpnl)
                DLabel:SetPos(Panel2b:GetWide() * 1.5, 40)
                DLabel:SetFont("MyFont")
                DLabel:SetText(txt)
                DLabel:SizeToContents()
                Panel2bc = vgui.Create("DPanel", rightpnl)
                Panel2bc:Dock(TOP)
                Panel2bc:SetSize(150, 250)
                Panel2bc.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(0, 255, 0, 0)) end
                DLabel2 = vgui.Create("DLabel", Panel2bc)
                DLabel2:SetPos(1, 10)
                DLabel2:SetFont("MyFont")
                DLabel2:SetText(info)
                DLabel2:SizeToContents()
                Panel2bcc = vgui.Create("DPanel", rightpnl)
                Panel2bcc:Dock(TOP)
                Panel2bcc:SetSize(150, 150)
                Panel2bcc.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(255, 0, 0, 0)) end
                local AppList = vgui.Create("DListView", Panel2bcc)
                AppList:Dock(FILL)
                AppList:SetMultiSelect(false)
                AppList:AddColumn("Need")
                AppList:AddColumn("Item Type")
                AppList:AddColumn("Your Wood/Amount")
                AppList:AddColumn("Your Amount")
                if inf2 ~= "" then
                    AppList:AddLine(amt, inf, your_amt .. "/" .. amt, your_amt)
                    AppList:AddLine(amt, inf2, your_amt .. "/" .. amt2, your_amt)
                else
                    AppList:AddLine(amt, inf, your_amt .. "/" .. amt, your_amt)
                end

                AppList.OnRowSelected = function(lst, index, pnl) print("Selected " .. pnl:GetColumnText(1) .. " ( " .. pnl:GetColumnText(2) .. " ) at index " .. index) end
                Panel2bcn = vgui.Create("DPanel", rightpnl)
                Panel2bcn:Dock(BOTTOM)
                Panel2bcn:SetSize(150, 100)
                Panel2bcn.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h - 10, Color(0, 255, 0, 0)) end
                Paneln_Craft = vgui.Create("DButton", Panel2bcn)
                Paneln_Craft:SetText("Craft")
                Paneln_Craft:SetFont("MyFont")
                Paneln_Craft:SetPos(Panel2bcn:GetWide() * 2.8, Panel2bcn:GetTall() * 0.2)
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

local function Crafting2()
    gui.EnableScreenClicker(true)
    Panel = vgui.Create("DPanel")
    Panel:SetPos(50, 50)
    Panel:SetSize(ScrW() - 100, ScrH() - 300)
    Panel.Paint = function(s, w, h)
        surface.SetDrawColor(26, 25, 22, 0)
        surface.DrawRect(0, 0, w, h)
    end

    Panel:Center()
    Panel2 = vgui.Create("DPanel", Panel)
    Panel2:SetPos(0, 1)
    Panel2:SetSize(Panel:GetWide() / 2 + 200, Panel:GetTall())
    Panel2.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 0)) end
    Panel3 = vgui.Create("DPanel", Panel2)
    Panel3:SetPos(0, 1)
    Panel3:SetSize(Panel2:GetWide() / 2 - 150, Panel2:GetTall() - 100)
    Panel3.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 0)) end
    Panel4 = vgui.Create("DPanel", Panel2)
    Panel4:SetPos(Panel3:GetWide() + 10, 1)
    Panel4:SetSize(Panel2:GetWide(), Panel2:GetTall() - 100)
    Panel4.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    Panel5 = vgui.Create("DPanel", Panel2)
    Panel5:Dock(BOTTOM)
    Panel5:SetSize(Panel2:GetWide(), Panel2:GetTall() - 510)
    Panel5.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    Panel6 = vgui.Create("DPanel", Panel)
    Panel6:Dock(RIGHT)
    Panel6:SetSize(Panel2:GetWide() / 2 + 60, Panel2:GetTall() - 510)
    Panel6.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(74, 74, 74, 100)) end
    local grid = vgui.Create("DGrid", Panel4)
    grid:SetPos(10, 30)
    grid:SetCols(5)
    grid:SetColWide(102)
    grid:SetRowHeight(102)
    local Paneln = {}
    if table.Count(Paneln_Crafttb) > 0 then
        for k, v in pairs(Paneln_Crafttb) do
            local Panel2basdsad = vgui.Create("DPanel", Panel5)
            Panel2basdsad:Dock(LEFT)
            Panel2basdsad:SetSize(150, Panel5:GetTall())
            local Panel2bc = vgui.Create("DPanel", Panel2basdsad)
            Panel2bc:SetSize(150, 150)
            Panel2bc:SetSize(150, Panel2basdsad:GetTall())
            local modelPanel = vgui.Create("DModelPanel", Panel2bc)
            modelPanel:SetSize(150, Panel2bc:GetTall() - 10)
            --modelPanel:SetSize(pnl[k]:GetWide(), pnl[k]:GetTall())
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
        Paneln[i] = vgui.Create("DImageButton", Panel3)
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
                if v.need2 == nil then
                    itm[k] = AddItemPanel_2(v.name, v.func, v.gotob, new[1], v.img, k, Panel5, CurTime() + v.timers + 1, Panel6, v.Infomation, v.need[1].txt, v.need[1].amt, "", "", tostring(LocalPlayer():GetNWFloat("wood", 0)), v.Mdl)
                else
                    itm[k] = AddItemPanel_2(v.name, v.func, v.gotob, new[1], v.img, k, Panel5, CurTime() + v.timers + 1, Panel6, v.Infomation, v.need[1].txt, v.need[1].amt, v.need[1].txt, v.need[1].amt, tostring(LocalPlayer():GetNWFloat("wood", 0)), v.Mdl)
                end

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

hook.Add("ScoreboardShow", "Scoreboard_Open", function()
    Crafting2()
    return true
end)

hook.Add("ScoreboardHide", "Scoreboard_Close", function()
    if IsValid(Panel) then Panel:Remove() end
    gui.EnableScreenClicker(false)
    return true
end)