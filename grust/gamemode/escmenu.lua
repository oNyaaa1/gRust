local gRust = {}
local TitleBanner = Material("ui/banner.png", "smooth")
local function LeftPnl(pnl)
    local LeftPanel = vgui.Create("Panel", pnl)
    LeftPanel:Dock(LEFT)
    LeftPanel:SetWide(ScrH() * 0.45)
    LeftPanel:DockMargin(ScrH() * 0.1, 0, 0, 0)
    LeftPanel:DockPadding(0, ScrH() * 0.1, 0, 0)
    LeftPanel.Paint = function(me, w, h)
        surface.SetDrawColor(0, 0, 255, 255)
        surface.DrawRect(0, 0, w, h)
    end

    local MainPanel = vgui.Create("Panel", pnl)
    MainPanel:Dock(FILL)
    MainPanel:SetWide(ScrH() * 0.5)
    MainPanel:DockMargin(ScrH() * 0.05, 0, 0, 0)
    do
        local Spacing = 0
        local CurrentPanel
        LeftPanel.AddButton = function(me, text, pcb)
            local btn = me:Add("DButton")
            btn:SetText(text)
            btn:SetFont("Default")
            btn:Dock(TOP)
            btn:SetContentAlignment(4)
            btn:SetTall(ScrH() * 0.05)
            btn:SetTextColor(Color(255, 0, 0,255))
            btn:DockMargin(0, Spacing, 0, 0)
            Spacing = 0
            btn.Paint = function(me, w, h)
                if me:IsHovered() then
                    me:SetTextColor(Color(255, 0, 0))
                else
                    me:SetTextColor(Color(0, 255, 0, 200))
                end
            end

            btn.DoClick = function()
                if isfunction(pcb) then
                    pcb()
                else
                    if IsValid(CurrentPanel) then
                        if CurrentPanel:GetClassName() == pcb then
                            CurrentPanel:Remove()
                            return
                        else
                            CurrentPanel:Remove()
                        end
                    end

                    if not vgui.GetControlTable(pcb) then return end -- Panel doesn't exist
                    CurrentPanel = MainPanel:Add(pcb)
                    CurrentPanel:Dock(FILL)
                    OpenTab = pcb
                end
            end
        end

        if OpenTab then
            CurrentPanel = MainPanel:Add(OpenTab)
            CurrentPanel:Dock(FILL)
        end

        local Title = LeftPanel:Add("DPanel")
        Title:Dock(TOP)
        Title:DockMargin(0, 0, 0, ScrH() * 0.125)
        LeftPanel.PerformLayout = function(me, w, h) Title:SetTall(w * 0.2) end
        Title.Paint = function(me, w, h)
            surface.SetMaterial(TitleBanner)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        LeftPanel:AddButton("RESUME", gRust.ClosePauseMenu)
        Spacing = ScrH() * 0.045
        LeftPanel:AddButton("NEWS")
        LeftPanel:AddButton("SKINS")
        LeftPanel:AddButton("gRust")
        Spacing = ScrH() * 0.045
        LeftPanel:AddButton("OPTIONS", "gRust.Options")
        LeftPanel:AddButton(
            "LEGACY MENU",
            function()
                gRust.ClosePauseMenu()
                gui.ActivateGameUI()
            end
        )

        Spacing = ScrH() * 0.045
        LeftPanel:AddButton(
            "SUICIDE",
            function()
                RunConsoleCommand("kill")
                gRust.ClosePauseMenu()
            end
        )

        LeftPanel:AddButton("QUIT", function() Derma_Query("ARE YOU SURE YOU WANT TO LEAVE?", "Confirm", "Yes", function() RunConsoleCommand("disconnect") end, "No", function() end) end)
    end

    local RightPanel = vgui.Create("Panel", pnl)
    RightPanel:Dock(RIGHT)
    RightPanel:SetWide(ScrH() * 0.075)
    RightPanel:DockMargin(0, 0, 0, 0)
    RightPanel.Paint = function(me, w, h)
        surface.SetDrawColor(255, 0, 0)
        --surface.DrawRect(0, 0, w, h)
    end

    do
        RightPanel.AddButton = function(me, icon, url)
            local btn = me:Add("DButton")
            btn:Dock(BOTTOM)
            btn:SetText("")
            btn.Paint = function(me, w, h)
                surface.SetMaterial(icon)
                if me:IsHovered() then
                    surface.SetDrawColor(225, 225, 225)
                else
                    surface.SetDrawColor(200, 200, 200)
                end

                surface.DrawTexturedRect(0, 0, w, h)
            end

            btn.DoClick = function(me) gui.OpenURL(url) end
        end

        local AvatarSpacing = 16
        local Avatar = RightPanel:Add("AvatarImage")
        Avatar:SetPlayer(LocalPlayer())
        Avatar:Dock(TOP)
        Avatar:DockMargin(AvatarSpacing, AvatarSpacing, AvatarSpacing, 0)
        local AvatarClick = Avatar:Add("DButton")
        AvatarClick:Dock(FILL)
        AvatarClick.Paint = function() return true end
        AvatarClick.DoClick = function() gui.OpenURL("https://steamcommunity.com/profiles/" .. LocalPlayer():SteamID64()) end
        RightPanel.PerformLayout = function(me, w, h)
            for k, v in ipairs(me:GetChildren()) do
                v:SetTall(w)
            end

            Avatar:SetTall(w - (AvatarSpacing * 2))
        end
    end
end

function gRust.OpenPauseMenu()
    if IsValid(gRust.PauseMenu) then return end
    gRust.PauseMenu = vgui.Create("DPanel")
    gRust.PauseMenu:Dock(FILL)
    gRust.PauseMenu:SetZPos(100)
    gui.EnableScreenClicker(true)
    gRust.DrawHUD = false
    LeftPnl(gRust.PauseMenu)
end

function gRust.ClosePauseMenu()
    if not IsValid(gRust.PauseMenu) then return end
    gRust.PauseMenu:Remove()
    gui.EnableScreenClicker(false)
    gRust.DrawHUD = true
end

hook.Add(
    'PreRender',
    'PauseMenu',
    function()
        if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
            gui.HideGameUI()
            if IsValid(gRust.PauseMenu) then
                gRust.ClosePauseMenu()
            else
                gRust.OpenPauseMenu()
            end
        end
    end
)