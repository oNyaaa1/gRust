print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) Scr_W, Scr_H = ScrW(), ScrH() end)
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})

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
local vgui_New
net.Receive("ForgiveMeInventory", function()
    local tbln = net.ReadTable()
    if vgui_New then vgui_New:Remove() end
    vgui_New = vgui.Create("gRust_Panel")
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

    vgui_New:AddButton("Crafting", "grustorig/inventory.png", function(self, val, text)
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
                            Derma_Query("Craft?", "Craft:", "Yes", function()
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
                            Derma_Query("Craft?", "Craft:", "Yes", function()
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
    end)
end)

hook.Add("OnSpawnMenuOpen", "Fuck", function()
    net.Start("SendInventory")
    net.SendToServer()
end)