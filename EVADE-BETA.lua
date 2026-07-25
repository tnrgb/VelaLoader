local function loadAsync(url)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end)
end

loadAsync("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
task.wait(0.5)
loadAsync("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
task.wait(0.5)
loadAsync("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
