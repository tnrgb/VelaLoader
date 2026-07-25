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

-- Text intro
local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(0, 500, 0, 70)
IntroText.Position = UDim2.new(0.5, -250, 0.5, -35)
IntroText.BackgroundTransparency = 1
IntroText.Text = "@ZERO058 YEU EM VAI LOOL"
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.TextTransparency = 1
IntroText.Font = Enum.Font.FredokaOne
IntroText.TextSize = 30
IntroText.TextScaled = false
IntroText.ZIndex = 2
IntroText.Parent = ScreenGui
-- Banner cố định (đen mờ + viền trắng mờ)
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
Line2.Text = "KAE---------------VADE"
Line2.TextColor3 = Color3.fromRGB(255, 255, 255)
Line2.TextTransparency = 1
Line2.Font = Enum.Font.SourceSansBold
Line2.TextSize = 25
Line2.Parent = Banner

local Line3 = Instance.new("TextLabel")
Line3.Size = UDim2.new(1, -20, 0, 20)
Line3.Position = UDim2.new(0, 10, 0, 56)
Line3.BackgroundTransparency = 1
Line3.Text = "AU-------------------TO"
Line3.TextColor3 = Color3.fromRGB(255, 255, 255)
Line3.TextTransparency = 1
Line3.Font = Enum.Font.SourceSansBold
Line3.TextSize = 20
Line3.Parent = Banner

-- Chuỗi animation
task.spawn(function()
    -- 1) Nền dim + Text: mờ -> rõ
    TweenService:Create(DimBackground, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()
    local textFadeIn = TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 0})
    textFadeIn:Play()
    textFadeIn.Completed:Wait()

    -- 2) Đổi màu chữ lặp lại trong lúc giữ intro (chỉ áp dụng cho IntroText)
    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 215, 0),   -- vàng gold
        Color3.fromRGB(0, 220, 255),   -- xanh cyan
        Color3.fromRGB(255, 100, 200), -- hồng
    }
    for _, color in ipairs(colors) do
        TweenService:Create(IntroText, TweenInfo.new(0.5), {TextColor3 = color}):Play()
        task.wait(0.5)
    end

    -- 3) Nền dim + Text: rõ -> mờ (biến mất)
    TweenService:Create(DimBackground, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
    local textFadeOut = TweenService:Create(IntroText, TweenInfo.new(1), {TextTransparency = 1})
    textFadeOut:Play()
    textFadeOut.Completed:Wait()
    IntroText:Destroy()
    DimBackground:Destroy()

    -- 4) Banner hiện ra
    TweenService:Create(Banner, TweenInfo.new(0.6), {BackgroundTransparency = 0.35}):Play()
    TweenService:Create(BannerStroke, TweenInfo.new(0.6), {Transparency = 0.2}):Play()
    task.wait(0.6)

    -- 5) Chữ hiện lần lượt
    TweenService:Create(Line1, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    task.wait(0.15)
    TweenService:Create(Line2, TweenInfo.new(0.4), {TextTransparency = 0.25}):Play()
    task.wait(0.15)
    TweenService:Create(Line3, TweenInfo.new(0.4), {TextTransparency = 0.25}):Play()
end)
