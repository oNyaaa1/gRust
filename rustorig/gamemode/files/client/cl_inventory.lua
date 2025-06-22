print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) Scr_W, Scr_H = ScrW(), ScrH() end)
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})
surface.CreateFont("StringFont3", {
    font = "Roboto",
    size = 19,
    weight = 700
})

local Panel2 = {}
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
local mainBG = nil
net.Receive("ForgiveMeInventory", function()
    local inv = net.ReadTable()
    if IsValid(mainBG) then mainBG:Remove() end
    mainBG = vgui.Create("DPanel")
    mainBG:SetSize(Scr_W, Scr_H)
    mainBG.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(mainBG, 0)
        draw.DrawText("INVENTORY", "StringFont3", Scr_W * 0.335, Scr_H * 0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local vgui_New = vgui.Create("DFrame", mainBG)
    vgui_New:SetSize(Scr_W * 0.35, Scr_H * 0.4)
    vgui_New:SetPos(Scr_W * 0.328, Scr_H * 0.45)
    vgui_New:SetTitle("")
    vgui_New:MakePopup()
    vgui_New:ShowCloseButton(false)
    vgui_New:SetDraggable(false)
    vgui_New.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(48, 48, 48, 0)) end
    local grid = vgui.Create("ThreeGrid", vgui_New)
    grid:Dock(FILL)
    grid:DockMargin(4, 0, 4, 0)
    grid:InvalidateParent(true)
    grid:SetColumns(7)
    grid:SetHorizontalMargin(2)
    grid:SetVerticalMargin(2)
    local pnl = {}
    for i = 1, 28 do
        pnl[i] = vgui.Create("DPanel")
        pnl[i]:SetTall(80)
        pnl[i].Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
        end

        grid:AddCell(pnl[i])
    end

    for k, v in pairs(inv) do
        pnl[k].Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
            draw.DrawText(tostring(v.Name) .. " +" .. tostring(v.Amount), "StringFont2", 0, h - 15, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end

        local DModelPanel = vgui.Create('DModelPanel', pnl[k])
        DModelPanel:SetModel(v.Mdl)
        DModelPanel:Dock(FILL)
        if v.Skins then DModelPanel.Entity:SetSkin(v.Skins) end
        local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
        DModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
        DModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
        function DModelPanel:LayoutEntity(ent)
            if self:GetParent().Hovered then ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0)) end
        end

        DModelPanel.DoClick = function(val2) print(v.Mdl, v.Name, val2:GetValue()) end
    end

    invw.SlotPos = 15
    for i = 1, 6 do
        Panel2[i] = vgui.Create("DPanel", mainBG)
        Panel2[i]:SetPos(ScrW() / 2 * 0.65 + invw.SlotPos, ScrH() / 2 * 1.75)
        Panel2[i]:SetText("")
        Panel2[i]:SetSize(80, 80)
        Panel2[i]:Droppable("gDrop")
        Panel2[i].Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
        end

        invw.SlotPos = invw.SlotPos + 90
    end
end)

hook.Add("OnSpawnMenuOpen", "Fuck", function()
    net.Start("SendInventory")
    net.SendToServer()
end)

hook.Add("OnSpawnMenuClose", "Fuck", function()
    if IsValid(mainBG) then
        mainBG:Remove()
        gui.EnableScreenClicker(false)
    end
end)

hook.Add("InitPostEntity", "RustInv", function()
    for i = 1, 6 do
        Panel2[i] = vgui.Create("DPanel")
        Panel2[i]:SetPos(ScrW() / 2 * 0.65 + invw.SlotPos, ScrH() / 2 * 1.75)
        Panel2[i]:SetText("")
        Panel2[i]:SetSize(80, 80)
        Panel2[i]:Droppable("gDrop")
        Panel2[i].Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
        end

        invw.SlotPos = invw.SlotPos + 90
    end
    --[[for i = 1, 6 do
       frame = vgui.Create("DPanel")
        frame:SetSize(100, 100)
        frame:SetPos(ScrW() / 2 * 0.5 + invw.SlotPos, ScrH() / 2 * 1.75)
        frame.Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 121)
            surface.DrawRect(0, 0, w, h)
        end
        Panel2[i] = vgui.Create("DPanel", frame)
        Panel2[i]:SetText("")
        Panel2[i]:SetSize(200, 200)
        Panel2[i]:Droppable("gDrop")
        Panel2[i].Paint = function(self, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
        end

        Panel2[i].nClass = {
            Class = "",
            Slotx = invw.SlotPos
        }

        invw.Storage = invw.Storage + 1
        if invw.Storage <= 5 then invw.SlotPos = invw.SlotPos + 120 end
        InitPostEntity = true
    end

    DoOne(inventory.Test)]]
end)