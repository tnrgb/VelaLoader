local function load(url)
    return loadstring(game:HttpGet(url))()
end

-- 1. Load UI lên đầu tiên
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")

task.wait(100)

-- 2. Load Auto Join thứ hai
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")

task.wait(30)

-- 3. Load Main cuối cùng
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
