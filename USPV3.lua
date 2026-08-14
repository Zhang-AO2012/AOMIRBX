Title = "USP V3",
     Author = "奥",
     Size = UDim2.new(0, 520, 0, 340),
     Theme = {
         PrimaryColor = Color3.fromHex("#00D9FF"),
         SecondaryColor = Color3.fromHex("#111111"),
         AccentColor = Color3.fromHex("#00D9FF"),
         TextColor = Color3.fromHex("#FFFFFF"),
         BackgroundColor = Color3.fromHex("#000000"),
         TabColor = Color3.fromHex("#0A0A0A"),
         ToggleColor = Color3.fromHex("#00D9FF")
     }
 })
 -- 创建居中的"奥"文字
 local CenterText = Instance.new("TextLabel")
 CenterText.Parent = Window.Main
 CenterText.BackgroundTransparency = 1
 CenterText.Size = UDim2.new(1,0,1,0)
 CenterText.Position = UDim2.new(0,0,0,0)
 CenterText.Text = "奥"
 CenterText.Font = Enum.Font.GothamBlack
 CenterText.TextSize = 72
 CenterText.TextColor3 = Color3.new(1,1,1)
 CenterText.TextTransparency = 0.25 -- 设置轻微透明，不会挡住按钮
 local MainTab = Window:CreateTab("加载")
 local toggle = MainTab:CreateToggle({
     Name = "启用 USP V3",
     Default = false,
     OnColor = Color3.fromHex("#00D9FF"),
     OffColor = Color3.fromHex("#181818"),
     TextColor = Color3.fromHex("#FFFFFF"),
     Callback = function(state)
         if state then
             loadstring(game:HttpGet("https://raw.githubusercontent.com/1215203698741/Roblox-ESP-Antibot-V3/refs/heads/main/V3.0phone.lua"))()
         else