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

return mod