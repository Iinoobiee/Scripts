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
local AutoDicePrefered = ""
local AutoDiceWanted = {}

-- game

local Board = require(game:GetService("ReplicatedStorage").Client.Gui.Frames.Board)
local BoardUtil = require(game:GetService("ReplicatedStorage").Shared.Utils.BoardUtil)
local Remote = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote:FindFirstChildWhichIsA("RemoteEvent")
local RemoteFunction = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote:FindFirstChildWhichIsA("RemoteFunction")

local BoardItems = {}

for i,v in pairs(BoardUtil.ChanceTile) do
    table.insert(BoardItems, v.DisplayName)
end

-- script

local function GetPetCFrame()
    local PetCFrame

    for i,v in pairs(game.Workspace.Rendered.Pets:GetDescendants()) do
        if v:IsA("Label") and v.Text == Player.Name then
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
    local ConvertedName

    for i,v in pairs(BoardUtil.ChanceTile) do
        if i == Tile then
            ConvertedName = v.DisplayName
            break
        end
    end

    return ConvertedName
end

local FutureNodes = BoardUtil:ResolveNodes(GetPetIndex(), AutoDiceInterval)
local IsInRange = false
local Index

for i,v in pairs(FutureNodes) do
    if table.find(AutoDiceWanted, ConvertTileType(v.Type)) and i <= 2 then
        IsInRange = true
        print(i)
        break
    end
end

--[[
spawn(function()
    while wait() do
        if AutoDice then
            local FutureNodes = BoardUtil:ResolveNodes(GetPetIndex(), AutoDiceInterval)
            local IsInRange = false
            local Index

            for i,v in pairs(FutureNodes) do
                if table.find(AutoDiceWanted, ConvertTileType(v.Type)) and i <= 2 then
                    IsInRange = true
                    print(i)
                    break
                end
            end

            if IsInRange then
                RemoteFunction:InvokeServer("RollDice", "Golden Dice")
            else
                RemoteFunction:InvokeServer("RollDice", AutoDicePrefered)
            end

            Board.Pieces[Player.Name].move(Index)
            RemoteEvent:FireServer("ClaimTile")
            wait(1)
        end
    end
end)
]]