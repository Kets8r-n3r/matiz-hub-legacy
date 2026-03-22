--========================================================--
-- Matiz External — JX-UI
--========================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

--========================================================--
-- SETTINGS
--========================================================--

local Settings = {
    ESP = {
        Enabled = true,
        Boxes = true,
        CornerBoxes = false,
        Lines = false,
        Names = true,
        DistanceText = true,
        HealthBar = false,
        MaxDistance = 800,
        DrawDead = false,
        Box3D = false,
        Chams = false,
    },
    FOV = {
        Enabled = true,
        Radius = 150,
        Mode = "Center",
    },
    Skeleton = {
        Enabled = true,
    },
    Aim = {
        Enabled = true,
        Aimlock = true,
        FOV = 150,
        Smoothness = 0.18,
        TargetPart = "Head",
    },
    Misc = {
        Spinbot = false,
        SpinSpeed = 4,
        AntiAFK = false,
        InfJump = false,
        SpeedHack = false,
        WalkSpeed = 16,
        Noclip = false,
        HitNotif = false,
        KillCounter = false,
        Crosshair = false,
        CrosshairSize = 12,
        FlyHack = false,
        FlySpeed = 50,
        Fullbright = false,
        VisibleCheck = false,
        SilentAim = false,
        FPSUnlock = false,
        FPSCap = 144,
        WalkParticles = false,
        WalkRainbow = false,
        WalkParticleColor = Color3.fromRGB(255, 80, 80),
    }
}

local ESP_COLOR = Color3.fromRGB(255, 80, 80)
local FOV_COLOR = Color3.fromRGB(255, 80, 80)
local SKELETON_COLOR = Color3.fromRGB(255, 80, 80)

local FOVring = Drawing.new("Circle")
FOVring.Visible = Settings.FOV.Enabled
FOVring.Thickness = 2
FOVring.Color = FOV_COLOR
FOVring.Filled = false
FOVring.Radius = Settings.FOV.Radius
FOVring.Position = Vector2.new(0, 0)

--========================================================--
-- JX-UI ИНТЕГРАЦИЯ
--========================================================--

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/JX-UI/JX-UI.lua"))()
local CheatName = "matiz"

Library.Folders = {
    Directory = CheatName,
    Configs = CheatName .. "/Configs",
    Assets = CheatName .. "/Assets",
}

local Accent = Color3.fromRGB(255, 80, 80)
local Gradient = Color3.fromRGB(120, 20, 20)

Library.Theme.Accent = Accent
Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

-- делаем скроллбар прозрачнее
pcall(function()
    Library:ChangeTheme("ScrollBar", Color3.fromRGB(30, 30, 40))
    Library:ChangeTheme("ScrollBarBG", Color3.fromRGB(18, 18, 24))
end)

local Window = Library:Window({
    Name = " ",
    SubName = " ",
    Logo = "rbxassetid://118502852731978"
})

local KeybindList = Library:KeybindList("Keybinds")

--========================================================--
-- DRAG HELPER
--========================================================--

local function MakeDraggable(frame)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--========================================================--
-- ВОТЕРМАРКА + КНОПКА TOGGLE
--========================================================--

local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "MatizWatermark"
WatermarkGui.ResetOnSpawn = false
WatermarkGui.DisplayOrder = 999
WatermarkGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Вотермарка
local WMFrame = Instance.new("Frame")
WMFrame.Size = UDim2.new(0, 250, 0, 32)
WMFrame.Position = UDim2.new(0.5, -136, 0, 12)
WMFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
WMFrame.BorderSizePixel = 0
WMFrame.Parent = WatermarkGui
Instance.new("UICorner", WMFrame).CornerRadius = UDim.new(0, 8)
local WMStroke = Instance.new("UIStroke", WMFrame)
WMStroke.Color = Color3.fromRGB(55, 55, 70)
WMStroke.Thickness = 1

-- t.me/getmatiz (красный)
local WMName = Instance.new("TextLabel")
WMName.Size = UDim2.new(0, 118, 1, 0)
WMName.Position = UDim2.new(0, 10, 0, 0)
WMName.BackgroundTransparency = 1
WMName.Font = Enum.Font.GothamBold
WMName.TextSize = 13
WMName.TextXAlignment = Enum.TextXAlignment.Left
WMName.TextYAlignment = Enum.TextYAlignment.Center
WMName.TextColor3 = Color3.fromRGB(220, 55, 55)
WMName.Text = "t.me/getmatiz"
WMName.Parent = WMFrame

-- разделитель
local WMSep = Instance.new("TextLabel")
WMSep.Size = UDim2.new(0, 11, 1, 0)
WMSep.Position = UDim2.new(0, 100, 0, 0)
WMSep.BackgroundTransparency = 1
WMSep.Font = Enum.Font.Gotham
WMSep.TextSize = 13
WMSep.TextXAlignment = Enum.TextXAlignment.Center
WMSep.TextYAlignment = Enum.TextYAlignment.Center
WMSep.TextColor3 = Color3.fromRGB(65, 65, 80)
WMSep.Text = "│"
WMSep.Parent = WMFrame

-- fps + ping (белый)
local WMStats = Instance.new("TextLabel")
WMStats.Size = UDim2.new(0, 130, 1, 0)
WMStats.Position = UDim2.new(0, 110, 0, 0)
WMStats.BackgroundTransparency = 1
WMStats.Font = Enum.Font.GothamBold
WMStats.TextSize = 13
WMStats.TextXAlignment = Enum.TextXAlignment.Left
WMStats.TextYAlignment = Enum.TextYAlignment.Center
WMStats.TextColor3 = Color3.fromRGB(210, 210, 210)
WMStats.Text = "fps: 0  │  ping: 0ms"
WMStats.Parent = WMFrame

-- перемещение управляется из вкладки Watermark
local WMDragEnabled = false
local wmDragging, wmDragStart, wmStartPos = false, nil, nil

WMFrame.InputBegan:Connect(function(input)
    if not WMDragEnabled then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDragging = true
        wmDragStart = input.Position
        wmStartPos = WMFrame.Position
    end
end)
WMFrame.InputChanged:Connect(function(input)
    if not WMDragEnabled or not wmDragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - wmDragStart
        WMFrame.Position = UDim2.new(
            wmStartPos.X.Scale, wmStartPos.X.Offset + delta.X,
            wmStartPos.Y.Scale, wmStartPos.Y.Offset + delta.Y
        )
    end
end)
WMFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wmDragging = false
    end
end)


-- Обновление fps/ping
task.spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        WMStats.Text = "fps: " .. fps .. "  │  ping: " .. ping .. "ms"
        task.wait(1)
    end
end)

--========================================================--
-- ВКЛАДКИ
--========================================================--

Window:Category("Aimbot")
local AimPage = Window:Page({Name = "Aimlock", Icon = "122669828593160"})
local FOVPage = Window:Page({Name = "FOV", Icon = "123317177279443"})

Window:Category("Render")
local ESPPage = Window:Page({Name = "ESP", Icon = "92464809279921"})
local SkelPage = Window:Page({Name = "Skeleton", Icon = "123944728972740"})

Window:Category("Other")
local MiscPage = Window:Page({Name = "Misc", Icon = "101636617799068"})
local SettingsPage = Window:Page({Name = "Keybinds", Icon = "81598136527047"})
local PlayerListPage = Window:Page({Name = "Players", Icon = "92464809279921"})
Window:Category("System")
local ConfigPage = Window:Page({Name = "Configs", Icon = "122669828593160"})
local WatermarkPage = Window:Page({Name = "Watermark", Icon = "73789337996373"})
local ExecPage = Window:Page({Name = "Executor Info", Icon = "81598136527047"})

--========================================================--
-- Aimbot: Aimlock
--========================================================--

local AimSection = AimPage:Section({Name = "Aim Settings", Side = 1})

AimSection:Toggle({
    Name = "Enabled",
    Flag = "AimEnabled",
    Default = Settings.Aim.Enabled,
    Callback = function(v) Settings.Aim.Enabled = v end
})

AimSection:Toggle({
    Name = "Aimlock (RMB)",
    Flag = "Aimlock",
    Default = Settings.Aim.Aimlock,
    Callback = function(v) Settings.Aim.Aimlock = v end
})

AimSection:Slider({
    Name = "Aim FOV",
    Flag = "AimFOV",
    Min = 10,
    Max = 300,
    Default = Settings.Aim.FOV,
    Callback = function(v) Settings.Aim.FOV = v end
})

AimSection:Slider({
    Name = "Smoothness",
    Flag = "AimSmooth",
    Min = 1,
    Max = 50,
    Default = math.floor(Settings.Aim.Smoothness * 100),
    Callback = function(v) Settings.Aim.Smoothness = v / 100 end
})

local AimSection2 = AimPage:Section({Name = "Extra", Side = 2})

AimSection2:Toggle({
    Name = "Silent Aim",
    Flag = "SilentAim",
    Default = false,
    Callback = function(v) Settings.Misc.SilentAim = v end
})

AimSection:Dropdown({
    Name = "Target Part",
    Flag = "AimPart",
    Default = {Settings.Aim.TargetPart},
    Items = {"Head", "Torso"},
    Multi = false,
    Callback = function(v) Settings.Aim.TargetPart = v[1] end
})

--========================================================--
-- Aimbot: FOV
--========================================================--

local FOVSection = FOVPage:Section({Name = "FOV Settings", Side = 1})

FOVSection:Toggle({
    Name = "Enabled",
    Flag = "FOVEnabled",
    Default = Settings.FOV.Enabled,
    Callback = function(v)
        Settings.FOV.Enabled = v
        FOVring.Visible = v
    end
})

FOVSection:Slider({
    Name = "Radius",
    Flag = "FOVRadius",
    Min = 20,
    Max = 400,
    Default = Settings.FOV.Radius,
    Callback = function(v)
        Settings.FOV.Radius = v
        FOVring.Radius = v
    end
})

FOVSection:Dropdown({
    Name = "Mode",
    Flag = "FOVMode",
    Default = {Settings.FOV.Mode},
    Items = {"Center", "Mouse", "Off"},
    Multi = false,
    Callback = function(v) Settings.FOV.Mode = v[1] end
})

--========================================================--
-- Render: ESP
--========================================================--

local ESPSection = ESPPage:Section({Name = "ESP Settings", Side = 1})

ESPSection:Toggle({
    Name = "Enabled",
    Flag = "ESPEnabled",
    Default = Settings.ESP.Enabled,
    Callback = function(v) Settings.ESP.Enabled = v end
})

ESPSection:Toggle({
    Name = "Boxes",
    Flag = "ESPBoxes",
    Default = Settings.ESP.Boxes,
    Callback = function(v) Settings.ESP.Boxes = v end
})

ESPSection:Toggle({
    Name = "Corner Boxes",
    Flag = "ESPCorner",
    Default = Settings.ESP.CornerBoxes,
    Callback = function(v) Settings.ESP.CornerBoxes = v end
})

ESPSection:Toggle({
    Name = "Lines",
    Flag = "ESPLines",
    Default = Settings.ESP.Lines,
    Callback = function(v) Settings.ESP.Lines = v end
})

ESPSection:Toggle({
    Name = "Names",
    Flag = "ESPN",
    Default = Settings.ESP.Names,
    Callback = function(v) Settings.ESP.Names = v end
})

ESPSection:Toggle({
    Name = "Distance",
    Flag = "ESPDist",
    Default = Settings.ESP.DistanceText,
    Callback = function(v) Settings.ESP.DistanceText = v end
})

ESPSection:Slider({
    Name = "Max Distance",
    Flag = "ESPMaxDist",
    Min = 50,
    Max = 2000,
    Default = Settings.ESP.MaxDistance,
    Callback = function(v) Settings.ESP.MaxDistance = v end
})

ESPSection:Toggle({
    Name = "Draw Dead",
    Flag = "ESPDead",
    Default = Settings.ESP.DrawDead,
    Callback = function(v) Settings.ESP.DrawDead = v end
})

-- правая секция: 3D ESP
local ESPVisSection = ESPPage:Section({Name = "Visibility", Side = 2})

ESPVisSection:Toggle({
    Name = "Visible Check",
    Flag = "VisibleCheck",
    Default = false,
    Callback = function(v) Settings.Misc.VisibleCheck = v end
})

local ESP3DSection = ESPPage:Section({Name = "3D / Chams", Side = 2})

ESP3DSection:Toggle({
    Name = "3D Box",
    Flag = "ESPBox3D",
    Default = Settings.ESP.Box3D,
    Callback = function(v) Settings.ESP.Box3D = v end
})

ESP3DSection:Toggle({
    Name = "3D ESP (Chams)",
    Flag = "ESPChams",
    Default = Settings.ESP.Chams,
    Callback = function(v)
        Settings.ESP.Chams = v
        if not v then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char then
                        local sb = char:FindFirstChild("MATIZ_Chams")
                        if sb then sb:Destroy() end
                    end
                end
            end
        end
    end
})

--========================================================--
-- Render: Skeleton
--========================================================--

local SkelSection = SkelPage:Section({Name = "Skeleton Settings", Side = 1})

SkelSection:Toggle({
    Name = "Enabled",
    Flag = "SkelEnabled",
    Default = Settings.Skeleton.Enabled,
    Callback = function(v) Settings.Skeleton.Enabled = v end
})

--========================================================--
-- Other: Misc
--========================================================--

local MiscSection = MiscPage:Section({Name = "Movement", Side = 1})
local MiscSection2 = MiscPage:Section({Name = "Combat", Side = 1})
local MiscSection3 = MiscPage:Section({Name = "Spinbot", Side = 2})
local MiscSection4 = MiscPage:Section({Name = "Visual", Side = 2})

-- Movement
MiscSection:Toggle({
    Name = "Anti-AFK",
    Flag = "AntiAFK",
    Default = false,
    Callback = function(v) Settings.Misc.AntiAFK = v end
})

MiscSection:Toggle({
    Name = "Infinite Jump",
    Flag = "InfJump",
    Default = false,
    Callback = function(v) Settings.Misc.InfJump = v end
})

MiscSection:Toggle({
    Name = "Speed Hack",
    Flag = "SpeedHack",
    Default = false,
    Callback = function(v) Settings.Misc.SpeedHack = v end
})

MiscSection:Slider({
    Name = "Walk Speed",
    Flag = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 16,
    Callback = function(v) Settings.Misc.WalkSpeed = v end
})

MiscSection:Toggle({
    Name = "Noclip",
    Flag = "Noclip",
    Default = false,
    Callback = function(v) Settings.Misc.Noclip = v end
})

-- Combat
MiscSection2:Toggle({
    Name = "Hit Notification",
    Flag = "HitNotif",
    Default = false,
    Callback = function(v) Settings.Misc.HitNotif = v end
})

MiscSection2:Toggle({
    Name = "Kill Counter",
    Flag = "KillCounter",
    Default = false,
    Callback = function(v) Settings.Misc.KillCounter = v end
})

-- Spinbot
MiscSection3:Toggle({
    Name = "Spinbot",
    Flag = "Spinbot",
    Default = Settings.Misc.Spinbot,
    Callback = function(v) Settings.Misc.Spinbot = v end
})

MiscSection3:Slider({
    Name = "Spin Speed",
    Flag = "SpinSpeed",
    Min = 1,
    Max = 20,
    Default = Settings.Misc.SpinSpeed,
    Callback = function(v) Settings.Misc.SpinSpeed = v end
})

-- Visual
MiscSection4:Toggle({
    Name = "Crosshair",
    Flag = "Crosshair",
    Default = false,
    Callback = function(v) Settings.Misc.Crosshair = v end
})

MiscSection4:Slider({
    Name = "Crosshair Size",
    Flag = "CrosshairSize",
    Min = 5,
    Max = 40,
    Default = 12,
    Callback = function(v) Settings.Misc.CrosshairSize = v end
})

MiscSection4:Toggle({
    Name = "Fullbright",
    Flag = "Fullbright",
    Default = false,
    Callback = function(v)
        Settings.Misc.Fullbright = v
        local lighting = game:GetService("Lighting")
        if v then
            lighting.Brightness = 10
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.Ambient = Color3.fromRGB(255,255,255)
            lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        else
            lighting.Brightness = 1
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = true
            lighting.Ambient = Color3.fromRGB(127,127,127)
            lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        end
    end
})

MiscSection4:Toggle({
    Name = "FPS Unlocker",
    Flag = "FPSUnlock",
    Default = false,
    Callback = function(v)
        Settings.Misc.FPSUnlock = v
        pcall(function() if setfpscap then setfpscap(v and Settings.Misc.FPSCap or 60) end end)
    end
})

MiscSection4:Slider({
    Name = "FPS Cap",
    Flag = "FPSCap",
    Min = 60,
    Max = 360,
    Default = 144,
    Callback = function(v)
        Settings.Misc.FPSCap = v
        pcall(function() if Settings.Misc.FPSUnlock and setfpscap then setfpscap(v) end end)
    end
})

local MiscSection5 = MiscPage:Section({Name = "Fly", Side = 1})
local MiscSection6 = MiscPage:Section({Name = "Walk Particles", Side = 2})

MiscSection6:Toggle({
    Name = "Walk Particles",
    Flag = "WalkParticles",
    Default = false,
    Callback = function(v) Settings.Misc.WalkParticles = v end
})

MiscSection6:Toggle({
    Name = "Rainbow Mode",
    Flag = "WalkRainbow",
    Default = false,
    Callback = function(v) Settings.Misc.WalkRainbow = v end
})

MiscSection6:Label("Particle Color"):Colorpicker({
    Flag = "WalkParticleColor",
    Default = Color3.fromRGB(255, 80, 80),
    Callback = function(Color)
        Settings.Misc.WalkParticleColor = Color
    end
})

MiscSection5:Toggle({
    Name = "Fly Hack",
    Flag = "FlyHack",
    Default = false,
    Callback = function(v) Settings.Misc.FlyHack = v end
})

MiscSection5:Slider({
    Name = "Fly Speed",
    Flag = "FlySpeed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(v) Settings.Misc.FlySpeed = v end
})


--========================================================--
-- Settings: Keybinds
--========================================================--

local SettingsSection = SettingsPage:Section({Name = "UI Toggle Key", Side = 1})
local ColorSection = SettingsPage:Section({Name = "Colors", Side = 2})

-- Изменить все сразу
ColorSection:Label("All Colors"):Colorpicker({
    Flag = "AllColor",
    Default = ESP_COLOR,
    Callback = function(Color)
        ESP_COLOR = Color
        FOV_COLOR = Color
        SKELETON_COLOR = Color
        Library.Theme.Accent = Color
        Library:ChangeTheme("Accent", Color)
    end
})

ColorSection:Label("ESP Color"):Colorpicker({
    Flag = "ESPColor",
    Default = ESP_COLOR,
    Callback = function(Color)
        ESP_COLOR = Color
    end
})

ColorSection:Label("FOV Color"):Colorpicker({
    Flag = "FOVColor",
    Default = FOV_COLOR,
    Callback = function(Color)
        FOV_COLOR = Color
    end
})

ColorSection:Label("Skeleton Color"):Colorpicker({
    Flag = "SkeletonColor",
    Default = SKELETON_COLOR,
    Callback = function(Color)
        SKELETON_COLOR = Color
    end
})

local KeyOptions = {"RightShift", "Insert", "Home", "Delete", "End", "F1", "F2", "F3", "F4", "F5", "RightControl"}
local CurrentToggleKey = Enum.KeyCode.RightShift
local UIVisible = true

local function ToggleUI()
    UIVisible = not UIVisible
    pcall(function()
        Window:SetOpen(UIVisible)
    end)
end

SettingsSection:Dropdown({
    Name = "Toggle UI Key",
    Flag = "ToggleKey",
    Default = {"RightShift"},
    Items = KeyOptions,
    Multi = false,
    Callback = function(v)
        local key = v[1] or v
        CurrentToggleKey = Enum.KeyCode[key]
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CurrentToggleKey then
        ToggleUI()
    end
end)
--========================================================--
-- КОНФИГИ
--========================================================--

local ConfigSection = ConfigPage:Section({Name = "Config Manager", Side = 1})

local AUTO_CONFIG = Library.Folders.Configs .. "/autosave.json"

-- Автосохранение каждые 10 секунд
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if not isfolder(Library.Folders.Configs) then
                makefolder(Library.Folders.Configs)
            end
            writefile(AUTO_CONFIG, Library:GetConfig())
        end)
    end
end)

local ConfigSelected = nil

local ConfigsList = ConfigSection:Listbox({
    Flag = "ConfigsList",
    Items = {},
    Multi = false,
    Size = 120,
    Callback = function(v)
        ConfigSelected = v
    end
})

local function RefreshList()
    local list = {}
    pcall(function()
        if isfolder(Library.Folders.Configs) then
            for _, f in ipairs(listfiles(Library.Folders.Configs)) do
                local name = f:match("[^\/]+$")
                if name and name:sub(-5):lower() == ".json" and name ~= "autosave.json" then
                    table.insert(list, name)
                end
            end
        end
    end)
    ConfigsList:Refresh(list)
end

ConfigSection:Textbox({
    Flag = "NewConfigName",
    Placeholder = "Config name...",
    Numeric = false,
    Finished = false,
    Callback = function() end
})

ConfigSection:Button({
    Name = "Save",
    Callback = function()
        local name = Library.Flags["NewConfigName"]
        if name and name ~= "" then
            if not isfolder(Library.Folders.Configs) then makefolder(Library.Folders.Configs) end
            local fname = name:find(".json") and name or name .. ".json"
            writefile(Library.Folders.Configs .. "/" .. fname, Library:GetConfig())
            RefreshList()
            Library:Notification({Title = "Config", Description = "Saved: " .. fname, Duration = 3, Icon = "73789337996373"})
        end
    end
})

ConfigSection:Button({
    Name = "Load",
    Callback = function()
        if ConfigSelected and isfile(Library.Folders.Configs .. "/" .. ConfigSelected) then
            Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
            Library:Notification({Title = "Config", Description = "Loaded: " .. ConfigSelected, Duration = 3, Icon = "73789337996373"})
        end
    end
})

ConfigSection:Button({
    Name = "Delete",
    Callback = function()
        if ConfigSelected and isfile(Library.Folders.Configs .. "/" .. ConfigSelected) then
            delfile(Library.Folders.Configs .. "/" .. ConfigSelected)
            RefreshList()
            Library:Notification({Title = "Config", Description = "Deleted: " .. ConfigSelected, Duration = 3, Icon = "73789337996373"})
            ConfigSelected = nil
        end
    end
})

ConfigSection:Button({
    Name = "Refresh List",
    Callback = function()
        RefreshList()
    end
})

-- Секция сброса
local ResetSection = ConfigPage:Section({Name = "Reset", Side = 2})

ResetSection:Button({
    Name = "Reset All Settings",
    Callback = function()
        -- Удаляем автосейв
        pcall(function()
            if isfile(AUTO_CONFIG) then
                delfile(AUTO_CONFIG)
            end
        end)

        -- Сбрасываем все флаги через SetFlags на дефолтные значения
        local defaults = {
            AimEnabled       = true,
            AimlockEnabled   = true,
            AimFOV           = 150,
            AimSmooth        = 0.18,
            FOVEnabled       = true,
            FOVRadius        = 150,
            ESPEnabled       = true,
            ESPBoxes         = true,
            ESPCorner        = false,
            ESPLines         = false,
            ESPNames         = true,
            ESPDistance      = true,
            ESPMaxDist       = 800,
            ESPDrawDead      = false,
            ESP3DBox         = false,
            ESPChams         = false,
            SkelEnabled      = true,
            Spinbot          = false,
            SpinSpeed        = 4,
            AllColor         = Color3.fromRGB(255, 80, 80),
            ESPColor         = Color3.fromRGB(255, 80, 80),
            FOVColor         = Color3.fromRGB(255, 80, 80),
            SkeletonColor    = Color3.fromRGB(255, 80, 80),
        }

        for flag, value in pairs(defaults) do
            local setter = Library.SetFlags[flag]
            if setter then
                pcall(setter, value)
            end
        end

        -- Сбрасываем цвета
        ESP_COLOR = Color3.fromRGB(255, 80, 80)
        FOV_COLOR = Color3.fromRGB(255, 80, 80)
        SKELETON_COLOR = Color3.fromRGB(255, 80, 80)
        Library.Theme.Accent = Color3.fromRGB(255, 80, 80)
        Library:ChangeTheme("Accent", Color3.fromRGB(255, 80, 80))

        Library:Notification({
            Title = "Matiz External",
            Description = "All settings reset to default!",
            Duration = 3,
            Icon = "73789337996373"
        })
    end
})

task.spawn(RefreshList)

--========================================================--
-- EXECUTOR INFO
--========================================================--

local ExecInfoSection = ExecPage:Section({Name = "Executor", Side = 1})
local ExecConsoleSection = ExecPage:Section({Name = "Console", Side = 2})
local ExecTestSection = ExecPage:Section({Name = "UNC Tests", Side = 1})

-- Получаем инфу об executor
local function GetExecutorName()
    if identifyexecutor then
        local name, version = identifyexecutor()
        return name or "Unknown", version or ""
    elseif getexecutorname then
        return getexecutorname() or "Unknown", ""
    end
    return "Unknown", ""
end


local execName, execVer = GetExecutorName()

ExecInfoSection:Label("Name: " .. execName)
ExecInfoSection:Label("Version: " .. (execVer ~= "" and execVer or "N/A"))
ExecInfoSection:Label("Lua: " .. (_VERSION or "N/A"))
ExecInfoSection:Label("Game: " .. tostring(game.PlaceId))
ExecInfoSection:Label("Job ID: " .. tostring(game.JobId):sub(1, 18) .. "...")

ExecTestSection:Button({
    Name = "Test UNC",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/UNC%20test"))()
        end)
    end
})

ExecTestSection:Button({
    Name = "Test sUNC",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://script.sunc.su/"))()
        end)
    end
})

-- Консоль (перехватываем print/warn/error)
local ConsoleLines = {}
local ConsoleLabels = {}
local MAX_LINES = 8

local function AddConsoleLine(prefix, msg)
    local line = prefix .. tostring(msg)
    table.insert(ConsoleLines, 1, line)
    if #ConsoleLines > MAX_LINES then
        table.remove(ConsoleLines, MAX_LINES + 1)
    end
    -- обновляем лейблы
    for i, lbl in ipairs(ConsoleLabels) do
        lbl:SetText(ConsoleLines[i] or "")
    end
end

-- создаём лейблы для консоли
for i = 1, MAX_LINES do
    local lbl = ExecConsoleSection:Label("")
    table.insert(ConsoleLabels, lbl)
end

-- Перехватываем print / warn / error
local _print = print
local _warn = warn
local _error = error

print = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    AddConsoleLine("[print] ", msg)
    _print(...)
end

warn = function(...)
    local args = {...}
    local msg = table.concat(args, " ")
    AddConsoleLine("[warn] ", msg)
    _warn(...)
end

ExecConsoleSection:Button({
    Name = "Clear Console",
    Callback = function()
        ConsoleLines = {}
        for _, lbl in ipairs(ConsoleLabels) do
            lbl:SetText("")
        end
    end
})

local ExecLinkSection = ExecPage:Section({Name = "Links & Info", Side = 1})
ExecLinkSection:Label("Matiz Hub | Free Roblox Script")
ExecLinkSection:Label("Version: 1.0  |  UI: JX-UI")
ExecLinkSection:Label("Players: " .. #Players:GetPlayers())

ExecLinkSection:Button({
    Name = "Copy Telegram",
    Callback = function()
        setclipboard("https://t.me/getmatiz")
        Library:Notification({Title = "Matiz Hub", Description = "Copied: t.me/getmatiz", Duration = 3, Icon = "73789337996373"})
    end
})

ExecLinkSection:Button({
    Name = "Copy Website",
    Callback = function()
        setclipboard("https://getmatiz.neocities.org/skid")
        Library:Notification({Title = "Matiz Hub", Description = "Copied: getmatiz.neocities.org/skid", Duration = 3, Icon = "73789337996373"})
    end
})

--========================================================--
-- PLAYER LIST
--========================================================--

local PLSection = PlayerListPage:Section({Name = "Players on Server", Side = 1})
local PLTeleportSection = PlayerListPage:Section({Name = "Teleport", Side = 2})
local PLLabels = {}
local MAX_PL = 12
local PLPlayerNames = {}

for i = 1, MAX_PL do
    table.insert(PLLabels, PLSection:Label(""))
end

-- Dropdown для выбора игрока
local PLDropdown = PLTeleportSection:Dropdown({
    Name = "Select Player",
    Flag = "PLTeleportTarget",
    Items = {},
    Multi = false,
    Default = nil,
    Callback = function() end
})

PLTeleportSection:Button({
    Name = "Teleport To Player",
    Callback = function()
        local target = Library.Flags["PLTeleportTarget"]
        if not target then
            Library:Notification({Title = "Teleport", Description = "Select a player first!", Duration = 2, Icon = "73789337996373"})
            return
        end
        local plr = Players:FindFirstChild(target)
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Library:Notification({Title = "Teleport", Description = "Teleported to " .. target, Duration = 2, Icon = "73789337996373"})
            end
        else
            Library:Notification({Title = "Teleport", Description = "Player not found or has no character.", Duration = 2, Icon = "73789337996373"})
        end
    end
})

PLTeleportSection:Button({
    Name = "Refresh Players",
    Callback = function()
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(names, plr.Name)
            end
        end
        PLDropdown:Refresh(names)
        Library:Notification({Title = "Players", Description = "List refreshed!", Duration = 2, Icon = "73789337996373"})
    end
})

-- Авторефреш дропдауна каждые 5 сек
task.spawn(function()
    while task.wait(5) do
        local names = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(names, plr.Name)
            end
        end
        PLDropdown:Refresh(names)
    end
end)

PLSection:Button({
    Name = "Refresh",
    Callback = function()
        local list = Players:GetPlayers()
        for i = 1, MAX_PL do
            local plr = list[i]
            if plr and plr ~= LocalPlayer then
                local char = plr.Character
                local dist = "?"
                if char and char:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                end
                local hp = "?"
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hp = math.floor(hum.Health) end
                end
                PLLabels[i]:SetText(plr.Name .. " | " .. dist .. "m | hp:" .. hp)
            else
                PLLabels[i]:SetText("")
            end
        end
    end
})

-- Авторефреш каждые 3 сек
task.spawn(function()
    while task.wait(3) do
        local list = Players:GetPlayers()
        for i = 1, MAX_PL do
            local plr = list[i]
            if plr and plr ~= LocalPlayer then
                local char = plr.Character
                local dist = "?"
                if char and char:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    dist = math.floor((char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                end
                local hp = "?"
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hp = math.floor(hum.Health) end
                end
                PLLabels[i]:SetText(plr.Name .. " | " .. dist .. "m | hp:" .. hp)
            else
                PLLabels[i]:SetText("")
            end
        end
    end
end)



--========================================================--
-- FLY HACK
--========================================================--

local flyBodyVelocity = nil
local flyBodyGyro = nil

local function EnableFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.CFrame = root.CFrame
    flyBodyGyro.Parent = root

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.zero
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Parent = root
end

local function DisableFly()
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
end

RunService.RenderStepped:Connect(function()
    if not Settings.Misc.FlyHack then
        if flyBodyVelocity then DisableFly() end
        return
    end
    if not flyBodyVelocity then EnableFly() end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not flyBodyVelocity then return end

    local dir = Vector3.zero
    local spd = Settings.Misc.FlySpeed
    local cf = Camera.CFrame
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end

    flyBodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
    flyBodyGyro.CFrame = cf
end)

--========================================================--
-- SILENT AIM
--========================================================--

-- Silent Aim через hookmetamethod (только если поддерживается executor'ом)
pcall(function()
    if not hookmetamethod then return end
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and Settings.Misc.SilentAim then
            local args = {...}
            local target = nil
            local minDist = math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head then
                        local dist = (head.Position - Camera.CFrame.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = head
                        end
                    end
                end
            end
            if target then
                for i, v in ipairs(args) do
                    if typeof(v) == "Instance" and v:IsA("BasePart") then
                        args[i] = target
                    end
                end
            end
            return OldNamecall(self, table.unpack(args))
        end
        return OldNamecall(self, ...)
    end)
end)

--========================================================--
-- VISIBLE CHECK
--========================================================--

local VISIBLE_COLOR = Color3.fromRGB(255, 80, 80)
local HIDDEN_COLOR  = Color3.fromRGB(80, 80, 255)

local function IsVisible(char)
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local origin = Camera.CFrame.Position
    local direction = (root.Position - origin)
    local ray = Ray.new(origin, direction)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, char})
    return hit == nil
end

--========================================================--
-- WATERMARK SETTINGS
--========================================================--

local WMSection = WatermarkPage:Section({Name = "Watermark", Side = 1})
local WMColorSection = WatermarkPage:Section({Name = "Appearance", Side = 2})

WMSection:Toggle({
    Name = "Enable Dragging",
    Flag = "WMDrag",
    Default = false,
    Callback = function(v)
        WMDragEnabled = v
        -- подсвечиваем рамку когда можно двигать
        WMStroke.Color = v and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(55, 55, 70)
    end
})

WMSection:Slider({
    Name = "Background Opacity",
    Flag = "WMOpacity",
    Min = 10,
    Max = 100,
    Default = 100,
    Callback = function(v)
        -- не даём стать полностью прозрачной (мин 10%)
        WMFrame.BackgroundTransparency = 1 - (math.max(v, 10) / 100)
    end
})

WMColorSection:Label("Link Color"):Colorpicker({
    Flag = "WMNameColor",
    Default = Color3.fromRGB(220, 55, 55),
    Callback = function(Color)
        WMName.TextColor3 = Color
    end
})

WMColorSection:Label("Stats Color"):Colorpicker({
    Flag = "WMStatsColor",
    Default = Color3.fromRGB(210, 210, 210),
    Callback = function(Color)
        WMStats.TextColor3 = Color
        WMSep.TextColor3 = Color
    end
})

--========================================================--
-- ИНИЦИАЛИЗАЦИЯ ОКНА
--========================================================--

Window:Init()

-- Убираем скроллбар из панели вкладок
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        for _, gui in ipairs(gethui():GetDescendants()) do
            if gui:IsA("ScrollingFrame") then
                gui.ScrollBarThickness = 0
            end
        end
    end)
end)



-- Делаем скроллбар прозрачным
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
            if gui.Name == "ScrollBar" or gui.Name == "ScrollBarFrame" or gui.Name == "Scrollbar" then
                if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                    gui.BackgroundTransparency = 1
                    if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                        gui.ImageTransparency = 0.85
                    end
                end
            end
        end
    end)
    pcall(function()
        for _, gui in ipairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
            if gui.Name == "ScrollBar" or gui.Name == "ScrollBarFrame" or gui.Name == "Scrollbar" then
                if gui:IsA("Frame") or gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                    gui.BackgroundTransparency = 1
                    if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                        gui.ImageTransparency = 0.85
                    end
                end
            end
        end
    end)
end)

-- Автозагрузка сохранённого конфига
task.spawn(function()
    task.wait(0.8)
    pcall(function()
        if isfile(AUTO_CONFIG) then
            Library:LoadConfig(readfile(AUTO_CONFIG))
        end
    end)
end)

task.spawn(function()
    task.wait(1.5)
    Library:Notification({
        Title = "Matiz hub",
        Description = "Thank you for using matiz | t.me/getmatiz | getmatiz.neocities.org/skid",
        Duration = 8,
        Icon = "73789337996373"
    })
end)

--========================================================--
-- DRAWING FOV
--========================================================--

-- FOVring объявлен выше

local function UpdateFOV()
    if not Settings.FOV.Enabled or Settings.FOV.Mode == "Off" then
        FOVring.Visible = false
        return
    end

    FOVring.Visible = true
    FOVring.Radius = Settings.FOV.Radius

    if Settings.FOV.Mode == "Center" then
        FOVring.Position = Camera.ViewportSize / 2
    else
        local m = UserInputService:GetMouseLocation()
        FOVring.Position = Vector2.new(m.X, m.Y)
    end
end

--========================================================--
-- CHARACTER HELPERS
--========================================================--

local function GetCharacter(player)
    if not player then return nil end
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then
        return char, hum, root
    end
    return nil
end

local function IsR15(char)
    return char:FindFirstChild("UpperTorso") ~= nil
end

local function GetTorso(char)
    if IsR15(char) then
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("Torso")
    end
end

local function GetHead(char)
    return char:FindFirstChild("Head")
end

--========================================================--
-- ESP (Drawing API — Box2D, Box3D, Line, Names, Distance)
--========================================================--

local ESPObjects = {} -- { [player] = { box={lines}, box3d={lines}, line=Line, ... } }

local function NewLine()
    local l = Drawing.new("Line")
    l.Visible = false
    l.Thickness = 1
    l.Color = ESP_COLOR
    l.Transparency = 1
    return l
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    -- 2D box: 4 lines
    local box = {}
    for i = 1, 4 do box[i] = NewLine() end

    -- 3D box: 12 lines
    local box3d = {}
    for i = 1, 12 do box3d[i] = NewLine() end

    -- tracer line from bottom center to player
    local tracer = NewLine()
    tracer.Thickness = 1

    -- name text
    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Size = 13
    nameText.Font = Drawing.Fonts.Plex
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Center = true

    -- distance text
    local distText = Drawing.new("Text")
    distText.Visible = false
    distText.Size = 11
    distText.Font = Drawing.Fonts.Plex
    distText.Color = Color3.fromRGB(200, 200, 200)
    distText.Outline = true
    distText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distText.Center = true

    ESPObjects[player] = {
        box = box,
        box3d = box3d,
        tracer = tracer,
        nameText = nameText,
        distText = distText,
    }
end

local function RemoveESPForPlayer(player)
    local obj = ESPObjects[player]
    if not obj then return end
    for _, l in ipairs(obj.box) do l:Remove() end
    for _, l in ipairs(obj.box3d) do l:Remove() end
    obj.tracer:Remove()
    obj.nameText:Remove()
    obj.distText:Remove()
    ESPObjects[player] = nil
end

-- рисует 2D box по 4 точкам (tl, tr, br, bl)
local function Draw2DBox(lines, tl, tr, br, bl, visible)
    local pts = {tl, tr, br, bl}
    local nxt = {tr, br, bl, tl}
    for i = 1, 4 do
        lines[i].From = pts[i]
        lines[i].To = nxt[i]
        lines[i].Visible = visible
        lines[i].Color = ESP_COLOR
    end
end

-- рисует 3D box по 8 точкам мира
local function Draw3DBox(lines, corners, visible)
    -- corners: 1-4 верх, 5-8 низ (в viewport координатах)
    -- соединения: верх, низ, вертикали
    local edges = {
        {1,2},{2,3},{3,4},{4,1}, -- верх
        {5,6},{6,7},{7,8},{8,5}, -- низ
        {1,5},{2,6},{3,7},{4,8}, -- вертикали
    }
    for i, e in ipairs(edges) do
        lines[i].From = corners[e[1]]
        lines[i].To = corners[e[2]]
        lines[i].Visible = visible
        lines[i].Color = ESP_COLOR
    end
end

local function GetBoundingBox(char)
    -- возвращаем 8 углов bounding box персонажа в мировых координатах
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not root or not head then return nil end

    local rootPos = root.Position
    local headPos = head.Position

    local w = 2.5  -- ширина
    local d = 1.0  -- глубина

    local top = headPos.Y + 0.5
    local bot = rootPos.Y - 3.0

    local cf = root.CFrame
    local rx = cf.RightVector * w
    local rz = cf.LookVector * d

    return {
        Vector3.new(rootPos.X, top, rootPos.Z) + rx + rz,
        Vector3.new(rootPos.X, top, rootPos.Z) - rx + rz,
        Vector3.new(rootPos.X, top, rootPos.Z) - rx - rz,
        Vector3.new(rootPos.X, top, rootPos.Z) + rx - rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) + rx + rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) - rx + rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) - rx - rz,
        Vector3.new(rootPos.X, bot, rootPos.Z) + rx - rz,
    }
end

local function UpdateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char, hum, root = GetCharacter(plr)

            if Settings.ESP.Enabled and char and hum and root and (Settings.ESP.DrawDead or hum.Health > 0) then
                if not ESPObjects[plr] then
                    CreateESPForPlayer(plr)
                end
                local obj = ESPObjects[plr]
                if not obj then continue end

                local head = GetHead(char)
                local distance = (root.Position - Camera.CFrame.Position).Magnitude

                local rootScreen, rootOnScreen = Camera:WorldToViewportPoint(root.Position)

                if not rootOnScreen or distance > Settings.ESP.MaxDistance then
                    for _, l in ipairs(obj.box) do l.Visible = false end
                    for _, l in ipairs(obj.box3d) do l.Visible = false end
                    obj.tracer.Visible = false
                    obj.nameText.Visible = false
                    obj.distText.Visible = false
                else
                    -- вычисляем 2D bounding box через голову и ноги
                    local headScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.7, 0))
                    local feetPos = root.Position - Vector3.new(0, 3, 0)
                    local feetScreen = Camera:WorldToViewportPoint(feetPos)

                    local h2d = math.abs(headScreen.Y - feetScreen.Y)
                    local w2d = h2d * 0.55

                    local cx = headScreen.X
                    local top2d = headScreen.Y
                    local bot2d = feetScreen.Y

                    local tl = Vector2.new(cx - w2d, top2d)
                    local tr = Vector2.new(cx + w2d, top2d)
                    local br = Vector2.new(cx + w2d, bot2d)
                    local bl = Vector2.new(cx - w2d, bot2d)

                    -- 2D Box
                    if Settings.ESP.Boxes then
                        Draw2DBox(obj.box, tl, tr, br, bl, true)
                    else
                        for _, l in ipairs(obj.box) do l.Visible = false end
                    end

                    -- 3D Box
                    if Settings.ESP.Box3D then
                        local worldCorners = GetBoundingBox(char)
                        if worldCorners then
                            local screenCorners = {}
                            local allOnScreen = true
                            for i, wc in ipairs(worldCorners) do
                                local sc, on = Camera:WorldToViewportPoint(wc)
                                screenCorners[i] = Vector2.new(sc.X, sc.Y)
                                if not on then allOnScreen = false end
                            end
                            Draw3DBox(obj.box3d, screenCorners, allOnScreen)
                        end
                    else
                        for _, l in ipairs(obj.box3d) do l.Visible = false end
                    end

                    -- Tracer line
                    if Settings.ESP.Lines then
                        local screenSize = Camera.ViewportSize
                        obj.tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                        obj.tracer.To = Vector2.new(cx, bot2d)
                        obj.tracer.Color = ESP_COLOR
                        obj.tracer.Visible = true
                    else
                        obj.tracer.Visible = false
                    end

                    -- Name
                    if Settings.ESP.Names and head then
                        obj.nameText.Position = Vector2.new(cx, top2d - 16)
                        obj.nameText.Text = plr.Name
                        obj.nameText.Visible = true
                    else
                        obj.nameText.Visible = false
                    end

                    -- Distance
                    if Settings.ESP.DistanceText then
                        obj.distText.Position = Vector2.new(cx, bot2d + 2)
                        obj.distText.Text = string.format("%.0f m", distance)
                        obj.distText.Visible = true
                    else
                        obj.distText.Visible = false
                    end
                end
            else
                RemoveESPForPlayer(plr)
            end
        end
    end
end

--========================================================--
-- 3D ESP (CHAMS via SelectionBox)
--========================================================--

local function UpdateChams()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")

            if Settings.ESP.Enabled and Settings.ESP.Chams and hum and (Settings.ESP.DrawDead or hum.Health > 0) then
                -- создаём SelectionBox если нет
                local sb = char:FindFirstChild("MATIZ_Chams")
                if not sb then
                    sb = Instance.new("SelectionBox")
                    sb.Name = "MATIZ_Chams"
                    sb.LineThickness = 0.05
                    sb.SurfaceTransparency = 0.6
                    sb.SurfaceColor3 = ESP_COLOR
                    sb.Color3 = ESP_COLOR
                    sb.Adornee = char
                    sb.Parent = char
                end
            else
                local sb = char:FindFirstChild("MATIZ_Chams")
                if sb then sb:Destroy() end
            end
        end
    end
end

--========================================================--
-- SKELETON
--========================================================--

local SkeletonSettings = {
    Color = SKELETON_COLOR,
    Thickness = 2,
    Transparency = 1
}

local skeletons = {}

local function createLine()
    local line = Drawing.new("Line")
    line.Visible = false
    return line
end

local function removeSkeleton(skeleton)
    for _, line in pairs(skeleton) do
        line:Remove()
    end
end

local function trackPlayer(plr)
    local skeleton = {}

    local function updateSkeleton()
        if not Settings.Skeleton.Enabled then
            for _, line in pairs(skeleton) do line.Visible = false end
            return
        end

        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            for _, line in pairs(skeleton) do line.Visible = false end
            return
        end

        local character = plr.Character
        local humanoid = character:FindFirstChild("Humanoid")

        local joints = {}
        local connections = {}

        if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["UpperTorso"] = character:FindFirstChild("UpperTorso"),
                ["LowerTorso"] = character:FindFirstChild("LowerTorso"),
                ["LeftUpperArm"] = character:FindFirstChild("LeftUpperArm"),
                ["LeftLowerArm"] = character:FindFirstChild("LeftLowerArm"),
                ["LeftHand"] = character:FindFirstChild("LeftHand"),
                ["RightUpperArm"] = character:FindFirstChild("RightUpperArm"),
                ["RightLowerArm"] = character:FindFirstChild("RightLowerArm"),
                ["RightHand"] = character:FindFirstChild("RightHand"),
                ["LeftUpperLeg"] = character:FindFirstChild("LeftUpperLeg"),
                ["LeftLowerLeg"] = character:FindFirstChild("LeftLowerLeg"),
                ["RightUpperLeg"] = character:FindFirstChild("RightUpperLeg"),
                ["RightLowerLeg"] = character:FindFirstChild("RightLowerLeg"),
            }
            connections = {
                {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"},
                {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"},
                {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
            }
        else
            joints = {
                ["Head"] = character:FindFirstChild("Head"),
                ["Torso"] = character:FindFirstChild("Torso"),
                ["LeftArm"] = character:FindFirstChild("Left Arm"),
                ["RightArm"] = character:FindFirstChild("Right Arm"),
                ["LeftLeg"] = character:FindFirstChild("Left Leg"),
                ["RightLeg"] = character:FindFirstChild("Right Leg"),
            }
            connections = {
                {"Head","Torso"}, {"Torso","LeftArm"}, {"Torso","RightArm"},
                {"Torso","LeftLeg"}, {"Torso","RightLeg"},
            }
        end

        for index, connection in ipairs(connections) do
            local jointA = joints[connection[1]]
            local jointB = joints[connection[2]]

            if jointA and jointB then
                local posA, onA = Camera:WorldToViewportPoint(jointA.Position)
                local posB, onB = Camera:WorldToViewportPoint(jointB.Position)

                local line = skeleton[index] or createLine()
                skeleton[index] = line

                line.Color = SkeletonSettings.Color
                line.Thickness = SkeletonSettings.Thickness
                line.Transparency = SkeletonSettings.Transparency

                if onA and onB then
                    line.From = Vector2.new(posA.X, posA.Y)
                    line.To = Vector2.new(posB.X, posB.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            elseif skeleton[index] then
                skeleton[index].Visible = false
            end
        end
    end

    skeletons[plr] = skeleton

    RunService.RenderStepped:Connect(function()
        if plr and plr.Parent then
            updateSkeleton()
        else
            removeSkeleton(skeleton)
        end
    end)
end

local function untrackPlayer(plr)
    if skeletons[plr] then
        removeSkeleton(skeletons[plr])
        skeletons[plr] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then trackPlayer(plr) end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then trackPlayer(plr) end
end)

Players.PlayerRemoving:Connect(untrackPlayer)

--========================================================--
-- AIMBOT
--========================================================--

local function GetClosestTarget()
    if not Settings.Aim.Enabled then return nil end

    local mousePos = UserInputService:GetMouseLocation()
    local bestTarget = nil
    local bestDist = Settings.Aim.FOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char, hum, root = GetCharacter(plr)
            if char and hum and hum.Health > 0 then
                local targetPart =
                    (Settings.Aim.TargetPart == "Head" and char:FindFirstChild("Head"))
                    or GetTorso(char)

                if targetPart then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                        if dist < Settings.Aim.FOV and dist < bestDist then
                            bestDist = dist
                            bestTarget = targetPart
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

local AimlockHeld = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimlockHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimlockHeld = false
    end
end)

local function UpdateAimbot()
    if not Settings.Aim.Enabled then return end

    local target = nil

    if Settings.Aim.Aimlock then
        if AimlockHeld then
            target = GetClosestTarget()
        end
    else
        target = GetClosestTarget()
    end

    if target then
        local camPos = Camera.CFrame.Position
        local dir = (target.Position - camPos).Unit
        local targetCF = CFrame.new(camPos, camPos + dir)
        Camera.CFrame = Camera.CFrame:Lerp(targetCF, Settings.Aim.Smoothness)
    end
end

--========================================================--
-- ANTI-AFK
--========================================================--

local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if Settings.Misc.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

--========================================================--
-- INFINITE JUMP
--========================================================--

UserInputService.JumpRequest:Connect(function()
    if not Settings.Misc.InfJump then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Dead then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--========================================================--
-- SPEED HACK
--========================================================--

RunService.Heartbeat:Connect(function()
    if not Settings.Misc.SpeedHack then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= 16 and not Settings.Misc.SpeedHack then
                hum.WalkSpeed = 16
            end
        end
        return
    end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Settings.Misc.WalkSpeed end
end)

--========================================================--
-- NOCLIP
--========================================================--

RunService.Stepped:Connect(function()
    if not Settings.Misc.Noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

--========================================================--
-- KILL COUNTER + HIT NOTIFICATION
--========================================================--

local KillCount = 0
local KillLabel = nil

-- GUI для Kill Counter
local KillGui = Instance.new("ScreenGui")
KillGui.Name = "MatizKillCounter"
KillGui.ResetOnSpawn = false
KillGui.DisplayOrder = 998
KillGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

KillLabel = Instance.new("TextLabel")
KillLabel.Size = UDim2.new(0, 140, 0, 28)
KillLabel.Position = UDim2.new(0, 12, 0.5, -14)
KillLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
KillLabel.BackgroundTransparency = 0.3
KillLabel.BorderSizePixel = 0
KillLabel.Font = Enum.Font.GothamBold
KillLabel.TextSize = 13
KillLabel.TextColor3 = Color3.fromRGB(220, 55, 55)
KillLabel.Text = "kills: 0"
KillLabel.Visible = false
KillLabel.Parent = KillGui
Instance.new("UICorner", KillLabel).CornerRadius = UDim.new(0, 6)

-- Следим за смертями других игроков
local function TrackKills(plr)
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            local tag = hum:FindFirstChild("creator")
            if tag and tag.Value == LocalPlayer then
                KillCount = KillCount + 1
                KillLabel.Text = "kills: " .. KillCount
                if Settings.Misc.HitNotif then
                    Library:Notification({
                        Title = "Kill",
                        Description = "You killed " .. plr.Name .. "! Total: " .. KillCount,
                        Duration = 2,
                        Icon = "73789337996373"
                    })
                end
            end
        end)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then TrackKills(plr) end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then TrackKills(plr) end
end)

RunService.RenderStepped:Connect(function()
    KillLabel.Visible = Settings.Misc.KillCounter
end)

--========================================================--
-- CROSSHAIR
--========================================================--

local CrosshairLines = {
    Drawing.new("Line"), -- top
    Drawing.new("Line"), -- bottom
    Drawing.new("Line"), -- left
    Drawing.new("Line"), -- right
}
for _, l in ipairs(CrosshairLines) do
    l.Thickness = 2
    l.Color = Color3.fromRGB(255, 255, 255)
    l.Visible = false
end

local function UpdateCrosshair()
    local enabled = Settings.Misc.Crosshair
    local size = Settings.Misc.CrosshairSize
    local vp = Camera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local gap = 4

    -- top
    CrosshairLines[1].From = Vector2.new(cx, cy - gap)
    CrosshairLines[1].To   = Vector2.new(cx, cy - gap - size)
    CrosshairLines[1].Visible = enabled
    -- bottom
    CrosshairLines[2].From = Vector2.new(cx, cy + gap)
    CrosshairLines[2].To   = Vector2.new(cx, cy + gap + size)
    CrosshairLines[2].Visible = enabled
    -- left
    CrosshairLines[3].From = Vector2.new(cx - gap, cy)
    CrosshairLines[3].To   = Vector2.new(cx - gap - size, cy)
    CrosshairLines[3].Visible = enabled
    -- right
    CrosshairLines[4].From = Vector2.new(cx + gap, cy)
    CrosshairLines[4].To   = Vector2.new(cx + gap + size, cy)
    CrosshairLines[4].Visible = enabled
end

--========================================================--
-- WALK PARTICLES
--========================================================--

local WalkParticleHue = 0
local WalkParticleTimer = 0

local function SpawnWalkParticle(pos)
    local color
    if Settings.Misc.WalkRainbow then
        WalkParticleHue = (WalkParticleHue + 0.06) % 1
        color = Color3.fromHSV(WalkParticleHue, 1, 1)
    else
        color = Settings.Misc.WalkParticleColor or Color3.fromRGB(255, 80, 80)
    end

    local p = Instance.new("Part")
    p.Size = Vector3.new(0.25, 0.25, 0.25)
    p.Anchored = true
    p.CanCollide = false
    p.CastShadow = false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.CFrame = CFrame.new(pos + Vector3.new(math.random(-4,4)*0.1, 0, math.random(-4,4)*0.1))
    p.Parent = workspace
    game:GetService("Debris"):AddItem(p, 0.5)
end

local function UpdateWalkParticles()
    if not Settings.Misc.WalkParticles then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if hum.MoveDirection.Magnitude < 0.1 then return end

    WalkParticleTimer = WalkParticleTimer + 1
    if WalkParticleTimer >= 3 then
        WalkParticleTimer = 0
        SpawnWalkParticle(root.Position - Vector3.new(0, 2.9, 0))
    end
end

--========================================================--
-- SPINBOT
--========================================================--

local function UpdateSpinbot()
    if not Settings.Misc.Spinbot then return end

    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.Misc.SpinSpeed), 0)
end

--========================================================--
-- PLAYER EVENTS (ESP)
--========================================================--

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        CreateESPForPlayer(plr)
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESPForPlayer(plr)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        if plr.Character then CreateESPForPlayer(plr) end
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            CreateESPForPlayer(plr)
        end)
    end
end

--========================================================--
-- MAIN RENDER LOOP
--========================================================--

RunService.RenderStepped:Connect(function()
    -- Синхронизация цвета ESP с акцентом UI
    FOVring.Color = FOV_COLOR
    SkeletonSettings.Color = SKELETON_COLOR
    -- Обновляем цвет всех ESP объектов
    for plr, obj in pairs(ESPObjects) do
        if obj then
            local col = ESP_COLOR
            if Settings.Misc.VisibleCheck and plr.Character then
                col = IsVisible(plr.Character) and VISIBLE_COLOR or HIDDEN_COLOR
            end
            for _, l in ipairs(obj.box or {}) do l.Color = col end
            for _, l in ipairs(obj.box3d or {}) do l.Color = col end
            if obj.tracer then obj.tracer.Color = col end
            if obj.nameText then obj.nameText.Color = col end
            if obj.distText then obj.distText.Color = col end
        end
    end
    UpdateESP()
    UpdateChams()
    UpdateFOV()
    UpdateAimbot()
    UpdateSpinbot()
    UpdateCrosshair()
    UpdateWalkParticles()
end)
