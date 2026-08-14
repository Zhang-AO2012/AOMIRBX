local WindUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
))()

local MarketplaceService = game:GetService("MarketplaceService")
local function getPlaceName()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    return (ok and info and info.Name) or game.Name
end
local placeName = getPlaceName()

-- ===== HSV → RGB 工具函数（用于彩虹色循环）=====
local function hsvToRgb(h, s, v)
    local r, g, b
    local i = math.floor(h / 60) % 6
    local f = (h / 60) - math.floor(h / 60)
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    else
        r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

local function makeRainbowColorSequence(timeOffset, saturation, value, count)
    saturation = saturation or 1
    value = value or 1
    count = count or 6
    local speed = 60
    local hueOffset = (tick() * speed + (timeOffset or 0)) % 360
    local keypoints = {}
    for i = 0, count - 1 do
        local hue = (hueOffset + (i / count) * 360) % 360
        local c = hsvToRgb(hue, saturation, value)
        local t = i / (count - 1)
        keypoints[i + 1] = ColorSequenceKeypoint.new(t, c)
    end
    return ColorSequence.new(keypoints)
end

local function makeRainbowColor(timeOffset, saturation, value)
    saturation = saturation or 1
    value = value or 1
    local speed = 60
    local hue = (tick() * speed + (timeOffset or 0)) % 360
    return hsvToRgb(hue, saturation, value)
end

function gradient3(text, color1, color2, color3)
    local result = ""
    local chars = {}
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    local length = #chars
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r, g, b
        if t < 0.5 then
            local s = t * 2
            r = color1.R + (color2.R - color1.R) * s
            g = color1.G + (color2.G - color1.G) * s
            b = color1.B + (color2.B - color1.B) * s
        else
            local s = (t - 0.5) * 2
            r = color2.R + (color3.R - color2.R) * s
            g = color2.G + (color3.G - color2.G) * s
            b = color2.B + (color3.B - color2.B) * s
        end
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>',
            math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), chars[i])
    end
    return result
end

local titleColor1 = hsvToRgb(0, 1, 1)
local titleColor2 = hsvToRgb(120, 1, 1)
local titleColor3 = hsvToRgb(240, 1, 1)

local Window = WindUI:CreateWindow({
    Title = gradient3("奥脚本", titleColor1, titleColor2, titleColor3),
    Author = gradient3("奥", titleColor3, titleColor1, titleColor2),
    Icon = "",
    IconThemed = false,
    Folder = "AoScript",
    Size = UDim2.fromOffset(580, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 160,
    HideSearchBar = false,
    ScrollBarEnabled = true,
})

Window:Tag({
    Title = placeName,
    Radius = 5,
    Color = makeRainbowColor(0),
})

Window:EditOpenButton({
    Title = "奥脚本",
    Icon = "",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 2,
    Color = makeRainbowColorSequence(0, 1, 1, 6),
    Glow = true,
    GlowColor = makeRainbowColor(180),
    GlowTransparency = 0.35,
    Draggable = true,
})

task.spawn(function()
    repeat task.wait() until Window.OpenButtonMain and Window.OpenButtonMain.Button
    local btn = Window.OpenButtonMain.Button
    local textLabel = btn:FindFirstChildWhichIsA("TextLabel")
    if textLabel then
        textLabel.TextColor3 = makeRainbowColor(0)
        textLabel.TextStrokeTransparency = 0.7
        textLabel.TextStrokeColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- ===== 彩虹边框系统 =====
local borderEnabled = true
local function ensureBlurElement()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then return end
    local blur = mainFrame:FindFirstChild("Blur")
    if not blur then
        blur = Instance.new("ImageLabel")
        blur.Name = "Blur"
        blur.Size = UDim2.new(1, 0, 1, 0)
        blur.BackgroundTransparency = 1
        blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        blur.ImageTransparency = 0.15
        blur.ZIndex = 0
        blur.Parent = mainFrame
    end
    return blur
end

local function applyRainbowBorderColor(c, transparency)
    transparency = transparency or 0.15
    local f = c.UIElements and c.UIElements.Main or c.Frame or c.Gui or c
    if not f then return false end
    local g = f:FindFirstChild("Blur", true)
    if g and g:IsA("ImageLabel") then
        g.ImageColor3 = makeRainbowColor(0)
        g.ImageTransparency = transparency
        local existingGrad = g:FindFirstChild("XIONBorderGrad")
        if not existingGrad then
            existingGrad = Instance.new("UIGradient")
            existingGrad.Name = "XIONBorderGrad"
            existingGrad.Color = makeRainbowColorSequence(0, 1, 1, 6)
            existingGrad.Rotation = 0
            existingGrad.Parent = g
        else
            existingGrad.Color = makeRainbowColorSequence(0, 1, 1, 6)
            existingGrad.Rotation = 0
        end
        return true
    end
    local h = f:FindFirstChild("Shadow", true)
    if h and h:IsA("ImageLabel") then
        h.ImageColor3 = makeRainbowColor(180)
        h.ImageTransparency = transparency
        local existingGrad = h:FindFirstChild("XIONBorderGrad")
        if not existingGrad then
            existingGrad = Instance.new("UIGradient")
            existingGrad.Name = "XIONBorderGrad"
            existingGrad.Color = makeRainbowColorSequence(180, 1, 0.8, 6)
            existingGrad.Rotation = 0
            existingGrad.Parent = h
        else
            existingGrad.Color = makeRainbowColorSequence(180, 1, 0.8, 6)
            existingGrad.Rotation = 0
        end
        return true
    end
    return false
end

local borderConnection = nil
local function startBorderAnimation()
    if borderConnection then
        borderConnection:Disconnect()
        borderConnection = nil
    end
    if not borderEnabled then return end
    ensureBlurElement()
    borderConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame or not mainFrame.Visible then return end
        applyRainbowBorderColor(Window, 0.15)
    end)
end

local function stopBorderAnimation()
    if borderConnection then
        borderConnection:Disconnect()
        borderConnection = nil
    end
end

local function setupVisibilityListener()
    local mainFrame = Window.UIElements and Window.UIElements.Main
    if not mainFrame then
        task.spawn(function()
            repeat task.wait() until Window.UIElements and Window.UIElements.Main
            setupVisibilityListener()
        end)
        return
    end
    if mainFrame.Visible and borderEnabled then
        startBorderAnimation()
    elseif not mainFrame.Visible then
        stopBorderAnimation()
    end
    mainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if mainFrame.Visible and borderEnabled then
            startBorderAnimation()
        else
            stopBorderAnimation()
        end
    end)
end
setupVisibilityListener()

Window:OnClose(function()
    stopBorderAnimation()
end)

task.spawn(function()
    repeat task.wait() until Window.UIElements and Window.UIElements.Main
    local mainContainer = Window.UIElements.Main
    if mainContainer then
        local stroke = Instance.new("UIStroke")
        stroke.Name = "XIONStroke"
        stroke.Thickness = 2
        stroke.Color = makeRainbowColor(0)
        stroke.Transparency = 0.3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = mainContainer
        local gradientElement = Instance.new("UIGradient")
        gradientElement.Name = "XIONGradient"
        gradientElement.Color = makeRainbowColorSequence(0, 1, 1, 7)
        gradientElement.Rotation = 0
        gradientElement.Parent = stroke
        task.spawn(function()
            while mainContainer and mainContainer.Parent do
                task.wait(0.05)
                gradientElement.Color = makeRainbowColorSequence(0, 1, 1, 7)
                gradientElement.Rotation = 0
                stroke.Color = makeRainbowColor(0)
            end
        end)
    end
end)

task.spawn(function()
    repeat task.wait() until Window.OpenButtonMain and Window.OpenButtonMain.Button
    local button = Window.OpenButtonMain.Button
    local stroke = button:FindFirstChildWhichIsA("UIStroke")
    if not stroke then return end
    local grad = stroke:FindFirstChildWhichIsA("UIGradient")
    if not grad then return end
    grad.Color = makeRainbowColorSequence(0, 1, 1, 6)
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            task.wait(0.05)
            grad.Color = makeRainbowColorSequence(tick() * 30, 1, 1, 6)
            grad.Rotation = 0
        end
    end)
end)

task.spawn(function()
    repeat task.wait() until Window.UIElements and Window.UIElements.Main
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end
    local topGlow = Instance.new("Frame")
    topGlow.Name = "TopGlow"
    topGlow.Size = UDim2.new(1, 0, 0.3, 0)
    topGlow.BackgroundTransparency = 1
    topGlow.ZIndex = 0
    topGlow.Parent = mainFrame
    local topGrad = Instance.new("UIGradient")
    topGrad.Color = ColorSequence.new(makeRainbowColor(0), makeRainbowColor(180))
    topGrad.Transparency = NumberSequence.new(0.75, 1)
    topGrad.Rotation = 90
    topGrad.Parent = topGlow
    local bottomGlow = Instance.new("Frame")
    bottomGlow.Name = "BottomGlow"
    bottomGlow.Size = UDim2.new(1, 0, 0.25, 0)
    bottomGlow.Position = UDim2.new(0, 0, 0.75, 0)
    bottomGlow.BackgroundTransparency = 1
    bottomGlow.ZIndex = 0
    bottomGlow.Parent = mainFrame
    local bottomGrad = Instance.new("UIGradient")
    bottomGrad.Color = ColorSequence.new(makeRainbowColor(180), makeRainbowColor(0))
    bottomGrad.Transparency = NumberSequence.new(1, 0.92)
    bottomGrad.Rotation = 90
    bottomGrad.Parent = bottomGlow
    task.spawn(function()
        while topGlow and topGlow.Parent do
            task.wait(0.1)
            local c1 = makeRainbowColor(0)
            local c2 = makeRainbowColor(180)
            topGrad.Color = ColorSequence.new(c1, c2)
            bottomGrad.Color = ColorSequence.new(c2, c1)
        end
    end)
end)

-- ======================基础功能标签页======================
local MainTab = Window:Tab({Title = "基础功能"})

-- 无限跳跃开关
local InfiniteJumpEnabled = false
local JumpBindConnection = nil
MainTab:Toggle({
    Name = "无限跳跃",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        if InfiniteJumpEnabled then
            if not JumpBindConnection then
                JumpBindConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                    local lp = game.Players.LocalPlayer
                    local c = lp.Character
                    if not c then return end
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.JumpPower = 70
            end
            WindUI:Notify({Title = "功能", Content = "无限跳跃已开启", Duration = 2})
        else
            if JumpBindConnection then
                JumpBindConnection:Disconnect()
                JumpBindConnection = nil
            end
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.JumpPower = 50
            end
            WindUI:Notify({Title = "功能", Content = "无限跳跃已关闭", Duration = 2})
        end
    end
})

-- 移速输入框（10‑500）
MainTab:Input({
    Name = "移速（10‑500）",
    PlaceholderText = "输入数字设置移速",
    Callback = function(inputText)
        local num = tonumber(inputText)
        if not num then
            WindUI:Notify({Title = "错误", Content = "请输入有效数字！", Duration = 2})
            return
        end
        num = math.clamp(num, 10, 500)
        local plr = game.Players.LocalPlayer
        local char = plr.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = num
                WindUI:Notify({Title = "移速设置", Content = "当前移速："..num, Duration = 1.5})
            end
        end
    end
})

-- ======================【新标签：自瞄】======================
local AimbotTab = Window:Tab({Title = "自瞄"})

AimbotTab:Button({
    Name = "加载ESP‑Antibot V3",
    Callback = function()
        WindUI:Notify({Title = "提示", Content = "正在尝试加载V3脚本，网络差会超时失败", Duration = 3})
        -- 原github加载代码
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1215203698741/Roblox-ESP-Antibot-V3/refs/heads/main/V3.0phone.lua"))()
    end
})

WindUI:Notify({
    Title = "奥脚本",
    Content = "脚本加载完成",
    Duration = 3
})