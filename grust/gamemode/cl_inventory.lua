local frame = nil
local lastwep = {}
local class = ""
local but = {}
local right
local inventory = inventory or {}
inventory.Test = inventory.Test or {}
if not Panel2 then Panel2 = {} end
local invw = {}
invw.SlotPos = 60
invw.Storage = 0
local slot = {}
local InitPostEntity = false
function SlotShy(btn)
    local slots = #slot + 1
    slot[slots] = {
        button = btn,
        slot = slots
    }
end

function SlotShutterSlot(slots, btn)
    slot[slots] = {
        button = btn,
        slot = slots
    }
end

function GetSlot_Slots(slots)
    for k, v in pairs(slot) do
        if v.slot == slots then return v.button end
    end
end

net.Receive("inventory_Test", function()
    inventory.Test = net.ReadTable()
    for k, v in pairs(inventory.Test) do
        SlotShy(v.class)
    end
end)

local function DoOne(inv)
    for i = 1, 5 do
        if IsValid(Panel2[i]) then Panel2[i]:Clear() end
    end

    for k, v in pairs(inv) do
        if IsValid(Panel2[k]) then
            SlotShutterSlot(tonumber(k), tostring(v.WepClass))
            local modelPanel = vgui.Create("DModelPanel", Panel2[k])
            modelPanel:SetSize(100, 100)
            modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
            function modelPanel:LayoutEntity(Entity)
                return
            end

            local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
            modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
            modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
            modelPanel.ColumnNumber = k
        end
    end
end

local framen = nil
net.Receive("grust_SendItOVa", function()
    local inv = net.ReadTable()
    if InitPostEntity == false then return end
    timer.Simple(0.5, function() DoOne(inv) end)
end)

local inv = function()
    if IsValid(frame) then return end
    local pnl = {}
    local scrw, scrh = ScrW(), ScrH()
    frame = vgui.Create("DPanel")
    frame:SetSize(580, 415)
    frame:SetPos(scrw * 0.286, scrh * 0.40)
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(80, 76, 70, 0)
        surface.DrawRect(0, 0, w, h)
    end

    local grid = vgui.Create("ThreeGrid", frame)
    grid:Dock(FILL)
    grid:DockMargin(4, 4, 4, 4)
    grid:InvalidateParent(true)
    grid:SetColumns(6)
    grid:SetHorizontalMargin(2)
    grid:SetVerticalMargin(2)
    local pnl = {}
    for i = 1, 24 do
        pnl[i] = vgui.Create("DPanel")
        pnl[i]:SetTall(100)
        pnl[i].Paint = function(s, w, h)
            surface.SetDrawColor(80, 76, 70, 121)
            surface.DrawRect(0, 0, w, h)
            for i = 1, 24 do
                surface.SetDrawColor(0, 0, 0, 128)
                surface.DrawOutlinedRect(0, 0, w, h, 3)
            end
        end

        grid:AddCell(pnl[i])
    end

    for k, v in pairs(inventory.Test) do
        local modelPanel = vgui.Create("DModelPanel", pnl[k])
        modelPanel:SetSize(pnl[k]:GetWide(), pnl[k]:GetTall())
        local fnd = string.find(v.Mdl, ".mdl")
        print(fnd)
        if fnd ~= nil then
            modelPanel:SetModel(v.Mdl)
        else
            modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
        end

        function modelPanel:LayoutEntity(Entity)
            return
        end

        local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
        modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
        modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
        modelPanel.DoClick = function()
            if IsValid(framen) then framen:Remove() end
            --[[if v.WepClass ~= "none" then
                if GetSlot_Slots(tonumber(k)) == nil then return end
                net.Start("inv_give")
                net.WriteString(GetSlot_Slots(tonumber(k)))
                net.SendToServer()
            end]]
            framen = vgui.Create("DPanel")
            framen:SetSize(580, 315)
            framen:SetPos(scrw * 0.286, scrh * 0.05)
            framen.Paint = function(self, w, h)
                surface.SetDrawColor(80, 76, 70, 121)
                surface.DrawRect(0, 0, w, h)
            end

            local DLabel = vgui.Create("DLabel", framen)
            DLabel:SetPos(10, 10)
            DLabel:SetFont("MyFont")
            DLabel:SetText("Name: " .. tostring(v.Name))
            DLabel:SizeToContents()
            local DLabel = vgui.Create("DLabel", framen)
            DLabel:SetPos(10, 40)
            DLabel:SetFont("MyFont")
            DLabel:SetText("Amount: " .. tostring(v.Amount))
            DLabel:SizeToContents()
        end

        modelPanel.DoRightClick = function()
            if v.WepClass ~= "none" then
                local menu = DermaMenu()
                for i = 1, 5 do
                    menu:AddOption("Slot " .. i .. " " .. v.WepClass, function()
                        SlotShutterSlot(tonumber(i), tostring(v.WepClass))
                        Panel2[i]:Clear()
                        local modelPanel = vgui.Create("DModelPanel", Panel2[i])
                        modelPanel:SetSize(Panel2[i]:GetWide() - 100, Panel2[i]:GetTall() - 100)
                        local fnd = string.find(v.Mdl, ".mdl")
                        if fnd then
                            modelPanel:SetModel(v.Mdl)
                        else
                            modelPanel:SetModel(weapons.Get(v.WepClass).WorldModel)
                        end

                        function modelPanel:LayoutEntity(Entity)
                            return
                        end

                        local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
                        modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
                        modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
                        modelPanel.ColumnNumber = k
                        modelPanel.DoClick = function()
                            if v.WepClass ~= "none" then
                                if GetSlot_Slots(tonumber(k)) == nil then return end
                                net.Start("inv_give")
                                net.WriteString(GetSlot_Slots(tonumber(i)))
                                net.SendToServer()
                            end
                        end
                        --local modelPanelnm = vgui.Create("DImageButton", Panel2[i])
                        -- modelPanelnm:SetSize(100, 100)
                        --modelPanelnm:SetImage(v.Mdl)
                        --
                    end)
                end

                menu:AddOption("Close", function() end)
                menu:Open()
            end
        end
    end
end

hook.Add("OnSpawnMenuOpen", "Context", function()
    gui.EnableScreenClicker(true)
    inv()
end)

-- inventory.Open()
hook.Add("OnSpawnMenuClose", "Context", function()
    gui.EnableScreenClicker(false)
    if IsValid(frame) then frame:Remove() end
    if IsValid(framen) then framen:Remove() end
end)

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudWeaponSelection"] = true,
}

hook.Add("HUDShouldDraw", "HideBinder", function(name) if hide[name] then return false end end)
local tblofcode = {}
function Rememeber(self, panels, bDoDrop, Command, x, y)
    tblofcode = {}
    if bDoDrop then
        local mypnl = vgui.GetHoveredPanel()
        for k, v in pairs(panels) do
            self:AddItem(v)
            for k2, v2 in pairs(inventory.Test) do
                if k2 == v.ColumnNumber then
                    --if mypnl == self and panels[1] == mypnl then
                    table.remove(inventory.Test, k2)
                    -- end
                end
            end
        end
    end
end

hook.Add("InitPostEntity", "RustInv", function()
    for i = 1, 6 do
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

    DoOne(inventory.Test)
end)

local tone_butn = 0
local cd = 0
hook.Add("PlayerButtonDown", "Buttondown", function(ply, button)
    if button == 27 then inv() end
    local butg = input.GetKeyName(button)
    if butg == "MWHEELUP" and cd <= CurTime() then
        if tone_butn < 0 then tone_butn = 6 end
        if tone_butn > 6 then tone_butn = 0 end
        tone_butn = tone_butn + 1
        if GetSlot_Slots(tonumber(tone_butn)) == nil then
            net.Start("inv_give")
            net.WriteString(GetSlot_Slots(1))
            net.SendToServer()
            return
        end

        if GetSlot_Slots(tonumber(tone_butn)) ~= nil then
            net.Start("inv_give")
            net.WriteString(GetSlot_Slots(tonumber(tone_butn)))
            net.SendToServer()
        end

        cd = CurTime() + 0.1
    end

    if butg == "MWHEELDOWN" and cd <= CurTime() then
        if tone_butn < 0 then tone_butn = 6 end
        if tone_butn > 6 then tone_butn = 0 end
        tone_butn = tone_butn - 1
        if GetSlot_Slots(tonumber(tone_butn)) == nil then
            net.Start("inv_give")
            net.WriteString(GetSlot_Slots(3))
            net.SendToServer()
            return
        end

        if GetSlot_Slots(tonumber(tone_butn)) ~= nil then
            net.Start("inv_give")
            net.WriteString(GetSlot_Slots(tonumber(tone_butn)))
            net.SendToServer()
        end

        cd = CurTime() + 0.1
    end

    if GetSlot_Slots(tonumber(butg)) then
        net.Start("inv_give")
        net.WriteString(GetSlot_Slots(tonumber(butg)))
        net.SendToServer()
    end
end)