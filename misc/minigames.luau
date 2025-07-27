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

getgenv().IndexCache = getgenv().IndexCache or GetPetIndex()

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