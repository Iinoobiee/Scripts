local Supported = {
    ["126884695634066"] = "https://raw.githubusercontent.com/Iinoobiee/Scripts/refs/heads/main/GAG.luau",
}

if not Supported[tostring(game.PlaceId)] then
    return
end

loadstring(game:HttpGet(Supported[tostring(game.PlaceId)]))()