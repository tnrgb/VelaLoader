local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Cấu hình mặc định
local AfkFarmEnabled = true
local AutoItemEnabled = true
local savedAfkState = true
local savedCollectState = true

local HEIGHT_OFFSET = 250 -- Độ cao tuốt trên trời
local originalPosition = nil
local safePlatform = nil
local noItemTimer = 0 

-- Hàm tạo bệ đứng tạm thời trên trời để không bị rơi
local function createSafePlatform(pos)
    if not safePlatform or not safePlatform.Parent then
        safePlatform = Instance.new("Part")
        safePlatform.Name = "SafeAFKPlatform"
        safePlatform.Size = Vector3.new(12, 2, 12)
        safePlatform.Anchored = true
        safePlatform.CanCollide = true
        safePlatform.Transparency = 0.5 -- Nhìn xuyên qua nhẹ
        safePlatform.Material = Enum.Material.ForceField
        safePlatform.Parent = workspace
    end
    safePlatform.CFrame = CFrame.new(pos - Vector3.new(0, 2, 0))
end

local function isPlayerAsset(instance)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and instance:IsDescendantOf(player.Character) then
            return true
        end
    end
    return false
end

-- Tối ưu quét Item nhanh không giật lag
local function getAllItems()
    local items = {}
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

-- Kiểm tra xem Nextbot có đang ở gần vị trí chỉ định không (Bán kính 25 stud)
local function isNextbotNear(position, radius)
    radius = radius or 25
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:GetAttribute("Nextbot") == true then
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                local distance = (position - root.Position).Magnitude
                if distance <= radius then 
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
        if dst < minDst and not isNextbotNear(part.Position, 15) then
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

-- Vòng lặp tự động di chuyển bệ đứng nếu có Nextbot tiến lại gần trên trời
task.spawn(function()
    while true do
        task.wait(0.3)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local isDowned = char and char:GetAttribute("Downed")

        if AfkFarmEnabled and not isDowned and hrp and originalPosition then
            -- Nếu Nextbot tiến gần bệ đứngAFK trong khoảng 30 studs
            if isNextbotNear(hrp.Position, 30) then
                -- Teleport xê dịch bệ + nhân vật sang tọa độ né tạm thời (+50 studs)
                local dodgePos = originalPosition + Vector3.new(50, 0, 50)
                createSafePlatform(dodgePos)
                hrp.CFrame = CFrame.new(dodgePos)
            else
                -- Khi an toàn thì quay lại vị trí bệ chính
                createSafePlatform(originalPosition)
                if (hrp.Position - originalPosition).Magnitude > 10 and not AutoItemEnabled then
                    hrp.CFrame = CFrame.new(originalPosition)
                end
            end
        end
    end
end)

-- Vòng lặp chính xử lý nhặt Item
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
                    if safePlatform then safePlatform:Destroy() end
                end
            end
        else
            if noItemTimer >= 20 and savedAfkState and not isDowned then
                task.wait(1)
                if hrp then
                    AfkFarmEnabled = true
                    originalPosition = hrp.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
                    createSafePlatform(originalPosition)
                    hrp.CFrame = CFrame.new(originalPosition)
                end
            end
            noItemTimer = 0
        end

        if AutoItemEnabled and not isDowned and #items > 0 then
            if hrp then
                local item = getClosestSafeItem(hrp, items)
                if item then
                    local startPos = hrp.Position
                    
                    teleportTo(hrp, item.Position, 0.2)
                    
                    pcall(function()
                        local collectId = item.Parent:GetAttribute("Id") or item:GetAttribute("Id") or "a19ac91bff904b7385e826fd6a23dc01"
                        ReplicatedStorage.Events.Collectibles.Invoke:InvokeServer(LocalPlayer, collectId, "Collect")
                    end)
                    
                    task.wait(0.8)
                    isDowned = char and char:GetAttribute("Downed")
                    
                    if AutoItemEnabled and not isDowned and noItemTimer < 20 then
                        if AfkFarmEnabled and originalPosition then
                            teleportTo(hrp, originalPosition, 0.2)
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

-- Thiết lập ban đầu khi Spawn nhân vật
local function setupCharacter(char)
    char:GetAttributeChangedSignal("Downed"):Connect(function()
        local isDowned = char:GetAttribute("Downed")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        if isDowned then
            AutoItemEnabled = false
            AfkFarmEnabled = false
            if safePlatform then safePlatform:Destroy() end
        else
            task.wait(1)
            if hrp then
                originalPosition = hrp.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
                createSafePlatform(originalPosition)
                hrp.CFrame = CFrame.new(originalPosition)
                
                AfkFarmEnabled = savedAfkState
                AutoItemEnabled = savedCollectState
            end
        end
    end)

    task.spawn(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp and AfkFarmEnabled then
            originalPosition = hrp.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
            createSafePlatform(originalPosition)
            hrp.CFrame = CFrame.new(originalPosition)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

-- Anti-AFK Kick
LocalPlayer.Idled:Connect(function()
    local virtualUser = game:GetService("VirtualUser")
    virtualUser:CaptureController()
    virtualUser:ClickButton2(Vector2.new(0, 0))
end)
