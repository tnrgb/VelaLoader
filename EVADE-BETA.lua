local function load(url)
    return loadstring(game:HttpGet(url))()
end

load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")

load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
task.wait(0.2)
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
