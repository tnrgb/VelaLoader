--[[

██╗   ██╗███████╗██╗      █████╗     ██╗  ██╗██╗   ██╗██████╗ 
██║   ██║██╔════╝██║     ██╔══██╗    ██║  ██║██║   ██║██╔══██╗
██║   ██║█████╗  ██║     ███████║    ███████║██║   ██║██████╔╝
╚██╗ ██╔╝██╔══╝  ██║     ██╔══██║    ██╔══██║██║   ██║██╔══██╗
 ╚████╔╝ ███████╗███████╗██║  ██║    ██║  ██║╚██████╔╝██████╔╝
  ╚═══╝  ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

             [ VELA HUB ] • [ ZERO × TAIIKU ]
]]--
spawn(function()
    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/ui.lua"))() 
    end)

    task.wait(7) -

    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/autojoin"))() 
    end)

    task.wait(4) -

    pcall(function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnrgb/VelaLoader/refs/heads/main/main.lua"))() 
    end)
end)
