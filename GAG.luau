-- if you are reading this then you are likely a skid i give full permission to skid off this :)

if not game:IsLoaded() then
    repeat
        task.wait()
    until game:IsLoaded()
end

if game.PlaceId ~= 126884695634066 then
    warn("Player is in the wrong game!")
    return
end

-- player stuff

local plr = game.Players.LocalPlayer
local char = plr.Character
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChild("Humanoid")

local sheckles = tonumber(plr.leaderstats.Sheckles.Value) or 0
local honey = tonumber(plr.PlayerGui.Honey_UI.Frame.TextLabel1.Text) or 0

local farm = nil

for i,v in pairs(game:GetService("Workspace").Farm:GetDescendants()) do
    if v:IsA("StringValue") and v.Value == plr.Name then
        farm = v.Parent.Parent.Parent
    end
end

if farm == nil then
    warn("Failed to find players farm!")
    return
end

-- enable teleport buttons

plr.PlayerGui.Teleport_UI.Frame.Gear.Visible = true
plr.PlayerGui.Teleport_UI.Frame.Pets.Visible = true

-- seeds

local Seeds = {}

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren()) do
    if v:IsA("Frame") and not string.find(v.Name, "Padding") then
        table.insert(Seeds, v.Name)
    end
end

-- gear

local Gear = {}

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren()) do
    if not string.find(v.Name, "Padding") and v:IsA("Frame") then
        table.insert(Gear, v.Name)
    end
end

-- eggs

local Eggs = {}
local EggModule = require(game:GetService("ReplicatedStorage").Data.PetRegistry.PetEggs)

for i,v in pairs(EggModule) do
    table.insert(Eggs, i)
end

-- weathers / events

local WeatherEvents = {}

for i,v in pairs(plr.PlayerScripts.WeatherClient:GetChildren()) do
    if v:IsA("LocalScript") then
        table.insert(WeatherEvents, v.Name)
    end
end

-- suffix

local Suffixs = {
    {value = 1e27, suffix = "Oc"},
    {value = 1e24, suffix = "Sp"},
    {value = 1e21, suffix = "Sx"},
    {value = 1e18, suffix = "Qd"},
    {value = 1e15, suffix = "Qa"},
    {value = 1e12, suffix = "T"},
    {value = 1e9, suffix = "B"},
    {value = 1e6, suffix = "M"},
    {value = 1e3, suffix = "K"},
}

local function Suffix(value)
    local p1 = math.abs(value)

    for i,v in pairs(Suffixs) do
        if p1 >= v.value then
            local num = value / v.value
            local str = string.format("%.2f", num)
            str = str:gsub("%.?0+$", "")
            return str..v.suffix
        end
    end

    return tostring(value)
end

-- gfx not mine i dont take credits but idk who owns it to credits to them :D

local mod = {}

local light = game:GetService("Lighting")
local env = getgenv()

env.conns = env.conns or {}

for i, v in pairs(env.conns) do
	pcall(v.Disconnect, v)
end

table.clear(env.conns)

local function get(i, k)
	local ok, val = pcall(function() return i[k] end)
	return ok and val or nil
end

local function set(i, k, val)
	return pcall(function() i[k] = val end)
end

env.lights = env.lights or {
	tech = { orig = get(light, "Technology"), low = Enum.Technology.Voxel },
	shadow = { orig = get(light, "GlobalShadows"), low = false },
	soft = { orig = get(light, "ShadowSoftness"), low = 0 },
	start = { orig = get(light, "FogStart"), low = 1e9 },
	endv = { orig = get(light, "FogEnd"), low = 1e9 },
}

env.parts = env.parts or {}

local function cache(v)
	if typeof(v) ~= "Instance" or not v:IsA("BasePart") then return end
	if env.parts[v] then return end
	env.parts[v] = {
		mat = get(v, "Material"),
		refl = get(v, "Reflectance"),
		shadow = get(v, "CastShadow")
	}
end

for i, v in pairs(workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		cache(v)
	end
end

table.insert(env.conns, workspace.DescendantAdded:Connect(function(v)
	if v:IsA("BasePart") then
		cache(v)
	end
end))

table.insert(env.conns, workspace.DescendantRemoving:Connect(function(v)
	if v:IsA("BasePart") then
		pcall(function()
			env.parts[v] = nil
		end)
	end
end))

function mod.toggle(on)
	for i, v in pairs(env.parts) do
		set(i, "Reflectance", on and 0 or v.refl)
		set(i, "CastShadow", on and false or v.shadow)
	end
	for i, v in pairs(env.lights) do
		set(light, i, on and v.low or v.orig)
	end
end

mod.toggle(false)

-- ui library

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = "btdcbuus",
    SubTitle = "Grow A Garden",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
}

local Tabs = {
    Home = Window:CreateTab{
        Title = "Home",
        Icon = "phosphor-users-bold"
    },
    Seeds = Window:CreateTab{
        Title = "Seeds",
        Icon = "flower"
    },
    Gear = Window:CreateTab{
        Title = "Gear",
        Icon = "package",
    },
    Shops = Window:CreateTab{
        Title = "Shops",
        Icon = "store",
    },
    Misc = Window:CreateTab{
        Title = "Misc",
        Icon = "shuffle",
    },
    Performance = Window:CreateTab{
        Title = "Performance",
        Icon = "gauge",
    },
    Logging = Window:CreateTab{
        Title = "Logging",
        Icon = "database",
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

-- home

Tabs.Home:Section("Credits")

local CreditsInfoLabel = Tabs.Home:CreateParagraph("CreditsInfoLabel", {
    Title = "Credits",
    Content = "btdcbuus_ (discord)",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

Tabs.Home:Section("Player")

local PlayerInfoLabel = Tabs.Home:CreateParagraph("PlayerUserNameLabel", {
    Title = "Welcome",
    Content = "NaN",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local TimeElapsedLabel = Tabs.Home:CreateParagraph("TimeElapsedLabel", {
    Title = "Time Elapsed",
    Content = "0 seconds",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

PlayerInfoLabel:SetValue(plr.DisplayName.." - "..plr.UserId)

-- this looks stupid to look at please ignore

local elapsed = 0

spawn(function()
    while true do
        elapsed = elapsed + 1

        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        local time

        if hours > 0 then
            time = string.format("%d hours, %02d minutes, %02d seconds", hours, minutes, seconds)
        elseif minutes > 0 then
            time = string.format("%d minutes, %02d seconds", minutes, seconds)
        else
            time = string.format("%d seconds", seconds)
        end

        TimeElapsedLabel:SetValue(time)
        wait(1)
    end
end)

Tabs.Home:Section("Currency")

local ShecklesTrackerLabel = Tabs.Home:CreateParagraph("ShecklesTrackerLabel", {
    Title = "Sheckles",
    Content = "NaN",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local HoneyTrackerLabel = Tabs.Home:CreateParagraph("HoneyTrackerLabel", {
    Title = "Honey",
    Content = "NaN",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

spawn(function()
    while wait(1) do
        sheckles = tonumber(plr.leaderstats.Sheckles.Value) or 0
        honey = tonumber(plr.PlayerGui.Honey_UI.Frame.TextLabel1.Text) or 0
        ShecklesTrackerLabel:SetValue(tostring(Suffix(sheckles)))
        HoneyTrackerLabel:SetValue(tostring(Suffix(honey)))
    end
end)

Tabs.Home:Section("Garden")

local EggsTrackerLabel = Tabs.Home:CreateParagraph("EggsTrackerLabel", {
    Title = "Eggs",
    Content = "NaN",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

local PlantsTrackerLabel = Tabs.Home:CreateParagraph("PlantsTrackerLabel", {
    Title = "Plants",
    Content = "NaN",
    TitleAlignment = "Middle",
    ContentAlignment = Enum.TextXAlignment.Center
})

spawn(function()
    while wait() do
        local CurrentEggs = 0
        local CurrentPlants = 0

        for i,v in pairs(farm.Important.Objects_Physical:GetChildren()) do
            if v.Name == "PetEgg" and v:IsA("Model") then
                CurrentEggs += 1
            end
        end

        for i,v in pairs(farm.Important.Plants_Physical:GetChildren()) do
            if v:IsA("Model") then
                CurrentPlants += 1
            end
        end

        EggsTrackerLabel:SetValue(tostring(CurrentEggs))
        PlantsTrackerLabel:SetValue(tostring(CurrentPlants))
        PlayerInfoLabel:SetValue(plr.DisplayName.." - "..plr.UserId) -- ui bugs out and makes it a different color otherwise
        CreditsInfoLabel:SetValue("btdcbuus_ (discord)") -- ui bugs out and makes it a different color otherwise
        wait(5)
    end
end)

-- shops

-- misc

Tabs.Misc:Section("Weather")

-- create all attributes in workspace :D

for i,v in pairs(WeatherEvents) do
    if not workspace:GetAttribute(v) then
        workspace:SetAttribute(v, false)
    end
end

Tabs.Misc:Section("Player")

Tabs.Misc:CreateSlider("WalkSpeedSliderFlag", {
    Title = "Walk Speed",
    Description = "Changes your players walkspeed to the value chosen 16 is default.",
    Default = 16,
    Min = 16,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = tonumber(Value)
    end
})

Tabs.Misc:CreateSlider("JumpPowerSliderFlag", {
    Title = "Jump Power",
    Description = "Changes your players jump power to the value chosen 50 is default.",
    Default = 50,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").JumpPower = tonumber(Value)
    end
})

Tabs.Misc:CreateToggle("NoClipToggleFlag", {Title = "No Clip", Default = false, Description = "Allows you to walk through walls ect", Callback = function(bool)
    NoClip = bool
end})

spawn(function()
    while wait(0.1) do
        if NoClip then
        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

Tabs.Misc:Section("Servers")

Tabs.Misc:CreateButton{Title = "Rejoin", Description = "Rejoins the current server.", Callback = function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end}

-- performance

Tabs.Performance:Section("Map")

Tabs.Performance:CreateButton{Title = "Destroy Useless", Description = "Destroys useless features on the map in an attempt to save fps and increase performance", Callback = function()
    for i,v in pairs(game:GetService("Workspace").Debris:GetChildren()) do
        v:Destroy()
    end
    for i,v in pairs(game:GetService("Workspace").Dirt_VFX:GetChildren()) do
        v:Destroy()
    end
    for i,v in pairs(game:GetService("Workspace").MapDecorations:GetChildren()) do
        v:Destroy()
    end
    for i,v in pairs(game:GetService("Workspace").WeatherVisuals:GetChildren()) do
        v:Destroy()
    end
end}

Tabs.Performance:CreateButton{Title = "Lower Quality Plants", Description = "Lowers the Quality of all plants in the map", Callback = function()
    for i,v in pairs(game:GetService("Workspace").Farm:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Animator") or v:IsA("AnimationController") then
            for c,t in pairs(v:GetPlayingAnimationTracks()) do
                t:Stop()
            end
        elseif v:IsA("BasePart") then
            v.Reflectance = 0
            v.CastShadow = false
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end}

Tabs.Performance:Section("Quality")

Tabs.Performance:CreateToggle("LowGFXToggleFlag", {Title = "Low GFX", Default = false, Description = "Lowers and Removes all the GFX possible.", Callback = function(bool)
    mod.toggle(bool)
end})

Tabs.Performance:CreateButton{Title = "Low Poly", Description = "Edits the workspace ingame to be smooth plastic material instead.", Callback = function()
    for i,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end}

Tabs.Performance:CreateButton{Title = "Remove Decals", Description = "Removes all decals on the map in an attempt to save fps.", Callback = function()
    for i,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end}

Tabs.Performance:Section("Fps")

Tabs.Performance:CreateToggle("3dRenderingToggleFlag", {Title = "3D Rendering", Default = false, Description = "Activates run services 3d rendering saves alot of fps", Callback = function(bool)
    game:GetService("RunService"):Set3dRenderingEnabled(not bool)
end})

Tabs.Performance:CreateInput("FPSCapInput", { Title = "Fps Cap", Description = "Changes the Roblox fps cap to whatever is inputted", Default = "1000", Placeholder = "Enter Fps", Numeric = true, Finished = true, Callback = function(int)
    setfpscap(tonumber(int))
end})

-- settings

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes{}
InterfaceManager:SetFolder("btdcbuus")
SaveManager:SetFolder("btdcbuus/GAG")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- useless since most executors support anti afk already

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if game:GetService("GuiService"):GetErrorType() == Enum.ConnectionError.DisconnectErrors then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end)

game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)