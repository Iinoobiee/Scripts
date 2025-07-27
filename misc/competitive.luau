repeat 
    wait()
until game:IsLoaded()

if game.PlaceId ~= 85896571713843 then
    return
end

if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.HUD.Left.Currency.Coins.Frame.Label.Text == "$1,000,000" then
    wait(2)
end

-- anti afk

pcall(function()
    for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
        v:Disable()
    end
end)

game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- player

local Player = game.Players.LocalPlayer
local Character = Player.Character
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

repeat
    wait(0.1)
until Player.PlayerGui.ScreenGui.HUD.Left.Currency.Coins.Frame.Label.Text ~= "$1,000,000"

-- game

local Competitive = Player.PlayerGui.ScreenGui.Competitive
local CompetitivePointsLabel = Competitive.Frame.Top.Stars.Bar.Label
local CompetitiveTeamPointersLabel = Competitive.Frame.Content.Team.Content.Total
local CompetitiveLeaderboardLabel = Competitive.Frame.Content.Team.Content.Rank
local CompetitiveTasks = Competitive.Frame.Content.Tasks
local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote:FindFirstChildWhichIsA("RemoteEvent")
local Request = (http_request or request or syn.request or http or nil)
local HttpService = game:GetService("HttpService")

-- env

local Eggs = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Shared.Data.Eggs)) do
    table.insert(Eggs, i)
end

local CompetitiveToggle = false -- main toggle
local CompetitiveGui = false -- gui toggle
local CompetitiveRifts = false -- does rifts if one is there for the egg
local CompetitiveEggPriority = false -- prioritizes eggs
local CompetitivePinging = false -- ping user on webhook
local CompetitiveFallback = "" -- fallback egg
local CompetitiveUrl = "" -- webhook url
local CompetitiveUserId = ""
local CompetitiveStorage = {} -- storage of tasks
local CompetitiveBlacklists = {}  -- blacklisted tasks
local CompetitiveTasks = {
    "Hatch 1,250 Eggs",
    "Hatch 80 Shiny Pets",
    "Hatch 50 Shiny Pets",
    "Hatch 1 Mythic Pet",
    "Hatch 2 Mythic Pets",
    "Play for 15 Minutes",
}

for i,v in pairs(Eggs) do
    table.insert(CompetitiveTasks, "Hatch 200 " .. v .. "s")
    table.insert(CompetitiveTasks, "Hatch 350 " .. v .. "s")
    table.insert(CompetitiveTasks, "Hatch 450 " .. v .. "s")
    table.insert(CompetitiveTasks, "Hatch 650 " .. v .. "s")
end

-- tween

local function Tween(position)
    if HumanoidRootPart == nil then 
        return 
    end

    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Vector3.new(0, 25000, 0)
    wait(0.1)

    local tween = game:GetService("TweenService"):Create(HumanoidRootPart, TweenInfo.new((Vector3.new(position.Position.X, HumanoidRootPart.Position.Y, position.Position.Z) - HumanoidRootPart.Position).Magnitude / 45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),{ CFrame = CFrame.new(Vector3.new(position.Position.X, HumanoidRootPart.Position.Y, position.Position.Z)) })
    tween:Play()
    tween.Completed:Wait()

    HumanoidRootPart.CFrame = position * CFrame.new(0, 5, 0)
    wait(0.1)
end

-- script

if game.CoreGui:FindFirstChild("ScreenGuiss") then
    game.CoreGui:FindFirstChild("ScreenGuiss"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScreenGuiss"
ScreenGui.Parent = game.CoreGui
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.new(0.15, 0, 0.15, 0)
Frame.Position = UDim2.new(0.83, 0, 0.02, 0)
Frame.Parent = ScreenGui

local TextLabel1 = Instance.new("TextLabel")
TextLabel1.Name = "TextLabel1"
TextLabel1.Text = "TASKS"
TextLabel1.Size = UDim2.new(1, 0, 0.15, 0)
TextLabel1.Position = UDim2.new(0, 0, 0, 0)
TextLabel1.BackgroundTransparency = 1
TextLabel1.TextColor3 = Color3.fromRGB(0, 255, 0)
TextLabel1.TextXAlignment = Enum.TextXAlignment.Right
TextLabel1.Font = Enum.Font.Code
TextLabel1.TextSize = 14
TextLabel1.TextStrokeTransparency = 0.7
TextLabel1.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel1.Parent = Frame

local TextLabel2 = Instance.new("TextLabel")
TextLabel2.Name = "TextLabel2"
TextLabel2.Text = ""
TextLabel2.Size = UDim2.new(1, 0, 0.2, 0)
TextLabel2.Position = UDim2.new(0, 0, 0.2, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.TextColor3 = Color3.fromRGB(50, 255, 50)
TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
TextLabel2.Font = Enum.Font.Code
TextLabel2.TextSize = 15
TextLabel2.TextStrokeTransparency = 0.7
TextLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel2.Parent = Frame

local TextLabel3 = Instance.new("TextLabel")
TextLabel3.Name = "TextLabel3"
TextLabel3.Text = ""
TextLabel3.Size = UDim2.new(1, 0, 0.2, 0)
TextLabel3.Position = UDim2.new(0, 0, 0.4, 0)
TextLabel3.BackgroundTransparency = 1
TextLabel3.TextColor3 = Color3.fromRGB(50, 255, 50)
TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
TextLabel3.Font = Enum.Font.Code
TextLabel3.TextSize = 15
TextLabel3.TextStrokeTransparency = 0.7
TextLabel3.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel3.Parent = Frame

local TextLabel4 = Instance.new("TextLabel")
TextLabel4.Name = "TextLabel4"
TextLabel4.Text = ""
TextLabel4.Size = UDim2.new(1, 0, 0.2, 0)
TextLabel4.Position = UDim2.new(0, 0, 0.6, 0)
TextLabel4.BackgroundTransparency = 1
TextLabel4.TextColor3 = Color3.fromRGB(50, 255, 50)
TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
TextLabel4.Font = Enum.Font.Code
TextLabel4.TextSize = 15
TextLabel4.TextStrokeTransparency = 0.7
TextLabel4.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel4.Parent = Frame

local TextLabel5 = Instance.new("TextLabel")
TextLabel5.Name = "TextLabel5"
TextLabel5.Text = ""
TextLabel5.Size = UDim2.new(1, 0, 0.2, 0)
TextLabel5.Position = UDim2.new(0, 0, 0.8, 0)
TextLabel5.BackgroundTransparency = 1
TextLabel5.TextColor3 = Color3.fromRGB(50, 255, 50)
TextLabel5.TextXAlignment = Enum.TextXAlignment.Right
TextLabel5.Font = Enum.Font.Code
TextLabel5.TextSize = 15
TextLabel5.TextStrokeTransparency = 0.7
TextLabel5.TextStrokeColor3 = Color3.new(0, 0, 0)
TextLabel5.Parent = Frame

local Frame1 = Instance.new("Frame")
Frame1.Name = "Frame1"
Frame1.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
Frame1.BackgroundTransparency = 0.9
Frame1.Size = UDim2.new(1.1, 0, 1.1, 0)
Frame1.Position = UDim2.new(-0.05, 0, -0.05, 0)
Frame1.ZIndex = -1
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = Frame1
Frame1.Parent = Frame

local function GetTasks()
    local Tasks = {}

    for i,v in pairs(CompetitiveTasks:GetChildren()) do
        if v:IsA("Frame") and v:FindFirstChild("Context") and v.Content.Type.Text == "Repeatable" then
            for _, Blacklist in pairs(CompetitiveBlacklists) do
                if typeof(v) == "table" then
                    continue
                end

                if not string.find(v.Content.Label.Text, Blacklist) then
                    table.insert(Tasks, v.Content.Label.Text)
                end
            end
        end
    end

    return Tasks
end

spawn(function()
    while wait() do
        if CompetitiveToggle then
            game.CoreGui:FindFirstChild("ScreenGuiss").Enabled = CompetitiveGui

            if CompetitiveGui then
                local Index = 2

                for i,v in pairs(CompetitiveTasks:GetChildren()) do
                    if v:IsA("Frame") and v:FindFirstChild("Context") then
                        Frame:FindFirstChild("TextLabel" .. Index).Text = v.Content.Label.Text .. " (" .. v.Content.Bar.Label.Text .. ")"
                        Index += 1
                    end
                end
            end

            local Tasks = GetTasks()

            if next(Tasks) == nil then
                Remote:FireServer("CompetitiveReroll", 3)
                Remote:FireServer("CompetitiveReroll", 4)

                return
            end

            if CompetitiveEggPriority then
                table.sort(Tasks, function(Task1, Task2)
                    local A = table.any(Eggs, function(Egg)
                        return string.find(Task1, Egg)
                    end)

                    local B = table.any(Eggs, function(Egg)
                        return string.find(Task2, Egg)
                    end)

                    return A and not B
                end)
            end

            local EggTask = false
            local RiftExists = false

            for i,v in pairs(Tasks) do
                for _, Egg in (Eggs) do
                    if string.find(v:lower(), Egg:lower()) then
                        EggTask = true

                        if CompetitiveRifts then
                            local RiftInstance = nil
                            local RiftLuck = 0

                            for i,v in pairs(game.Workspace.Rendered.Rifts:GetChildren()) do
                                if string.find(v.Name:lower(), string.match(Egg, "([^%s]+)"):lower()) and v:FindFirstChild("Display") then
                                    RiftExists = true
                                    
                                    local Luck = v.Display.SurfaceGui.Icon.Luck.Text:gsub("x", "")
                                    if RiftLuck < tonumber(Luck) then
                                        RiftInstance = v
                                        RiftLuck = tonumber(Luck)
                                    end
                                end
                            end

                            if not RiftInstance == nil then
                                if (HumanoidRootPart.Position - RiftInstance.Display.Position).Magnitude >= 10 then
                                    Tween(v.Display.CFrame)
                                end

                                Remote:FireServer("HatchEgg", Egg)
                            end
                        end

                        if RiftExists == false then
                            if not game.Workspace.Rendered.Generic:FindFirstChild(Egg) then
                                Remote:FireServer("Teleport", "Workspace.Worlds.The Overworld.PortalSpawn")
                                wait(1)
                                Tween(CFrame.new(-97.7658462524414, 8.82483196258545, -27.341026306152344))
                                wait(1)

                                if not game.Workspace.Rendered.Generic:FindFirstChild(Egg) then
                                    warn("[DEBUG] FAILED TO FIND EGG: " .. Egg)
                                    return
                                end

                                break
                            end

                            if (HumanoidRootPart.Position - game.Workspace.Rendered.Generic:FindFirstChild(Egg).Hitbox.Position).Magnitude >= 10 then
                                Tween(game.Workspace.Rendered.Generic:FindFirstChild(Egg).Hitbox.CFrame)
                            end

                            Remote:FireServer("HatchEgg", Egg)
                            break
                        end
                    end
                end

                break
            end

            if EggTask == false then
                if not game.Workspace.Rendered.Generic:FindFirstChild(CompetitiveFallback) then
                    Remote:FireServer("Teleport", "Workspace.Worlds.The Overworld.PortalSpawn")
                    wait(1)
                    Tween(CFrame.new(-97.7658462524414, 8.82483196258545, -27.341026306152344))

                    return
                end

                if (HumanoidRootPart.Position - game.Workspace.Rendered.Generic:FindFirstChild(CompetitiveFallback).Hitbox.Position).Magnitude >= 10 then
                    Tween(game.Workspace.Rendered.Generic:FindFirstChild(CompetitiveFallback).Hitbox.CFrame)
                end

                Remote:FireServer("HatchEgg", CompetitiveFallback)
            end

            local CompletedTask
            local NewTask

            for i,v in pairs(CompetitiveStorage) do
                if not table.find(Tasks, v) then
                    CompletedTask = v
                    break
                end
            end

            for i,v in pairs(Tasks) do
                if not table.find(CompetitiveStorage, v) then
                    NewTask = v
                    break
                end
            end

            if CompletedTask ~= nil and NewTask ~= nil and CompetitiveLogging and CompetitiveUrl ~= "" then
                if not Request then
                    return
                end

                local Embed = {
                    title = "Task Completed!",
                    description = "Old Task: " .. CompletedTask .. "\nNew Task: " .. NewTask .. "\nNew Points: " .. CompetitivePointsLabel.Text .. "\nNew Team Points: " .. CompetitiveTeamPointersLabel.Text .. "\nNew Leaderboard Spot: " .. CompetitiveLeaderboardLabel.Text,
                    color = 0x00C8FF,
                    footer = { text = os.date("%B %d, %Y  •  %I:%M %p") },
                }

                local Payload = {
                    ["embeds"] = Embed
                }

                if CompetitivePinging and CompetitiveUserId ~= "" then
                    Payload["content"] = "<@" .. CompetitiveUserId .. ">"
                end

                Request({
                    Url = CompetitiveUrl,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(Payload)
                })
            end

            table.clear(CompetitiveStorage)

            for i,v in pairs(Tasks) do
                table.insert(CompetitiveStorage, v)
            end
        end
    end
end)

-- gui

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

local Window = Library:CreateWindow{
    Title = "btdcbuus",
    SubTitle = "Competitive Gui",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Competitive = Window:CreateTab{
        Title = "Competitive",
        Icon = "phosphor-users-bold"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}


Tabs.Competitive:Section("Auto Competitive")

Tabs.Competitive:CreateToggle("CompetitiveToggle", {Title = "Enable", Default = false, Description = "Enables competitive farm with whatever configuration is provided", Callback = function(bool)
    CompetitiveToggle = bool
end})

Tabs.Competitive:Section("Settings")

Tabs.Competitive:CreateDropdown("CompetitiveFallback", {Title = "Competitive Fallback", Values = Eggs, Multi = true, Searchable = true, Description = "The egg it will go to when it has no egg task", Default = "", Callback = function(str)
    CompetitiveFallback = str
end})

Tabs.Competitive:CreateToggle("CompetitiveRifts", {Title = "Competitive Rifts", Default = false, Description = "Enables competitive rifts which makes it go to rifts when it finds a rift for the current egg it is hatching", Callback = function(bool)
    CompetitiveRifts = bool
end})

Tabs.Competitive:CreateToggle("CompetitiveEggPriority", {Title = "Competitive Egg Priority", Default = false, Description = "Enables competitive priority which makes eggs the highest priority over other tasks", Callback = function(bool)
    CompetitiveEggPriority = bool
end})

Tabs.Competitive:CreateToggle("CompetitiveGui", {Title = "Competitive Gui", Default = false, Description = "Enables competitive gui", Callback = function(bool)
    CompetitiveGui = bool
end})

Tabs.Competitive:CreateToggle("CompetitiveLogging", {Title = "Competitive Logging", Default = false, Description = "Enables competitive logging", Callback = function(bool)
    CompetitiveLogging = bool
end})

Tabs.Competitive:CreateToggle("CompetitivePinging", {Title = "Competitive Pinging", Default = false, Description = "Enables competitive pinging", Callback = function(bool)
    CompetitivePinging = bool
end})

Tabs.Competitive:CreateInput("CompetitiveUrl", { Title = "Competitive Url", Description = "The webhook url for competitive logging", Default = "", Placeholder = "Enter url", Numeric = false, Finished = true, Callback = function(int)
    CompetitiveUrl = int
end})

Tabs.Competitive:CreateInput("CompetitiveUserId", { Title = "Competitive User Id", Description = "The discord userid if pinging is enabled", Default = "", Placeholder = "Enter userid", Numeric = true, Finished = true, Callback = function(int)
    CompetitiveUserId = tostring(int)
end})

Tabs.Competitive:CreateDropdown("CompetitiveBlacklists", {Title = "Competitive Blacklists", Values = CompetitiveTasks, Multi = true, Searchable = true, Description = "Select the blacklists for the script to ignore and reroll when no valid tasks found", Default = {}, Callback = function(str)
    table.clear(CompetitiveBlacklists)

    for i,v in pairs(str) do
        table.insert(CompetitiveBlacklists, i)
    end
end})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("btdcbuus")
SaveManager:SetFolder("btdcbuus/CompetitiveGui")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()