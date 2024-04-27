local gRust = {}
local TitleBanner = Material("ui/banner.png", "smooth")
local function LeftPnl(pnl)
    local LeftPanel = vgui.Create("Panel", pnl)
    LeftPanel:Dock(LEFT)
    LeftPanel:SetWide(ScrH() * 0.45)
    LeftPanel:DockMargin(ScrH() * 0.1, 0, 0, 0)
    LeftPanel:DockPadding(0, ScrH() * 0.1, 0, 0)
    LeftPanel.Paint = function(me, w, h)
        surface.SetDrawColor(49, 49, 49)
        surface.DrawRect(0, 0, w, h)
    end

    local MainPanel = vgui.Create("Panel", pnl)
    MainPanel:Dock(FILL)
    MainPanel:SetWide(ScrH() * 0.5)
    MainPanel:DockMargin(ScrH() * 0.05, 0, 0, 0)
    MainPanel.Paint = function(me, w, h)
        surface.SetDrawColor(49, 49, 49, 154)
        surface.DrawRect(0, 0, w, h)
    end

    local GetList_Button = {
        {
            Menu = "By oNyaaa & Bezdar",
            func = function(self) gRust.ClosePauseMenu() end,
        },
        {
            Menu = "RESUME",
            func = function(self) gRust.ClosePauseMenu() end,
        },
        {
            Menu = "NEWS",
            func = function(self) end,
        },
        {
            Menu = "GRUST+",
            func = function(self) end,
        },
        {
            Menu = "LEGACY MENU",
            func = function(self)
                gRust.ClosePauseMenu()
                gui.ActivateGameUI()
            end,
        },
        {
            Menu = "SUICIDE",
            func = function(self)
                RunConsoleCommand("kill")
                gRust.ClosePauseMenu()
            end,
        },
        {
            Menu = "QUIT",
            func = function(self)
                RunConsoleCommand("kill")
                RunConsoleCommand("disconnect")
            end,
        },
    }

    local grid = vgui.Create("DGrid", LeftPanel)
    grid:SetPos(10, ScrH() * 0.3)
    grid:SetCols(1)
    grid:SetColWide(160)
    grid:SetRowHeight(25)
    for k, v in pairs(GetList_Button) do
        local but = vgui.Create("DButton")
        but:SetText("")
        but:SetSize(150, 20)
        but.DoClick = function(self) v.func(self) end
        but.Paint = function(me, w, h)
            if me:IsHovered() then
                draw.DrawText(v.Menu, "Default", 0, 0, Color(0, 255, 0), TEXT_ALIGN_LEFT)
            else
                draw.DrawText(v.Menu, "Default", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end
            
        end

        grid:AddItem(but)
    end

    local Title = vgui.Create("DPanel",LeftPanel)
    Title:Dock(TOP)
    Title:DockMargin(0, 0, 0, ScrH() * 0.125)
    LeftPanel.PerformLayout = function(me, w, h) Title:SetTall(w * 0.2) end
    Title.Paint = function(me, w, h)
        surface.SetMaterial(TitleBanner)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)
    end
end

function gRust.OpenPauseMenu()
    if IsValid(gRust.PauseMenu) then return end
    gRust.PauseMenu = vgui.Create("DPanel")
    gRust.PauseMenu:Dock(FILL)
    gRust.PauseMenu:SetZPos(100)
    gRust.PauseMenu.Paint = function(me, w, h)
        surface.SetDrawColor(37, 37, 37, 154)
        surface.DrawRect(0, 0, w, h)
    end

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