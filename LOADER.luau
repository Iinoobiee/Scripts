local Supported = {
    ["126884695634066"] = "https://raw.githubusercontent.com/Iinoobiee/Scripts/refs/heads/main/games/GrowAGarden.luau",
}

if not Supported[tostring(game.PlaceId)] then
    return warn("Place Id not Supported")
end

loadstring(game:HttpGet(Supported[tostring(game.PlaceId)]))()