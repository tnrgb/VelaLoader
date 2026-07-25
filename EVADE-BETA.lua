local function load(url)
    return loadstring(game:HttpGet(url))()
end

-- 1. Load UI lên đầu tiên
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
task.wait(1.5) -- Đợi 1s để UI khởi tạo xong

-- 2. Load Auto Join thứ hai
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
task.wait(0.8) -- Đợi 0.8s

-- 3. Load Main cuối cùng
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
