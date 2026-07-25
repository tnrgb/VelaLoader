local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixedBanner"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Nền tối mờ phía sau intro (dim toàn màn hình)
local DimBackground = Instance.new("Frame")
DimBackground.Size = UDim2.new(1, 0, 1, 0)
DimBackground.Position = UDim2.new(0, 0, 0, 0)
DimBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DimBackground.BackgroundTransparency = 1 -- ẩn ban đầu, tween xuống mờ
DimBackground.BorderSizePixel = 0
DimBackground.Active = false
DimBackground.ZIndex = 1
DimBackground.Parent = ScreenGui

--------------------------------------------------------------------------------
-- TEXT INTRO NEON (Chữ đen + Ánh sáng Neon)
--------------------------------------------------------------------------------
local NEON_COLOR = Color3.fromRGB(0, 255, 240) -- Màu Neon (Xanh Cyan)

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0, 500, 0, 70)
IntroText.Position = UDim2.new(0.5, -250, 0.5, -35)
IntroText.BackgroundTransparency = 1
IntroText.Text = "ZERO YEU EM VAI LOOL"
IntroText.TextColor3 = Color3.fromRGB(0, 0, 0) -- Chữ chính màu đen
IntroText.TextTransparency = 1
IntroText.Font = Enum.Font.FredokaOne
IntroText.TextSize = 30
IntroText.TextScaled = false
IntroText.ZIndex = 3
IntroText.Parent = ScreenGui

-- Viền Neon phát sáng
local NeonStroke = Instance.new("UIStroke")
NeonStroke.Thickness = 3
NeonStroke.Color = NEON_COLOR
NeonStroke.Transparency = 1
NeonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
NeonStroke.Parent = IntroText

-- Bóng Neon tỏa sáng phía sau
local NeonGlow = Instance.new("TextLabel")
NeonGlow.Size = UDim2.new(1, 0, 1, 0)
NeonGlow.Position = UDim2.new(0, 0, 0, 0)
NeonGlow.BackgroundTransparency = 1
NeonGlow.Text = IntroText.Text
NeonGlow.TextColor3 = NEON_COLOR
NeonGlow.TextTransparency = 1
NeonGlow.Font = IntroText.Font
NeonGlow.TextSize = IntroText.TextSize
NeonGlow.ZIndex = 2
NeonGlow.Parent = IntroText

--------------------------------------------------------------------------------
-- BANNER CỐ ĐỊNH
--------------------------------------------------------------------------------
local Banner = Instance.new("Frame")
Banner.Size = UDim2.new(0, 420, 0, 85)
Banner.Position = UDim2.new(0.5, -210, 0, 20)
Banner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Banner.BackgroundTransparency = 1
Banner.Active = false
Banner.Parent = ScreenGui

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 14)
BannerCorner.Parent = Banner

local BannerStroke = Instance.new("UIStroke")
BannerStroke.Color = Color3.fromRGB(255, 255, 255)
BannerStroke.Thickness = 2
BannerStroke.Transparency = 1
BannerStroke.Parent = Banner

local Line1 = Instance.new("TextLabel")
Line1.Size = UDim2.new(1, -20, 0, 22)
Line1.Position = UDim2.new(0, 10, 0, 6)
Line1.BackgroundTransparency = 1
Line1.Text = "https://zeroyeuem"
Line1.TextColor3 = Color3.fromRGB(255, 255, 255)
Line1.TextTransparency = 1
Line1.Font = Enum.Font.SourceSansBold
Line1.TextSize = 16
Line1.Parent = Banner

local Line2 = Instance.new("TextLabel")
Line2.Size = UDim2.new(1, -20, 0, 20)
Line2.Position = UDim2.new(0, 10, 0, 32)
Line2.BackgroundTransparency = 1
Line2.Text = "KAITUN EVADE SUMMER EVENT"
Line2.TextColor3 = Color3.fromRGB(255, 255, 255)
Line2.TextTransparency = 1
Line2.Font = Enum.Font.SourceSansBold
Line2.TextSize = 25
Line2.Parent = Banner

local Line3 = Instance.new("TextLabel")
Line3.Size = UDim2.new(1, -20, 0, 20)
Line3.Position = UDim2.new(0, 10, 0, 56)
Line3.BackgroundTransparency = 1
Line3.Text = "AUTO FARM TOKEN"
Line3.TextColor3 = Color3.fromRGB(255, 255, 255)
Line3.TextTransparency = 1
Line3.Font = Enum.Font.SourceSansBold
Line3.TextSize = 20
Line3.Parent = Banner

--------------------------------------------------------------------------------
-- CHUỖI ANIMATION
--------------------------------------------------------------------------------
task.spawn(function()
    -- 1) Text Neon: Mờ -> Hiện rõ toàn bộ hiệu ứng
    TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(NeonStroke, TweenInfo.new(1), {Transparency = 0}):Play()
    local textFadeIn = TweenService:Create(NeonGlow, TweenInfo.new(1), {TextTransparency = 0.3})
    textFadeIn:Play()
    textFadeIn.Completed:Wait()

    task.wait(0.5) -- Giữ chữ hiển thị

    -- 2) Text Neon: Rõ -> Mờ hẳn (biến mất)
    TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    TweenService:Create(NeonStroke, TweenInfo.new(1), {Transparency = 1}):Play()
    local textFadeOut = TweenService:Create(NeonGlow, TweenInfo.new(1), {TextTransparency = 1})
    textFadeOut:Play()
    textFadeOut.Completed:Wait()
    
    IntroText:Destroy() -- Xóa gọn UI Intro sau khi ẩn xong

    -- 3) Banner hiện ra
    TweenService:Create(Banner, TweenInfo.new(0.6), {BackgroundTransparency = 0.35}):Play()
    TweenService:Create(BannerStroke, TweenInfo.new(0.6), {Transparency = 0.2}):Play()
    task.wait(0.4)

    -- 4) Các dòng chữ trong Banner hiện lần lượt
    TweenService:Create(Line1, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    task.wait(0.10)
    TweenService:Create(Line2, TweenInfo.new(0.4), {TextTransparency = 0.25}):Play()
    task.wait(0.10)
    TweenService:Create(Line3, TweenInfo.new(0.4), {TextTransparency = 0.25}):Play()
end)
