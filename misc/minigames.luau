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

-- env

local AutoDice = false
local AutoDiceInterval = 6
local AutoDicePreference = "Giant Dice"
local AutoDiceWanted = {"Infinity Elixir"}

local AutoMinigames = false

local AutoMinigamesPetMatch = false
local AutoMinigamesPetMatchTicket = false
local AutoMinigamesPetMatchDifficulty = ""

local AutoMinigamesCartEscape = false
local AutoMinigamesCartEscapeTicket = false
local AutoMinigamesCartEscapeDifficulty = ""

local AutoMinigamesRobotClaw = false
local AutoMinigamesRobotClawTicket = false
local AutoMinigamesRobotClawDifficulty = ""
local AutoMinigamesRobotClawWanted = {}

local AutoMinigamesHyperDarts = false
local AutoMinigamesHyperDartsTicket = false
local AutoMinigamesHyperDartsDifficulty = ""

-- game

local BoardUtil = require(game:GetService("ReplicatedStorage").Shared.Utils.BoardUtil)
local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote:FindFirstChildWhichIsA("RemoteEvent")
local RemoteFunction = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote:FindFirstChildWhichIsA("RemoteFunction")

local BoardItems = {
    "golden-dice",
    "special-egg",
    "basic-dice",
    "infinity",
    "golden-dice",
    "super-ticket",
    "chance",
    "dice-key",
    "giant-dice",
}

local BoardItemConversion = {
    ["infinity"] = "Infinity Elixir",
    ["golden-dice"] = "Golden Dice",
    ["giant-dice"] = "Giant Dice",
    ["dice"] = "Dice",
    ["special-egg"] = "Special Egg",
    ["super-ticket"] = "Super Ticket",
    ["chance"] = "Chance",
    ["dice-key"] = "Dice Key",
}

local Dice = {
    "Dice",
    "Giant Dice", 
    "Golden Dice"
}

local Minigames = {}

for i,v in pairs(require(game:GetService("ReplicatedStorage").Shared.Data.Minigames)) do
    table.insert(Minigames, i)
end

local Difficultys = {
    "Easy",
    "Medium", 
    "Hard", 
    "Insane"
}

local ClawItems = {
    "Dice",
    "Giant Dice",
    "Golden Dice",
    "Dice Key",
    "Super Ticket",
    "Potions",
    "Infinity Elixir",
}

local ClawIds = {
    ["Dice"] = "rbxassetid://116941925962932",
    ["Giant Dice"] = "rbxassetid://114301337176020",
    ["Golden Dice"] = "rbxassetid://86442151035697",
    ["Dice Key"] = "rbxassetid://135090414328876",
    ["Super Ticket"] = "rbxassetid://77421640991860",
    ["Potions"] = "rbxassetid://72488281780856",
    ["Infinity Elixir"] = "rbxassetid://138542923319686",
}

-- script

local function GetPetCFrame()
    local PetCFrame

    for i,v in pairs(game.Workspace.Rendered.Pets:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == Player.Name then
            PetCFrame = v.Parent.Parent.CFrame
            break
        end
    end

    return PetCFrame
end

local function GetPetIndex()
    local Index
    local MinimumDistance = math.huge

    for i,v in pairs(BoardUtil.Nodes) do
        local Distance = (GetPetCFrame().Position - v.Part.Position).Magnitude
        if Distance < MinimumDistance then
            MinimumDistance = Distance
            Index = i
        end
    end

    return Index
end

local function ConvertTileType(Tile)
    local ConvertedName = "unknown"

    for i,v in pairs(BoardItemConversion) do
        if table.find(BoardItems, Tile) then
            ConvertedName = BoardItemConversion[Tile]
            break
        end
    end

    return ConvertedName
end

spawn(function()
    while wait() do
        if AutoDice then
            pcall(function()
                getgenv().IndexCache = getgenv().IndexCache or GetPetIndex()

                local FutureNodes = BoardUtil:ResolveNodes(getgenv().IndexCache, AutoDiceInterval)
                local IsInRange = false

                for i,v in pairs(FutureNodes) do
                    if table.find(AutoDiceWanted, ConvertTileType(v.Type)) then
                        IsInRange = true
                        break
                    end
                end

                local Called

                if IsInRange then
                    Called = RemoteFunction:InvokeServer("RollDice", "Golden Dice")
                else
                    Called = RemoteFunction:InvokeServer("RollDice", tostring(AutoDicePreference))
                end

                getgenv().IndexCache += Called.Roll

                if getgenv().IndexCache > 88 then
                    getgenv().IndexCache -= 88
                end

                Remote:FireServer("ClaimTile")
                
                if Called.Roll <= 3 then
                    wait(2.5)
                elseif Called.Roll > 3 and Called.Roll < 9 then
                    wait(5)
                else
                    wait(7.5)
                end
            end)
        end
    end
end)

spawn(function()
    while wait() do
        if AutoMinigames then
            if AutoMinigamesPetMatch then
                if AutoMinigamesPetMatchTicket then
                    Remote:FireServer("SkipMinigameCooldown", "Pet Match")
                    wait(1)
                end

                Remote:FireServer("StartMinigame", "Pet Match", AutoMinigamesPetMatchDifficulty)
                wait(1)

                if Player.PlayerGui.ScreenGui.MinigameHUD.Visible == true then
                    wait(5)
                    Remote:FireServer("FinishMinigame") 
                    wait(7)
                end
            end

            if Player.PlayerGui.ScreenGui:FindFirstChild("Prompt") then
                Player.PlayerGui.ScreenGui:FindFirstChild("Prompt"):Destroy()
            end

            if not AutoMinigames then
                return
            end

            if AutoMinigamesCartEscape then
                if AutoMinigamesCartEscapeTicket then
                    Remote:FireServer("SkipMinigameCooldown", "Cart Escape")
                    wait(1)
                end

                Remote:FireServer("StartMinigame", "Cart Escape", AutoMinigamesCartEscapeDifficulty)
                wait(5)

                if Player.PlayerGui.ScreenGui.MinigameHUD.Visible == true then
                    wait(10)
                    Remote:FireServer("FinishMinigame")
                    wait(7)
                end
            end

            if Player.PlayerGui.ScreenGui:FindFirstChild("Prompt") then
                Player.PlayerGui.ScreenGui:FindFirstChild("Prompt"):Destroy()
            end

            if not AutoMinigames then
                return
            end

            if AutoMinigamesRobotClaw then
                if AutoMinigamesRobotClawTicket then
                    Remote:FireServer("SkipMinigameCooldown", "Robot Claw")
                    wait(1)
                end

                Remote:FireServer("StartMinigame", "Robot Claw", AutoMinigamesRobotClawDifficulty)
                wait(5)

                if Player.PlayerGui.ScreenGui.MinigameHUD.Visible == true then
                    for i,v in pairs(Player.PlayerGui:FindFirstChild("ScreenGui"):GetChildren()) do
                        if string.find(v.Name, "ClawItem") and v:FindFirstChild("Icon") then
                            for _, Item in pairs(AutoMinigamesRobotClawWanted) do
                                if v.Icon.Label.Image == ClawIds[Item] then
                                    Remote:FireServer("GrabMinigameItem", string.gsub(v.Name, "ClawItem", ""))
                                    wait(3.7)
                                    break
                                end
                            end

                            if table.find(AutoMinigamesRobotClawWanted, "Infinity Elixir") then
                                for a,b in pairs(v.Icon:GetChildren()) do
                                    if string.find(b.Name:lower(), "infinity") then
                                        Remote:FireServer("GrabMinigameItem", string.gsub(v.Name, "ClawItem", ""))
                                        wait(3.7)
                                        break
                                    end
                                end
                            end
                        end
                    end

                    Remote:FireServer("FinishMinigame")
                    wait(7)
                end
            end

            if Player.PlayerGui.ScreenGui:FindFirstChild("Prompt") then
                Player.PlayerGui.ScreenGui:FindFirstChild("Prompt"):Destroy()
            end

            if not AutoMinigames then
                return
            end

            if AutoMinigamesHyperDarts then
                if AutoMinigamesHyperDartsTicket then
                    Remote:FireServer("SkipMinigameCooldown", "Hyper Darts")
                    wait(1)
                end

                Remote:FireServer("StartMinigame", "Hyper Darts", AutoMinigamesHyperDartsDifficulty)
                wait(5)

                if Player.PlayerGui.ScreenGui.MinigameHUD.Visible == true then
                    repeat 
                        wait()
                    until string.find(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.MinigameHUD["Hyper Darts"].Timer.Text, "1:30") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.MinigameHUD["Hyper Darts"].Timer.Text, "1:29") or not Player.PlayerGui.ScreenGui.MinigameHUD.Visible == true or not AutoMinigames or not AutoMinigamesHyperDarts
                    
                    Remote:FireServer("FinishMinigame")
                    wait(7)
                end
            end

            if Player.PlayerGui.ScreenGui:FindFirstChild("Prompt") then
                Player.PlayerGui.ScreenGui:FindFirstChild("Prompt"):Destroy()
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
    SubTitle = "Minigames Gui",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Dice = Window:CreateTab{
        Title = "Dice",
        Icon = "dice",
    },
    Minigames = Window:CreateTab{
        Title = "Minigames",
        Icon = "games",
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings",
    },
}

-- dice

Tabs.Dice:Section("Auto Dice")

Tabs.Dice:CreateToggle("DiceEnable", {Title = "Enable", Default = false, Description = "Enables auto dice farm with whatever configuration is provided", Callback = function(bool)
    AutoDice = bool
end})

Tabs.Dice:Section("Settings")

Tabs.Dice:CreateInput("DiceInterval", { Title = "Tile Interval", Description = "Enter the amount of tiles forward for the script to check before assuming if there is an item in range", Default = "6", Placeholder = "6", Numeric = true, Finished = true, Callback = function(int)
    DiceInterval = tonumber(int)
end})

Tabs.Dice:CreateDropdown("DicePreference", {Title = "Select Dice", Values = Dice, Multi = false, Searchable = true, Description = "Select the dice used when it has not found anything wanted in range", Default = "", Callback = function(str)
    DicePreference = tostring(str)
end})

Tabs.Dice:CreateDropdown("DiceWanted", {Title = "Whitelist Items", Values = BoardItemConversion, Multi = true, Searchable = true, Description = "Select the whitelists for the script to target when found within the interval", Default = {}, Callback = function(str)
    table.clear(DiceWanted)

    for i,v in pairs(str) do
        table.insert(DiceWanted, i)
    end
end})

-- minigames

Tabs.Minigames:Section("Auto Minigames")

Tabs.Minigames:CreateToggle("MinigamesEnable", {Title = "Enable", Default = false, Description = "Enables auto minigames farm with whatever configuration is provided", Callback = function(bool)
    AutoMinigames = bool
end})

Tabs.Minigames:Section("Pet Match")

Tabs.Minigames:CreateToggle("MinigamesPetMatch", {Title = "Enable", Default = false, Description = "Enables pet match farm with whatever configuration is provided", Callback = function(bool)
    AutoMinigamesPetMatch = bool
end})

Tabs.Minigames:CreateToggle("MinigamesPetMatchTicket", {Title = "Super Ticket", Default = false, Description = "Enables super ticket usage for pet match farm", Callback = function(bool)
    AutoMinigamesPetMatchTicket = bool
end})

Tabs.Minigames:CreateDropdown("MinigamesPetMatchDifficulty", {Title = "Select Difficulty", Values = Difficultys, Multi = false, Searchable = true, Description = "Select the difficulty for the pet match minigames", Default = "", Callback = function(str)
    AutoMinigamesPetMatchDifficulty = tostring(str)
end})

Tabs.Minigames:Section("Cart Escape")

Tabs.Minigames:CreateToggle("MinigamesCartEscape", {Title = "Enable", Default = false, Description = "Enables cart escape farm with whatever configuration is provided", Callback = function(bool)
    AutoMinigamesCartEscape = bool
end})

Tabs.Minigames:CreateToggle("MinigamesCartEscapeTicket", {Title = "Super Ticket", Default = false, Description = "Enables super ticket usage for cart escape farm", Callback = function(bool)
    AutoMinigamesCartEscapeTicket = bool
end})

Tabs.Minigames:CreateDropdown("MinigamesCartEscapeDifficulty", {Title = "Select Difficulty", Values = Difficultys, Multi = false, Searchable = true, Description = "Select the difficulty for the cart escape minigames", Default = "", Callback = function(str)
    AutoMinigamesCartEscapeDifficulty = tostring(str)
end})

Tabs.Minigames:Section("Claw Machine")

Tabs.Minigames:CreateToggle("MinigamesRobotClaw", {Title = "Enable", Default = false, Description = "Enables robot claw farm with whatever configuration is provided", Callback = function(bool)
    AutoMinigamesRobotClaw = bool
end})

Tabs.Minigames:CreateToggle("MinigamesRobotClawTicket", {Title = "Super Ticket", Default = false, Description = "Enables super ticket usage for robot claw farm", Callback = function(bool)
    AutoMinigamesRobotClawTicket = bool
end})

Tabs.Minigames:CreateDropdown("MinigamesRobotClawDifficulty", {Title = "Select Difficulty", Values = Difficultys, Multi = false, Searchable = true, Description = "Select the difficulty for the robot claw minigames", Default = "", Callback = function(str)
    AutoMinigamesRobotClawDifficulty = tostring(str)
end})

Tabs.Minigames:CreateDropdown("MinigamesRobotClawWanted", {Title = "Select Items", Values = ClawItems, Multi = true, Searchable = true, Description = "Select the items to target for the robot claw minigames", Default = {}, Callback = function(str)
    table.clear(AutoMinigamesRobotClawWanted)

    for i,v in pairs(str) do
        table.insert(AutoMinigamesRobotClawWanted, i)
    end
end})

Tabs.Minigames:Section("Hyper Darts")

Tabs.Minigames:CreateToggle("MinigamesHyperDarts", {Title = "Enable", Default = false, Description = "Enables hyper darts farm with whatever configuration is provided", Callback = function(bool)
    AutoMinigamesHyperDarts = bool
end})

Tabs.Minigames:CreateToggle("MinigamesRobotClawTicket", {Title = "Super Ticket", Default = false, Description = "Enables super ticket usage for hyper darts farm", Callback = function(bool)
    AutoMinigamesHyperDartsTicket = bool
end})

Tabs.Minigames:CreateDropdown("MinigamesHyperDartsDifficulty", {Title = "Select Difficulty", Values = Difficultys, Multi = false, Searchable = true, Description = "Select the difficulty for the hyper darts minigames", Default = "", Callback = function(str)
    AutoMinigamesHyperDartsDifficulty = tostring(str)
end})

-- settings

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("btdcbuus")
SaveManager:SetFolder("btdcbuus/MinigamesGui")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()