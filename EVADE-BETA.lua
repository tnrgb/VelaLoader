local function load(url)
    return loadstring(game:HttpGet(url))()
end

-- Tải Auto Join trước và chờ ổn định
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin")
task.wait(1) -- Chờ 1 giây cho autojoin chạy xong logic ban đầu

-- Tải Main script
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua")
task.wait(0.8)

-- Tải UI cuối cùng
load("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua")
