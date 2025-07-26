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
    print("Name: " .. i);
    print("DisplayName: " .. v.DisplayName);
    print("Color: " .. v.Color)
    print("\n")
end


--[[
spawn(function()
    while wait() do
        if AutoDice then

        end
    end
end)
]]