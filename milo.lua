-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. ScreenGui Initialization
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidShellPremiumHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local toggleKey = Enum.KeyCode.O
local isMenuOpen = false

-- Global Configuration States
_G.AutoFarmTreadmill = false
_G.AutoStealEgg = false
_G.AutoUpgradePen = false
_G.AutoUpgradeTreadmill = false
_G.AntiAFK = false
_G.GodMode = false
_G.HatchAllEggs = false
_G.PlaceAllEggs = false

_G.StealMethod = "Instant"
_G.ShowRarityFilter = "All"
_G.TrackOwnEggPrice = false
_G.TrackEnemyPenPrice = false

_G.AnimalWhitelist = {
    ["Chicken"] = true,
    ["Duck"] = true,
    ["Goose"] = true,
    ["Turkey"] = true,
    ["Penguin"] = false,
    ["Ostrich"] = false,
    ["Golden Phoenix"] = true
}

-- 2. Draggable Circular Token Button
local CircleButton = Instance.new("ImageButton")
CircleButton.Size = UDim2.new(0, 65, 0, 65)
CircleButton.Position = UDim2.new(0.02, 0, 0.3, 0)
CircleButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
CircleButton.Image = "rbxassetid://135891396860368"
CircleButton.ScaleType = Enum.ScaleType.Crop
CircleButton.ZIndex = 10
CircleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = CircleButton

local UIBorderBtn = Instance.new("UIStroke")
UIBorderBtn.Color = Color3.fromRGB(0, 162, 255)
UIBorderBtn.Width = 2
UIBorderBtn.Parent = CircleButton

-- 3. Core Dashboard Frame
local DashboardFrame = Instance.new("Frame")
DashboardFrame.Size = UDim2.new(0, 620, 0, 420)
DashboardFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
DashboardFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 22)
DashboardFrame.BorderSizePixel = 0
DashboardFrame.Visible = false
DashboardFrame.ZIndex = 5
DashboardFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = DashboardFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(28, 44, 65)
MainStroke.Width = 1
MainStroke.Parent = DashboardFrame

-- Left Sidebar Frame
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = DashboardFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarPatch = Instance.new("Frame")
SidebarPatch.Size = UDim2.new(0, 20, 1, 0)
SidebarPatch.Position = UDim2.new(1, -20, 0, 0)
SidebarPatch.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
SidebarPatch.BorderSizePixel = 0
SidebarPatch.Parent = Sidebar

local LogoText = Instance.new("TextLabel")
LogoText.Size = UDim2.new(1, 0, 0, 45)
LogoText.BackgroundTransparency = 1
LogoText.Text = "  VoidShell Hub"
LogoText.TextColor3 = Color3.fromRGB(0, 162, 255)
LogoText.Font = Enum.Font.GothamBold
LogoText.TextSize = 16
LogoText.TextXAlignment = Enum.TextXAlignment.Left
LogoText.Parent = Sidebar

local TabButtonContainer = Instance.new("Frame")
TabButtonContainer.Size = UDim2.new(1, 0, 1, -60)
TabButtonContainer.Position = UDim2.new(0, 0, 0, 50)
TabButtonContainer.BackgroundTransparency = 1
TabButtonContainer.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = TabButtonContainer

-- 4. Right Container Pages
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -165, 1, -20)
PageContainer.Position = UDim2.new(0, 160, 0, 10)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = DashboardFrame

local Pages = {}
local function createPage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 550)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(45, 55, 70)
    Page.Visible = false
    Page.Parent = PageContainer
    
    local List = Instance.new("UIListLayout")
    List.Padding = UDim.new(0, 6)
    List.Parent = Page
    
    Pages[name] = Page
    return Page
end

local MainPage = createPage("Main")
local WhitelistPage = createPage("Whitelist")
local VisualPage = createPage("Visual")
local SettingsPage = createPage("Settings")

MainPage.Visible = true

-- 5. Dynamic UI Builder Libraries
local function createToggleRow(parent, text, globalVarName, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 40)
    Row.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Row.Parent = parent
    Instance.new("UICorner").Parent = Row
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 210, 225)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 38, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleBtn.BackgroundColor3 = _G[globalVarName] and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(40, 48, 60)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Row
    Instance.new("UICorner").Parent = ToggleBtn
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = _G[globalVarName] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    Indicator.Parent = ToggleBtn
    Instance.new("UICorner").Parent = Indicator
    
    ToggleBtn.MouseButton1Click:Connect(function()
        _G[globalVarName] = not _G[globalVarName]
        if _G[globalVarName] then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = UDim2.new(1, -17, 0.5, -7)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 48, 60)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
        end
        if callback then callback(_G[globalVarName]) end
    end)
end

local function createDropdownRow(parent, text, options, defaultVal, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 40)
    Row.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    Row.Parent = parent
    Instance.new("UICorner").Parent = Row
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 210, 225)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 120, 0, 26)
    DropBtn.Position = UDim2.new(1, -132, 0.5, -13)
    DropBtn.BackgroundColor3 = Color3.fromRGB(35, 42, 55)
    DropBtn.Text = defaultVal .. "  ▼"
    DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = 12
    DropBtn.Parent = Row
    Instance.new("UICorner").Parent = DropBtn
    
    local currentIdx = table.find(options, defaultVal) or 1
    DropBtn.MouseButton1Click:Connect(function()
        currentIdx = (currentIdx % #options) + 1
        local selected = options[currentIdx]
        DropBtn.Text = selected .. "  ▼"
        if callback then callback(selected) end
    end)
end

-- 6. Populate Main Channel Toggles
createToggleRow(MainPage, "Auto Farm Treadmill", "AutoFarmTreadmill")
createToggleRow(MainPage, "Auto Steal Egg Mode", "AutoStealEgg")
createToggleRow(MainPage, "Auto Upgrade Pen Allocation", "AutoUpgradePen")
createToggleRow(MainPage, "Auto Upgrade Treadmill Velocity", "AutoUpgradeTreadmill")
createToggleRow(MainPage, "Anti-AFK Idle Disconnect Bypass", "AntiAFK")
createToggleRow(MainPage, "Godmode Damage Refusal Protection", "GodMode")
createToggleRow(MainPage, "Hatch All Storage Eggs", "HatchAllEggs")
createToggleRow(MainPage, "Place All Unhatched Nest Eggs", "PlaceAllEggs")

local StealConfigHeader = Instance.new("TextLabel")
StealConfigHeader.Size = UDim2.new(1, -10, 0, 25)
StealConfigHeader.BackgroundTransparency = 1
StealConfigHeader.Text = "   Auto Steal Dynamic Vectors:"
StealConfigHeader.TextColor3 = Color3.fromRGB(0, 162, 255)
StealConfigHeader.Font = Enum.Font.GothamBold
StealConfigHeader.TextSize = 11
StealConfigHeader.TextXAlignment = Enum.TextXAlignment.Left
StealConfigHeader.Parent = MainPage

createDropdownRow(MainPage, "Stealing Strategy Mode", {"Instant", "Anti-Hit"}, "Instant", function(selection)
    _G.StealMethod = selection
end)

-- 7. Populate Whitelist Channel Panel (From your screenshot cut-off point)
local WhitelistNotice = Instance.new("TextLabel")
WhitelistNotice.Size = UDim2.new(1, -10, 0, 30)
WhitelistNotice.BackgroundTransparency = 1
WhitelistNotice.Text = "Green = Automated Pickup Allowed | Red = Blacklisted Item Drop"
WhitelistNotice.TextColor3 = Color3.fromRGB(150, 165, 180)
WhitelistNotice.Font = Enum.Font.GothamItalic
WhitelistNotice.TextSize = 12
WhitelistNotice.Parent = WhitelistPage

for animalName, activeState in pairs(_G.AnimalWhitelist) do
local WRow = Instance.new("Frame")
WRow.Size = UDim2.new(1, -10, 0, 42)
WRow.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
WRow.Parent = WhitelistPage
Instance.new("UICorner").Parent = WRow
local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0.5, 0, 1, 0)
NameLabel.Position = UDim2.new(0, 12, 0, 0)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = animalName .. " (Hatch Profile Outcome)"
NameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
NameLabel.Font = Enum.Font.GothamMedium
NameLabel.TextSize = 13
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = WRow
local StatusBtn = Instance.new("TextButton")
StatusBtn.Size = UDim2.new(0, 110, 0, 26)
StatusBtn.Position = UDim2.new(1, -122, 0.5, -13)
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.TextSize = 12
StatusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusBtn.Parent = WRow
Instance.new("UICorner").Parent = StatusBtn
local function setVisualState(isWhitelisted)
if isWhitelisted then
StatusBtn.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
StatusBtn.Text = "WHITELISTED"
else
StatusBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
StatusBtn.Text = "BLACKLISTED"
end
end
setVisualState(_G.AnimalWhitelist[animalName])
StatusBtn.MouseButton1Click:Connect(function()
_G.AnimalWhitelist[animalName] = not _G.AnimalWhitelist[animalName]
setVisualState(_G.AnimalWhitelist[animalName])
end)
end
-- 8. Populate Visual Channel Options
createDropdownRow(VisualPage, "Track Rarity View Filter", {"All", "Common", "Rare", "Epic", "Legendary"}, "All", function(rarity)
_G.ShowRarityFilter = rarity
end)
createToggleRow(VisualPage, "Track Own Personal Egg Profit Projections", "TrackOwnEggPrice")
createToggleRow(VisualPage, "Track Opponent Foreign Pen Valuations", "TrackEnemyPenPrice")
-- 9. Keybind UI Setup Config
local BindRow = Instance.new("Frame")
BindRow.Size = UDim2.new(1, -10, 0, 42)
BindRow.BackgroundColor3 = Color3.fromRGB(24, 29, 38)
BindRow.Parent = SettingsPage
Instance.new("UICorner").Parent = BindRow
local BLabel = Instance.new("TextLabel")
BLabel.Size = UDim2.new(0.6, 0, 1, 0)
BLabel.Position = UDim2.new(0, 12, 0, 0)
BLabel.BackgroundTransparency = 1
BLabel.Text = "Change UI Hotkey"
BLabel.TextColor3 = Color3.fromRGB(180, 195, 210)
BLabel.Font = Enum.Font.GothamMedium
BLabel.TextSize = 13
BLabel.TextXAlignment = Enum.TextXAlignment.Left
BLabel.Parent = BindRow
local BButton = Instance.new("TextButton")
BButton.Size = UDim2.new(0, 100, 0, 26)
BButton.Position = UDim2.new(1, -112, 0.5, -13)
BButton.BackgroundColor3 = Color3.fromRGB(40, 48, 62)
BButton.Text = "[" .. toggleKey.Name .. "]"
BButton.TextColor3 = Color3.fromRGB(0, 162, 255)
BButton.Font = Enum.Font.GothamBold
BButton.TextSize = 12
BButton.Parent = BindRow
Instance.new("UICorner").Parent = BButton
local listening = false
BButton.MouseButton1Click:Connect(function()
if listening then return end
listening = true
BButton.Text = "Press Key..."
local conn
conn = UserInputService.InputBegan:Connect(function(input, processed)
if input.UserInputType == Enum.UserInputType.Keyboard then
toggleKey = input.KeyCode
BButton.Text = "[" .. toggleKey.Name .. "]"
listening = false
conn:Disconnect()
end
end)
end)
-- 10. Sidebar Navigation Setup
local function buildSidebarButton(name)
local Btn = Instance.new("TextButton")
Btn.Name = name .. "TabBtn"
Btn.Size = UDim2.new(1, -16, 0, 36)
Btn.BackgroundColor3 = (name == "Main") and Color3.fromRGB(24, 32, 45) or Color3.fromRGB(8, 10, 15)
Btn.Text = " " .. name
Btn.TextColor3 = (name == "Main") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 150, 165)
Btn.Font = Enum.Font.GothamMedium
Btn.TextSize = 13
Btn.TextXAlignment = Enum.TextXAlignment.Left
Btn.Parent = TabButtonContainer
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
Btn.UICorner.Parent = Btn
Btn.MouseButton1Click:Connect(function()
for pageName, pageFrame in pairs(Pages) do
if pageName == name then
pageFrame.Visible = true
TabButtonContainer[pageName.."TabBtn"].BackgroundColor3 = Color3.fromRGB(24, 32, 45)
TabButtonContainer[pageName.."TabBtn"].TextColor3 = Color3.fromRGB(255, 255, 255)
else
pageFrame.Visible = false
if TabButtonContainer:FindFirstChild(pageName.."TabBtn") then
TabButtonContainer[pageName.."TabBtn"].BackgroundColor3 = Color3.fromRGB(8, 10, 15)
TabButtonContainer[pageName.."TabBtn"].TextColor3 = Color3.fromRGB(140, 150, 165)
end
end
end
end)
end
buildSidebarButton("Main")
buildSidebarButton("Whitelist")
buildSidebarButton("Visual")
buildSidebarButton("Settings")
-- 11. Open/Close Menu Tweens
local function toggleDashboard()
isMenuOpen = not isMenuOpen
if isMenuOpen then
DashboardFrame.Visible = true
DashboardFrame.Size = UDim2.new(0, 0, 0, 0)
DashboardFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(DashboardFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingStyle.Out), {
Size = UDim2.new(0, 620, 0, 420),
Position = UDim2.new(0.5, -310, 0.5, -210)
}):Play()
else
local close = TweenService:Create(DashboardFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingStyle.In), {
Size = UDim2.new(0, 0, 0, 0),
Position = UDim2.new(0.5, 0, 0.5, 0)
})
close:Play()
close.Completed:Connect(function()
if not isMenuOpen then DashboardFrame.Visible = false end
end)
end
end
CircleButton.MouseButton1Click:Connect(toggleDashboard)
-- 12. Mouse & Mobile Dragging Configuration
local dragging, dragInput, dragStart, startPos
CircleButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = CircleButton.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then dragging = false end
end)
end
end)
CircleButton.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)


UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
CircleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
UserInputService.InputBegan:Connect(function(input, proc)
if proc then return end
if input.KeyCode == toggleKey then toggleDashboard() end
end)
