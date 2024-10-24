print("[gRust] Loaded")
local Scr_W, Scr_H = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "gAchivements.structure", function(oldWidth, oldHeight) Scr_W, Scr_H = ScrW(), ScrH() end)
surface.CreateFont("StringFont2", {
    font = "Roboto",
    size = 15,
    weight = 700
})

net.Receive("ForgiveMeInventory", function()
    local tbl = net.ReadTable()
    local vgui_New = vgui.Create("gRust_Panel")
    vgui_New:SetSize(Scr_W / 2 + 135, Scr_H / 2 + 240)
    vgui_New:Center()
    vgui_New:AddButton("Inventory", "grustorig/inventory.png", function(self, val, text)
        local grid = vgui.Create("DGrid", self)
        grid:SetPos(10, 30)
        grid:SetCols(7)
        grid:SetColWide(102)
        grid:SetRowHeight(102)
        for k, v in pairs(tbl) do
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
            print(v.Skins)
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

end)

hook.Add("OnSpawnMenuOpen", "Fuck", function()
    net.Start("SendInventory")
    net.SendToServer()
end)