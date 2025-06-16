repeat
    wait()
until game:IsLoaded()

if game.PlaceId ~= 126884695634066 then
    warn("Player is in the wrong game!")
    return
end

for i,v in pairs(game.ReplicatedFirst:GetDescendants()) do
    if v:IsA("LocalScript") then
        v.Disabled = true
    end
end

-- player stuff

local plr = game.Players.LocalPlayer
local char = plr.Character
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChild("Humanoid")

repeat
    wait()
until game.Players.LocalPlayer:FindFirstChild("leaderstats")

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

-- cosmetics

local Cosmetics = {}
local CosmeticsModule = require(game:GetService("ReplicatedStorage").Data.CosmeticRegistry.CosmeticList)
local CrateModule = require(game:GetService("ReplicatedStorage").Data.CosmeticCrateShopData)

for i,v in pairs(CosmeticsModule) do
    table.insert(Cosmetics, i)
end

for i,v in pairs(CrateModule) do
    table.insert(Cosmetics, i)
end


-- honey shop

local HoneyShop = {}
local HoneyShopModule = require(game:GetService("ReplicatedStorage").Data.HoneyEventShopData)

for i,v in pairs(HoneyShopModule) do
    table.insert(HoneyShop, i)
end

-- weathers / events

local WeatherEvents = {}

for i,v in pairs(plr.PlayerScripts.WeatherClient:GetChildren()) do
    table.insert(WeatherEvents, v.Name)
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

-- gfx not mine i dont take credits but idk who owns it to credits to them

local mod = {}

local light = game:GetService("Lighting")
local env = getgenv()

env.conns = env.conns or {}

for i,v in pairs(env.conns) do
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

for i,v in pairs(workspace:GetDescendants()) do
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
    Garden = Window:CreateTab{
        Title = "Garden",
        Icon = "flower"
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
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

-- home

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

local elapsed = 0

spawn(function()
    while wait() do
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
    while wait(1.5) do
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
        wait(5)
    end
end)

-- garden

local Selling = false

Tabs.Garden:Section("Honey")

local AutoHoneyBlacklist = {}

Tabs.Garden:CreateToggle("AutoHoneyToggleFlag", {Title = "Auto Honey", Default = false, Description = "automatically farms honey from the fruits that are in your inventory", Callback = function(bool)
    AutoHoney = bool
end})

Tabs.Garden:CreateDropdown("AutoHoneyBlacklistFlag", {Title = "Select Blacklists", Values = Seeds, Multi = true, Searchable = true, Description = "Select the Types of Fruits that this will blacklist from trading as honey", Default = {}, Callback = function(str)
    table.clear(AutoHoneyBlacklist)
    for i,v in pairs(str) do
        table.insert(AutoHoneyBlacklist, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoHoney then
            if not string.find(workspace.HoneyEvent.HoneyCombpressor.Sign.SurfaceGui.TextLabel.Text, "KG") then
                game:GetService("ReplicatedStorage").GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                wait(1)
            else
                for i,v in pairs(plr.Backpack:GetChildren()) do
                    if v:FindFirstChild("Item_Seed") and string.find(v.Name:lower(), "pollinated") and v:IsA("Tool") then
                        for c,d in pairs(AutoHoneyBlacklist) do
                            if not string.find(v.Name, d) then
                                v.Parent = char
                                wait(0.5)
                                game:GetService("ReplicatedStorage").GameEvents.HoneyMachineService_RE:FireServer("MachineInteract")
                                wait(0.5)
                                break  
                            end
                        end
                    end
                end
            end
            wait(0.25)
        end
    end
end)

Tabs.Garden:Section("Planting")

local AutoPlantRange = 10

Tabs.Garden:CreateToggle("AutoPlantToggleFlag", {Title = "Auto Plant", Default = false, Description = "automatically plants seeds in your inventory on your garden in a random position", Callback = function(bool)
    AutoPlant = bool
end})

Tabs.Garden:CreateSlider("AutoPlantSliderFlag", {
    Title = "Plant Range",
    Description = "Adjust the range for auto plant using this slider",
    Default = 10,
    Min = 5,
    Max = 20,
    Rounding = 0,
    Callback = function(Value)
        AutoPlantRange = Value
    end
})

local function plant(seed)
	local lands = {}

	for i,v in pairs(farm.Important.Plant_Locations:GetChildren()) do
		table.insert(lands, v)
	end

	if #lands > 0 then
		local pick = lands[math.random(1, #lands)]
		local pos = pick.Position + Vector3.new(math.random(-AutoPlantRange, AutoPlantRange), math.random(-AutoPlantRange, AutoPlantRange), math.random(-AutoPlantRange, AutoPlantRange))
		game.ReplicatedStorage.GameEvents.Plant_RE:FireServer(pos, seed)
	end
end

spawn(function()
	while wait(0.1) do
		if AutoPlant then
			for i,v in pairs(plr.Backpack:GetChildren()) do
				if string.match(v.Name, "Seed") then
					char.Humanoid:EquipTool(v)
					wait(0.1)
					plant(string.split(v.Name, " ")[1])
				end
			end

			for i,v in pairs(char:GetChildren()) do
				if string.match(v.Name, "Seed") then
					plant(string.split(v.Name, " ")[1])
				end
			end

			wait(0.1)
		end
	end
end)

Tabs.Garden:Section("Collecting")

local AutoCollectMethod = ""
local AutoCollectBlacklist = {}

local CollectionsMethods = {
    "Teleport",
    "Normal",
}

Tabs.Garden:CreateToggle("AutoCollectToggleFlag", {Title = "Auto Collect", Default = false, Description = "automatically collects your garden plants", Callback = function(bool)
    AutoCollect = bool
end})

Tabs.Garden:CreateDropdown("AutoCollectSelectionFlag", {Title = "Select Collection Method", Values = CollectionsMethods, Multi = false, Searchable = true, Description = "Select the method for auto collect", Default = "", Callback = function(str)
    AutoCollectMethod = str
end})

Tabs.Garden:CreateDropdown("AutoCollectBlacklistFlag", {Title = "Select Blacklists", Values = Seeds, Multi = true, Searchable = true, Description = "Whatever is selected here will be blacklisted from auto collect", Default = {}, Callback = function(str)
    table.clear(AutoCollectBlacklist)
    for i,v in pairs(str) do
        table.insert(AutoCollectBlacklist, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoCollect then
            for i,v in pairs(farm.Important.Plants_Physical:GetDescendants()) do
                if v:IsA("ProximityPrompt") and AutoCollect then
                    print(v.Parent.Parent.Name)
                    if not table.find(AutoCollectBlacklist, v.Parent.Parent.Name) then
                        if AutoCollectMethod == "Teleport" and v.Parent:IsA("Part") then
                            if Selling then
                                repeat 
                                    wait(0.2)
                                until not Selling
                                wait(1)
                            end
                            root.CFrame = v.Parent.CFrame
                            wait(0.1)
                        end
                        fireproximityprompt(v)
                    end
                end
            end
        end
    end
end)

Tabs.Garden:Section("Selling")

local AutoSellAmount = 10

Tabs.Garden:CreateToggle("AutoSellToggleFlag", {Title = "Auto Sell", Default = false, Description = "automatically sells your inventory when you are at the target amount", Callback = function(bool)
    AutoSell = bool
end})

Tabs.Garden:CreateSlider("AuroSellSliderFlag", {
    Title = "Sell Amount",
    Description = "Adjust the range for auto sell using this slider",
    Default = 10,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Callback = function(Value)
        AutoSellAmount = Value
    end
})

spawn(function()
    while wait(0.1) do
        if AutoSell then
            local count = 0

            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                for c,d in pairs(Seeds) do
                    if string.find(v.Name, d) and not string.find(v.Name, "Seed") then
                        count += 1
                    end
                end
            end

            if count >= AutoSellAmount then
                Selling = true
                local old = root.CFrame
                root.CFrame = workspace.Tutorial_Points.Tutorial_Point_2.CFrame
                wait(0.5)
                game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
                wait(0.5)
                root.CFrame = old
                Selling = false
            end
            wait(1.5)
        end
    end
end)

Tabs.Garden:Section("Watering")

local SelectedPlant = ""
local WantedPercentage = 100

Tabs.Garden:CreateToggle("AutoWaterToggleFlag", {Title = "Auto Water", Default = false, Description = "automatically waters plants selected in your garden", Callback = function(bool)
    AutoWater = bool
end})

Tabs.Garden:CreateDropdown("AutoWaterSelectionFlag", {Title = "Select Plant Type", Values = Seeds, Multi = false, Searchable = true, Description = "Select the Seed Type to Automatically Water", Default = "", Callback = function(str)
    SelectedPlant = tostring(str)
end})

Tabs.Garden:CreateSlider("AutoWaterPercentageFlag", {
    Title = "Percentage Amount",
    Description = "The percentage amount that it will stop watering at",
    Default = 100,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        WantedPercentage = Value
    end
})

spawn(function()
    while wait(0.1) do
        if AutoWater then
            for i,v in pairs(farm.Important.Plants_Physical:GetChildren()) do
                if v.Name == SelectedPlant then
                    if v.Grow.Age.Value < v:GetAttribute("MaxAge") and (v.Grow.Age.Value / v:GetAttribute("MaxAge")) * 100 < WantedPercentage then
                        for c,d in pairs(plr.Backpack:GetChildren()) do
                            if string.find(d.Name, "Watering") then
                                d.Parent = game.Players.LocalPlayer.Character
                                break
                            end
                        end
                        game:GetService("ReplicatedStorage").GameEvents.Water_RE:FireServer(v:FindFirstChildWhichIsA("Part").Position)
                        wait(1)
                        break
                    end
                end
            end
            wait(1.5)
        end
    end
end)

Tabs.Garden:Section("Hatching")

Tabs.Garden:CreateToggle("AutoHatchToggleFlag", {Title = "Auto Hatch", Default = false, Description = "automatically hatches eggs in your garden", Callback = function(bool)
    AutoHatch = bool
end})

spawn(function()
    while wait(0.1) do
        if AutoHatch then
            for i,v in pairs(farm.Important.Objects_Physical:GetChildren()) do
                if v.Name == "PetEgg" then
                    game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer("HatchPet", v)
                    wait(0.5)
                end
            end
            wait(2)
        end
    end
end)

Tabs.Garden:CreateToggle("AutoPlaceEggsToggleFlag", {Title = "Auto Place Eggs", Default = false, Description = "automatically places eggs in your garden when they are not 3/3", Callback = function(bool)
    AutoPlaceEggs = bool
end})

spawn(function()
    while wait(0.1) do
        if AutoPlaceEggs then
            local CurrentEggs = 0

            for i,v in pairs(farm.Important.Objects_Physical:GetChildren()) do
                if v.Name == "PetEgg" and v:IsA("Model") then
                    CurrentEggs += 1
                end
            end

            if CurrentEggs < 3 then
                for i,v in pairs(plr.Backpack:GetChildren()) do
                    if string.find(v.Name:lower(), "egg") then
                        v.Parent = char
                        wait(0.5)
                        local lands = {}

                        for i,v in pairs(farm.Important.Plant_Locations:GetChildren()) do
                            table.insert(lands, v)
                        end

                        if #lands > 0 then
                            local pick = lands[math.random(1, #lands)]
                            local pos = pick.Position + Vector3.new(math.random(-AutoPlantRange, AutoPlantRange), math.random(-AutoPlantRange, AutoPlantRange), math.random(-AutoPlantRange, AutoPlantRange))
                            game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer("CreateEgg", pos)
                        end
                        break
                    end
                end
            end
        end
    end
end)

Tabs.Garden:CreateToggle("AutoPlacePetToggleFlag", {Title = "Auto Place Pets", Default = false, Description = "automatically places pets in your garden when they are not 3/3", Callback = function(bool)
    AutoPlacePets = bool
end})

spawn(function()
    while wait(0.1) do
        if AutoPlacePets then
            local PetCount = 0
            for i,v in pairs(plr.PlayerGui.ActivePetUI.Frame.Main.ScrollingFrame:GetChildren()) do
                if string.find(v.Name, "{") then
                    PetCount += 1
                end
            end
            if PetCount < 3 then
                for i,v in pairs(plr.Backpack:GetChildren()) do
                    if string.find(v.Name, "Age") then
                        v.Parent = game.Players.LocalPlayer.Character
                        game:GetService("ReplicatedStorage").GameEvents.PetsService:FireServer("EquipPet", tostring(v:GetAttribute("PET_UUID")), CFrame.new(-92.942894, 0, 81.6487808, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                        break
                    end
                end
            end
            wait(1)
        end
    end
end)

-- shops

Tabs.Shops:Section("Seeds")

local SelectedSeeds = {}

Tabs.Shops:CreateToggle("AutoBuySeedsToggleFlag", {Title = "Auto Buy", Default = false, Description = "automatically buys the selected seeds.", Callback = function(bool)
    AutoBuySeeds = bool
end})

Tabs.Shops:CreateDropdown("ShopsSeedsSelectionFlag", {Title = "Select Seeds", Values = Seeds, Multi = true, Searchable = true, Description = "Select the Seeds that the Toggle above will target when Toggled.", Default = {}, Callback = function(str)
    table.clear(SelectedSeeds)
    for i,v in pairs(str) do
        table.insert(SelectedSeeds, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoBuySeeds then
            for i,v in SelectedSeeds do
                game:GetService("ReplicatedStorage").GameEvents.BuySeedStock:FireServer(v)
            end
            wait(0.1)
        end
    end
end)

Tabs.Shops:Section("Gear")

local SelectedGears = {}

Tabs.Shops:CreateToggle("AutoBuyGearToggleFlag", {Title = "Auto Buy", Default = false, Description = "automatically buys the selected gear.", Callback = function(bool)
    AutoBuyGear = bool
end})

Tabs.Shops:CreateDropdown("ShopsGearSelectionFlag", {Title = "Select Gears", Values = Gear, Multi = true, Searchable = true, Description = "Select the Gear that the Toggle above will target when Toggled.", Default = {}, Callback = function(str)
    table.clear(SelectedGears)
    for i,v in pairs(str) do
        table.insert(SelectedGears, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoBuyGear then
            for i,v in SelectedGears do
                game:GetService("ReplicatedStorage").GameEvents.BuyGearStock:FireServer(v)
            end
            wait(0.1)
        end
    end
end)

Tabs.Shops:Section("Eggs")

local SelectedEggs = {}
local PurchasedEggs = {}

Tabs.Shops:CreateToggle("AutoBuyEggToggleFlag", {Title = "Auto Buy", Default = false, Description = "automatically buys the selected eggs.", Callback = function(bool)
    AutoBuyEggs = bool
end})

Tabs.Shops:CreateDropdown("ShopsEggsSelectionFlag", {Title = "Select Eggs", Values = Eggs, Multi = true, Searchable = true, Description = "Select the Eggs that the Toggle above will target when Toggled.", Default = {}, Callback = function(str)
    table.clear(SelectedEggs)
    for i,v in pairs(str) do
        table.insert(SelectedEggs, i)
    end
end})

-- this is such a bad method of detecting it but it works

spawn(function()
    while wait(0.1) do
        if AutoBuyEggs then
            for i,v in pairs(workspace.NPCS["Pet Stand"].EggLocations:GetChildren()) do
                if table.find(SelectedEggs, v.Name) and not table.find(PurchasedEggs, v) then
                    local val = 0
                    if tostring(v.WorldPivot) == "-289.039246, 2.79752779, 11.7703476, 1, 0, 0, 0, 1, 0, 0, 0, 1" then
                        val = 2
                    elseif tostring(v.WorldPivot) == "-289.031219, 2.79752779, 7.74039459, 1, 0, 0, 0, 1, 0, 0, 0, 1" then
                        val = 3
                    elseif tostring(v.WorldPivot) == "-289.04126, 2.87552762, 3.73038578, 1, 0, 0, 0, 1, 0, 0, 0, 1" then
                        val = 1
                    end
                    if val ~= 0 then
                        game:GetService("ReplicatedStorage").GameEvents.BuyPetEgg:FireServer(val)
                        table.insert(PurchasedEggs, v)
                    end
                    wait(1)
                end
            end
            wait(2)
        end
    end
end)

Tabs.Shops:Section("Cosmetics")

local SelectedCosmetics = {}

Tabs.Shops:CreateToggle("AutoBuyCosmeticsToggleFlag", {Title = "Auto Buy", Default = false, Description = "automatically buys the selected cosmetics.", Callback = function(bool)
    AutoBuyCosmetics = bool
end})

Tabs.Shops:CreateDropdown("ShopsCosmeticsSelectionFlag", {Title = "Select Cosmetics", Values = Cosmetics, Multi = true, Searchable = true, Description = "Select the Cosmetics that the Toggle above will target when Toggled.", Default = {}, Callback = function(str)
    table.clear(SelectedCosmetics)
    for i,v in pairs(str) do
        table.insert(SelectedCosmetics, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoBuyCosmetics then
            for i,v in pairs(SelectedCosmetics) do
                game:GetService("ReplicatedStorage").GameEvents.BuyCosmeticCrate:FireServer(v)
                game:GetService("ReplicatedStorage").GameEvents.BuyCosmeticItem:FireServer(v)
                wait(0.5)
            end
            wait(2.5)
        end
    end
end)

Tabs.Shops:Section("Honey Shop")

local SelectedHoney = {}

Tabs.Shops:CreateToggle("AutoBuyHoneyToggleFlag", {Title = "Auto Buy", Default = false, Description = "automatically buys the selected honey shop items.", Callback = function(bool)
    AutoBuyHoney = bool
end})

Tabs.Shops:CreateDropdown("ShopsHoneySelectionFlag", {Title = "Select Honey Shop Items", Values = HoneyShop, Multi = true, Searchable = true, Description = "Select the Shop Items that the Toggle above will target when Toggled.", Default = {}, Callback = function(str)
    table.clear(SelectedHoney)
    for i,v in pairs(str) do
        table.insert(SelectedHoney, i)
    end
end})

spawn(function()
    while wait(0.1) do
        if AutoBuyHoney then
            for i,v in pairs(SelectedHoney) do
                game:GetService("ReplicatedStorage").GameEvents.BuyEventShopStock:FireServer(v)
                wait(0.5)
            end
            wait(2.5)
        end
    end
end)

-- misc

Tabs.Misc:Section("Weather")

-- create all attributes in workspace

for i,v in pairs(WeatherEvents) do
    if not workspace:GetAttribute(v) then
        workspace:SetAttribute(v, false) -- default to false otherwise it will be playing
    end
end

Tabs.Misc:CreateToggle("WeatherEditorToggleFlag", {Title = "Spawn Weather", Default = false, Description = "Spawns the Weather Selected into the game some may not work.", Callback = function(bool)
    SpawnWeather = bool
end})

spawn(function()
    while wait(0.1) do
        if SpawnWeather then
            workspace:SetAttribute(SelectedWeather, true)
        end
    end
end)

Tabs.Misc:CreateButton{Title = "Remove Weather", Description = "Removes the current Selected Weather.", Callback = function()
    workspace:SetAttribute(SelectedWeather, false)
end}

Tabs.Misc:CreateDropdown("WeatherEditorSelectionFlag", {Title = "Select Weather", Values = WeatherEvents, Multi = false, Searchable = true, Description = "Select the Weather that the Toggle above will target when Toggled.", Default = "", Callback = function(str)
    SelectedWeather = tostring(str) 
end})

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

Tabs.Performance:CreateToggle("TabOutFpsChangerFlag", {Title = "Change FPS when Window is not focused", Default = false, Description = "When the current Roblox window is not focused this will set your fps to what is entered", Callback = function(bool)
    TabToggle = bool
end})

Tabs.Performance:CreateInput("FPSCapInput", { Title = "Window Fps Amount", Description = "The amount of fps wanted when tabbed out of the Roblox Window", Default = "30", Placeholder = "Enter Fps", Numeric = true, Finished = true, Callback = function(int)
    wantedwindowfps = int
end})

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    if not TabToggle then return end
    setfpscap(tonumber(wantedwindowfps))
end)

game:GetService("UserInputService").WindowFocused:Connect(function()
    if not TabToggle then return end
    setfpscap(1000)
end)

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

-- useless since most executors automatically have anti afk already

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if game:GetService("GuiService"):GetErrorType() == Enum.ConnectionError.DisconnectErrors then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end)

game.Players.LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):CaptureController()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)