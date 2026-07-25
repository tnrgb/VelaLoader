local function load(url)
    return loadstring(game:HttpGet(url .. "?v=" .. tick()))()
end

load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
task.wait7)

load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
task.wait(3)

load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
