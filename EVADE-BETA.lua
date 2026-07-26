--[[

██╗   ██╗███████╗██╗      █████╗     ██╗  ██╗██╗   ██╗██████╗ 
██║   ██║██╔════╝██║     ██╔══██╗    ██║  ██║██║   ██║██╔══██╗
██║   ██║█████╗  ██║     ███████║    ███████║██║   ██║██████╔╝
╚██╗ ██╔╝██╔══╝  ██║     ██╔══██║    ██╔══██║██║   ██║██╔══██╗
 ╚████╔╝ ███████╗███████╗██║  ██║    ██║  ██║╚██████╔╝██████╔╝
  ╚═══╝  ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

             [ VELA HUB ] • [ ZERO × TAIIKU ]
]]--

task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua"))()
    end)

    task.wait(5.5)

    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin"))()
    end)

    task.wait(2)

    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua"))()
    end)
end)
