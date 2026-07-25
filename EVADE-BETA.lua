local function load(url)
    return loadstring(game:HttpGet(url))()
end

-- 1. Load Auto Join trước
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
task.wait(0.5)

-- 2. Đưa UI lên giữa
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
task.wait(0.5)

-- 3. Cho Main xuống cuối cùng
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
