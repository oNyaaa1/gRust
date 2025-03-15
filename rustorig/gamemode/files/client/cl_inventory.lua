print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) Scr_W, Scr_H = ScrW(), ScrH() end)
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
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
local vgui_New
net.Receive("ForgiveMeInventory", function()
    
    local tbln = net.ReadTable()
    if IsValid(vgui_New) then vgui_New:Remove() gui.EnableScreenClicker(false) end
    gui.EnableScreenClicker(true)
    vgui_New = vgui.Create("DPanel")
    vgui_New:SetSize(560, 480)
    vgui_New:SetPos(ScrW() / 2 * 0.65, ScrH() / 2 * 0.65)
    vgui_New:Droppable("gDrop")
    vgui_New.Paint = function(self, w, h)
        surface.SetDrawColor(80, 76, 70, 0)
        surface.DrawRect(0, 0, w, h)
    end

    local grid = vgui.Create("DGrid", vgui_New)
    grid:SetPos(10, 30)
    grid:SetCols(6)
    grid:SetColWide(90)
    grid:SetRowHeight(90)
    local DPanel = {}
    for i = 1, 30 do
        DPanel[i] = vgui.Create("DPanel")
        DPanel[i]:SetPos(2, 2)
        DPanel[i]:SetSize(85, 85)
        DPanel[i]:Droppable("gDrop")
        DPanel[i].Paint = function(s, w, h)
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
        end

        grid:AddItem(DPanel[i])
    end

    for k, v in pairs(tbln) do
        DPanel[k].Paint = function(s, w, h)
            --draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            surface.SetDrawColor(80, 76, 70, 180)
            surface.DrawRect(0, 0, w, h)
            draw.DrawText(tostring(v.Name) .. " +" .. tostring(v.Amount), "StringFont2", 0, h - 15, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        end

        local DModelPanel = vgui.Create('DModelPanel', DPanel[k])
        DModelPanel:SetModel(v.Mdl)
        DModelPanel:Dock(FILL)
        if v.Skins then DModelPanel.Entity:SetSkin(v.Skins) end
        local PrevMins, PrevMaxs = DModelPanel.Entity:GetRenderBounds()
        DModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.8, 0.8, 0.5))
        DModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
        function DModelPanel:LayoutEntity(ent)
            if self:GetParent().Hovered then ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0)) end
        end

        DModelPanel.DoClick = function(val2) print(v.Mdl, v.Name, val2:GetValue()) end
    end
    --[[vgui_New = vgui.Create("gRust_Panel")
    vgui_New:SetSize(Scr_W / 2 + 135, Scr_H / 2 + 240)
    vgui_New:Center()
    vgui_New:AddButton("Inventory", "grustorig/inventory.png", function(self, val, text)
        local grid = vgui.Create("DGrid", self)
        grid:SetPos(10, 30)
        grid:SetCols(7)
        grid:SetColWide(102)
        grid:SetRowHeight(102)
        for k, v in pairs(tbln) do
            local DPanel = vgui.Create("DPanel")
            DPanel:SetPos(0, 0) -- Set the position of the panel
            DPanel:SetSize(100, 100)
            DPanel.Paint = function(s, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                draw.DrawText(tostring(v.Name) .. " +" .. tostring(v.Amount), "StringFont2", 0, h - 15, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end

            self.DModelPanel = vgui.Create('DModelPanel', DPanel)
            self.DModelPanel:SetModel(v.Mdl)
            self.DModelPanel:Dock(FILL)
            if v.Skins then self.DModelPanel.Entity:SetSkin(v.Skins) end
            local PrevMins, PrevMaxs = self.DModelPanel.Entity:GetRenderBounds()
            self.DModelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5))
            self.DModelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
            function self.DModelPanel:LayoutEntity(ent)
                if self:GetParent().Hovered then ent:SetAngles(Angle(0, ent:GetAngles().y + 2, 0)) end
            end

            self.DModelPanel.DoClick = function(val2) print(v.Mdl, v.Name, val2:GetValue()) end
            grid:AddItem(DPanel)
        end
    end)

    vgui_New:AddButton("Crafting2", "grustorig/inventory.png", function(self, val, text)
        local DPanel = vgui.Create("DPanel", self)
        DPanel:Dock(LEFT) -- Set the position of the panel
        DPanel:SetSize(200, 100)
        DPanel.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) end
        local grid = vgui.Create("DGrid", self)
        grid:Dock(LEFT)
        grid:SetCols(5)
        grid:SetColWide(102)
        grid:SetRowHeight(102)
        for k, v in ipairs(Tbl) do
            self.button = vgui.Create("DButton", DPanel)
            self.button:Dock(TOP)
            self.button:SetText("")
            self.button:SetTall(40)
            self.button.Paint = function(s, w, h)
                if not s:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(52, 152, 219))
                else
                    draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185))
                end

                draw.DrawText(v[1], "Trebuchet24", w * 0.2, h * 0.2, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end

            local modelPanelnm = vgui.Create("DImageButton", self.button)
            modelPanelnm:SetSize(32, 32)
            modelPanelnm:SetImage(v[2])
            self.button.DoClick = function(val)
                if not DPanel2 then DPanel2 = {} end
                for a, b in pairs(GMRustTable) do
                    if not DPanel2[a] then DPanel2[a] = {} end
                    if IsValid(DPanel2[a]) then DPanel2[a]:Remove() end
                end

                for a, b in pairs(GMRustTable) do
                    if v[1] == b.Where then
                        local bp = BluePrint_Get(b.name)
                        DPanel2[a] = vgui.Create("DPanel")
                        DPanel2[a]:SetPos(0, 0)
                        DPanel2[a]:SetSize(100, 100)
                        DPanel2[a].Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0)) end
                        self.button2 = vgui.Create("DButton", DPanel2[a])
                        self.button2:Dock(TOP)
                        self.button2:SetText("")
                        self.button2:SetTall(98)
                        self.button2.Paint = function(s, w, h)
                            draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185))
                            draw.DrawText(tostring(bp.name), "StringFont2", 0, h - 15, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                        end

                        self.button2.DoClick = function()
                            local str = "Craft: "
                            for k, v in pairs(b.need) do
                                str = str .. "Need: " .. v.txt .. " Amount: " .. v.amt
                            end

                            Derma_Query(str, "Craft?", "Yes", function()
                                net.Start("Craft_BP")
                                net.WriteString(b.name)
                                net.SendToServer()
                            end, "No", function() end)
                        end

                        local modelPanel = vgui.Create("DModelPanel", self.button2)
                        modelPanel:SetSize(self.button2:GetWide(), self.button2:GetTall())
                        local fnd = string.find(b.Mdl, ".mdl")
                        if fnd == nil then
                            modelPanel:SetModel("models/environment/misc/loot_bag.mdl")
                        else
                            modelPanel:SetModel(b.Mdl) --weapons.Get(v.WepClass).WorldModel or "")
                        end

                        function modelPanel:LayoutEntity(Entity)
                            return
                        end

                        modelPanel.DoClick = function()
                            local str = "Craft: "
                            for k, v in pairs(b.need) do
                                str = str .. "Need: " .. v.txt .. " Amount: " .. v.amt
                            end

                            Derma_Query(str, "Craft?", "Yes", function()
                                net.Start("Craft_BP")
                                net.WriteString(b.name)
                                net.SendToServer()
                            end, "No", function() end)
                        end

                        local PrevMins, PrevMaxs = modelPanel.Entity:GetRenderBounds()
                        modelPanel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.50, 0.50, 0.15) + Vector(0, 0, 5))
                        modelPanel:SetLookAt((PrevMaxs + PrevMins) / 2)
                        grid:AddItem(DPanel2[a])
                    end
                end
            end
        end
    end)]]
end)

hook.Add("OnSpawnMenuOpen", "Fuck", function()
    net.Start("SendInventory")
    net.SendToServer()
end)

hook.Add("OnSpawnMenuClose", "Fuck", function() if IsValid(vgui_New) then vgui_New:Remove() gui.EnableScreenClicker(false) end end)
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