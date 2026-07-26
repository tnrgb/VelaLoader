local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local AfkFarmEnabled = true
local AutoItemEnabled = true
local savedAfkState = true
local savedCollectState = true

local originalPosition = nil
local noItemTimer = 0 

local function isPlayerAsset(instance)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and instance:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end

local function getAllItems()
    local items = {}
    --
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("BasePart") or v:IsA("Model") then
            local nameLower = string.lower(v.Name)
            if string.find(nameLower, "bubble") or string.find(nameLower, "coconut") then
                local isVisualEffect = v:FindFirstChildWhichIsA("ParticleEmitter") 
                                    or v:FindFirstChildWhichIsA("Trail") 
                                    or v:FindFirstChildWhichIsA("Beam")
                                    or v.ClassName == "Accessory"
                local hasAnimation = v:FindFirstChildWhichIsA("Animation") or v:FindFirstChildWhichIsA("Animator")
                
                if not isVisualEffect and not hasAnimation and not isPlayerAsset(v) then
                    local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                    if part then
                        table.insert(items, part)
                    end
                end
            end
        end
    end
    return items
end

local function isNextbotNear(position)
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:GetAttribute("Nextbot") == true then
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                local distance = (position - root.Position).Magnitude
                if distance <= 12 then 
                    return true
                end
            end
        end
    end
    return false
end

local function getClosestSafeItem(hrp, items)
    local closest, minDst = nil, math.huge
    for _, part in ipairs(items) do
        local dst = (hrp.Position - part.Position).Magnitude
        if dst < minDst and not isNextbotNear(part.Position) then
            closest = part
            minDst = dst
        end
    end
    return closest
end

local function teleportTo(hrp, pos, duration)
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

task.spawn(function()
    while true do
        local items = getAllItems()
        local char = LocalPlayer.Character
        local isDowned = char and char:GetAttribute("Downed")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if #items == 0 then
            noItemTimer = noItemTimer + 0.5
            if noItemTimer >= 20 then
                if AfkFarmEnabled then
                    AfkFarmEnabled = false
                    if hrp then hrp.Anchored = false end
                end
            end
        else
            if noItemTimer >= 20 and savedAfkState and not isDowned then
                task.wait(1)
                if hrp then
                    AfkFarmEnabled = true
                    originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                    hrp.CFrame = CFrame.new(originalPosition)
                    task.wait(0.1)
                    hrp.Anchored = true
                end
            end
            noItemTimer = 0
        end

        if AutoItemEnabled and not isDowned and #items > 0 then
            if hrp then
                local item = getClosestSafeItem(hrp, items)
                if item then
                    local startPos = hrp.Position
                    hrp.Anchored = false
                    
                    teleportTo(hrp, item.Position, 0.2)
                    
                    pcall(function()
                        local collectId = item.Parent:GetAttribute("Id") or item:GetAttribute("Id") or "a19ac91bff904b7385e826fd6a23dc01"
                        ReplicatedStorage.Events.Collectibles.Invoke:InvokeServer(LocalPlayer, collectId, "Collect")
                    end)
                    
                    task.wait(1)
                    isDowned = char and char:GetAttribute("Downed")
                    
                    if AutoItemEnabled and not isDowned and noItemTimer < 20 then
                        if AfkFarmEnabled and originalPosition then
                            teleportTo(hrp, originalPosition, 0.2)
                            hrp.Anchored = true
                        else
                            teleportTo(hrp, startPos, 0.2)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        task.wait(2) 
        local char = LocalPlayer.Character
        local isDowned = char and char:GetAttribute("Downed")
        
        if AfkFarmEnabled and not AutoItemEnabled and not isDowned and noItemTimer < 20 then
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored == false then
                originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                hrp.CFrame = CFrame.new(originalPosition)
                task.wait(0.1)
                hrp.Anchored = true
            end
        end
    end
end)

local function setupCharacter(char)
    char:GetAttributeChangedSignal("Downed"):Connect(function()
        local isDowned = char:GetAttribute("Downed")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if isDowned then
            AutoItemEnabled = false
            AfkFarmEnabled = false
            if hrp then hrp.Anchored = false end
        else
            task.wait(1)
            if hrp then
                originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                hrp.CFrame = CFrame.new(originalPosition)
                task.wait(0.2)
                hrp.Anchored = true
                
                AfkFarmEnabled = savedAfkState
                AutoItemEnabled = savedCollectState
            end
        end
    end)

    task.spawn(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp and AfkFarmEnabled then
            originalPosition = hrp.Position + Vector3.new(0, 200, 0)
            hrp.CFrame = CFrame.new(originalPosition)
            task.wait(0.1)
            hrp.Anchored = true
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

LocalPlayer.Idled:Connect(function()
    local virtualUser = game:GetService("VirtualUser")
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new(0, 0))
end)local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local AfkFarmEnabled = true
local AutoItemEnabled = true
local savedAfkState = true
local savedCollectState = true

local originalPosition = nil
local noItemTimer = 0 

local function isPlayerAsset(instance)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and instance:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end

local function getAllItems()
    local items = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("Model")) then
            local nameLower = string.lower(v.Name)
            if string.find(nameLower, "bubble") or string.find(nameLower, "coconut") then
                local isVisualEffect = v:FindFirstChildWhichIsA("ParticleEmitter") 
                                    or v:FindFirstChildWhichIsA("Trail") 
                                    or v:FindFirstChildWhichIsA("Beam")
                                    or v.ClassName == "Accessory"
                local hasAnimation = v:FindFirstChildWhichIsA("Animation") or v:FindFirstChildWhichIsA("Animator")
                
                if not isVisualEffect and not hasAnimation and not isPlayerAsset(v) then
                    local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                    if part then
                        table.insert(items, part)
                    end
                end
            end
        end
    end
    return items
end

local function isNextbotNear(position)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:GetAttribute("Nextbot") == true then
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                local distance = (position - root.Position).Magnitude
                if distance <= 12 then 
                    return true
                end
            end
        end
    end
    return false
end

local function getClosestSafeItem(hrp, items)
    local closest, minDst = nil, math.huge
    for _, part in ipairs(items) do
        local dst = (hrp.Position - part.Position).Magnitude
        if dst < minDst and not isNextbotNear(part.Position) then
            closest = part
            minDst = dst
        end
    end
    return closest
end

local function teleportTo(hrp, pos, duration)
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

task.spawn(function()
    while true do
        local items = getAllItems()
        local char = LocalPlayer.Character
        local isDowned = char and char:GetAttribute("Downed")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if #items == 0 then
            noItemTimer = noItemTimer + 0.5
            if noItemTimer >= 20 then
                if AfkFarmEnabled then
                    AfkFarmEnabled = false
                    if hrp then hrp.Anchored = false end
                end
            end
        else
            if noItemTimer >= 20 and savedAfkState and not isDowned then
                task.wait(1)
                if hrp then
                    AfkFarmEnabled = true
                    originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                    hrp.CFrame = CFrame.new(originalPosition)
                    task.wait(0.1)
                    hrp.Anchored = true
                end
            end
            noItemTimer = 0
        end

        if AutoItemEnabled and not isDowned and #items > 0 then
            if hrp then
                local item = getClosestSafeItem(hrp, items)
                if item then
                    local startPos = hrp.Position
                    hrp.Anchored = false
                    
                    teleportTo(hrp, item.Position, 0.2)
                    
                    pcall(function()
                        local collectId = item.Parent:GetAttribute("Id") or item:GetAttribute("Id") or "a19ac91bff904b7385e826fd6a23dc01"
                        ReplicatedStorage.Events.Collectibles.Invoke:InvokeServer(LocalPlayer, collectId, "Collect")
                    end)
                    
                    task.wait(1)
                    isDowned = char and char:GetAttribute("Downed")
                    
                    if AutoItemEnabled and not isDowned and noItemTimer < 20 then
                        if AfkFarmEnabled and originalPosition then
                            teleportTo(hrp, originalPosition, 0.2)
                            hrp.Anchored = true
                        else
                            teleportTo(hrp, startPos, 0.2)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        task.wait(2) 
        local char = LocalPlayer.Character
        local isDowned = char and char:GetAttribute("Downed")
        
        if AfkFarmEnabled and not AutoItemEnabled and not isDowned and noItemTimer < 20 then
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored == false then
                originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                hrp.CFrame = CFrame.new(originalPosition)
                task.wait(0.1)
                hrp.Anchored = true
            end
        end
    end
end)

local function setupCharacter(char)
    char:GetAttributeChangedSignal("Downed"):Connect(function()
        local isDowned = char:GetAttribute("Downed")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if isDowned then
            AutoItemEnabled = false
            AfkFarmEnabled = false
            if hrp then hrp.Anchored = false end
        else
            task.wait(1)
            if hrp then
                originalPosition = hrp.Position + Vector3.new(0, 200, 0)
                hrp.CFrame = CFrame.new(originalPosition)
                task.wait(0.2)
                hrp.Anchored = true
                
                AfkFarmEnabled = savedAfkState
                AutoItemEnabled = savedCollectState
            end
        end
    end)

    task.spawn(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp and AfkFarmEnabled then
            originalPosition = hrp.Position + Vector3.new(0, 200, 0)
            hrp.CFrame = CFrame.new(originalPosition)
            task.wait(0.1)
            hrp.Anchored = true
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

LocalPlayer.Idled:Connect(function()
    local virtualUser = game:GetService("VirtualUser")
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new(0, 0))
end)
