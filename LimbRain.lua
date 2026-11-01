local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== 参数 =====
local RADIUS = 150
local MAX_PER_TICK = 40
local TICK_INTERVAL = 0.3
local TARGET_RANGE = 500

-- ===== ScreenGui =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemRainUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled = true
screenGui.Parent = playerGui

-- ===== 主开关按钮 =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ItemRainToggle"
toggleBtn.Size = UDim2.fromOffset(84, 84)
toggleBtn.Position = UDim2.new(1, -102, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
toggleBtn.BackgroundTransparency = 0.25
toggleBtn.Text = "贴人雨\nOFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 10
toggleBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.new(1, 1, 1)
btnStroke.Thickness = 1
btnStroke.Transparency = 0.5
btnStroke.Parent = toggleBtn

-- ===== 玩家列表按钮 =====
local listToggleBtn = Instance.new("TextButton")
listToggleBtn.Name = "PlayerListToggle"
listToggleBtn.Size = UDim2.fromOffset(84, 84)
listToggleBtn.Position = UDim2.new(1, -102, 0, 194)
listToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
listToggleBtn.BackgroundTransparency = 0.25
listToggleBtn.Text = "玩家\n列表"
listToggleBtn.TextColor3 = Color3.new(1, 1, 1)
listToggleBtn.TextScaled = true
listToggleBtn.Font = Enum.Font.GothamBold
listToggleBtn.BorderSizePixel = 0
listToggleBtn.ZIndex = 10
listToggleBtn.Parent = screenGui

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(1, 0)
listCorner.Parent = listToggleBtn

local listStroke = Instance.new("UIStroke")
listStroke.Color = Color3.new(1, 1, 1)
listStroke.Thickness = 1
listStroke.Transparency = 0.5
listStroke.Parent = listToggleBtn

-- ===== 玩家列表面板 =====
local playerPanel = Instance.new("Frame")
playerPanel.Name = "PlayerPanel"
playerPanel.Size = UDim2.fromOffset(280, 380)
playerPanel.Position = UDim2.new(0.5, -140, 0.5, -190)
playerPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerPanel.BackgroundTransparency = 0.15
playerPanel.BorderSizePixel = 0
playerPanel.Visible = false
playerPanel.ZIndex = 20
playerPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = playerPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.new(1, 1, 1)
panelStroke.Thickness = 1
panelStroke.Transparency = 0.5
panelStroke.Parent = playerPanel

-- 标题栏（拖动把手）
local panelHeader = Instance.new("Frame")
panelHeader.Size = UDim2.new(1, 0, 0, 44)
panelHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panelHeader.BackgroundTransparency = 0.2
panelHeader.BorderSizePixel = 0
panelHeader.ZIndex = 21
panelHeader.Parent = playerPanel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = panelHeader

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, -80, 1, 0)
headerLabel.Position = UDim2.new(0, 12, 0, 0)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "选择目标玩家"
headerLabel.TextColor3 = Color3.new(1, 1, 1)
headerLabel.TextScaled = true
headerLabel.Font = Enum.Font.GothamBold
headerLabel.TextXAlignment = Enum.TextXAlignment.Left
headerLabel.ZIndex = 22
headerLabel.Parent = panelHeader

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(32, 32)
closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 22
closeBtn.Parent = panelHeader

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- ===== 工具栏：全选 / 清空 =====
local toolbar = Instance.new("Frame")
toolbar.Size = UDim2.new(1, -20, 0, 32)
toolbar.Position = UDim2.new(0, 10, 0, 50)
toolbar.BackgroundTransparency = 1
toolbar.ZIndex = 21
toolbar.Parent = playerPanel

local toolbarLayout = Instance.new("UIListLayout")
toolbarLayout.FillDirection = Enum.FillDirection.Horizontal
toolbarLayout.Padding = UDim.new(0, 8)
toolbarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
toolbarLayout.Parent = toolbar

local function makeToolbarBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(120, 32)
    b.BackgroundColor3 = color
    b.BackgroundTransparency = 0.15
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.ZIndex = 22
    b.Parent = toolbar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    local s = Instance.new("UIStroke")
    s.Color = Color3.new(1, 1, 1)
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = b
    return b
end

local selectAllBtn = makeToolbarBtn("全选", Color3.fromRGB(30, 80, 30))
local clearBtn = makeToolbarBtn("清空", Color3.fromRGB(80, 40, 30))

-- ===== 滚动列表 =====
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -96)
scroll.Position = UDim2.new(0, 10, 0, 88)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ZIndex = 21
scroll.Parent = playerPanel

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- ===== 状态 =====
local active = false
local selectedPlayers = {}   -- [player] = true，支持多选

-- ===== 主开关视觉 =====
local function updateButton()
    toggleBtn.Text = active and "贴人雨\nON" or "贴人雨\nOFF"
    toggleBtn.BackgroundColor3 = active
        and Color3.fromRGB(30, 80, 30)
        or Color3.fromRGB(80, 30, 30)
end
updateButton()

-- ===== 选中计数 =====
local function selectedCount()
    local n = 0
    for p in pairs(selectedPlayers) do
        if p.Parent then n = n + 1 end
    end
    return n
end

-- ===== 玩家列表条目 =====
local function createPlayerEntry(p)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 56)
    btn.BackgroundColor3 = selectedPlayers[p]
        and Color3.fromRGB(0, 130, 80)
        or Color3.fromRGB(55, 55, 55)
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 21
    btn.Parent = scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -16, 0, 30)
    nameLabel.Position = UDim2.new(0, 8, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = p.DisplayName
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.ZIndex = 22
    nameLabel.Parent = btn

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, -16, 0, 20)
    userLabel.Position = UDim2.new(0, 8, 0, 32)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. p.Name
    userLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.TextScaled = true
    userLabel.Font = Enum.Font.Gotham
    userLabel.ZIndex = 22
    userLabel.Parent = btn

    btn.Activated:Connect(function()
        if selectedPlayers[p] then
            selectedPlayers[p] = nil
        else
            selectedPlayers[p] = true
        end
        refreshPlayerList()
    end)
end

function refreshPlayerList()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            count = count + 1
            createPlayerEntry(p)
        end
    end

    if count == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, -12, 0, 50)
        empty.BackgroundTransparency = 1
        empty.Text = "暂无其他玩家"
        empty.TextColor3 = Color3.fromRGB(150, 150, 150)
        empty.TextScaled = true
        empty.Font = Enum.Font.Gotham
        empty.ZIndex = 21
        empty.Parent = scroll
    end

    local n = selectedCount()
    if n > 0 then
        headerLabel.Text = "已选 " .. n .. " 个目标"
    else
        headerLabel.Text = "选择目标玩家（随机）"
    end
end

-- ===== 全选 / 清空 =====
selectAllBtn.Activated:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            selectedPlayers[p] = true
        end
    end
    refreshPlayerList()
end)

clearBtn.Activated:Connect(function()
    selectedPlayers = {}
    refreshPlayerList()
end)

-- ===== 玩家事件 =====
Players.PlayerAdded:Connect(function()
    task.wait(0.2)
    refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(p)
    selectedPlayers[p] = nil
    refreshPlayerList()
end)

refreshPlayerList()

-- ===== 工具函数 =====
local function getMyRoot()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- 没选中时随机挑附近玩家（不回退自己）
local function getRandomTarget()
    local myRoot = getMyRoot()
    if not myRoot then return nil end
    local candidates = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local c = p.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                local d = (root.Position - myRoot.Position).Magnitude
                if d <= TARGET_RANGE then
                    table.insert(candidates, p)
                end
            end
        end
    end
    if #candidates > 0 then
        return candidates[math.random(1, #candidates)]
    end
    return nil
end

local function collectLimbParts(character)
    local limbs = {}
    if not character then return limbs end
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("BasePart") then
            table.insert(limbs, d)
        end
    end
    return limbs
end

-- 把附近物件平均分配给多个目标
local function distributeParts(targets)
    if #targets == 0 then return end
    local myRoot = getMyRoot()
    if not myRoot then return end

    -- 收集一次物件，排除自己和所有目标的角色
    local filter = {player.Character}
    local limbCache = {}
    for _, t in ipairs(targets) do
        local c = t.Character
        if c then
            table.insert(filter, c)
            limbCache[t] = collectLimbParts(c)
        end
    end

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = filter
    local near = workspace:GetPartBoundsInRadius(myRoot.Position, RADIUS, params)

    local parts = {}
    for _, p in ipairs(near) do
        if p:IsA("BasePart") and not p.Anchored then
            local model = p:FindFirstAncestorOfClass("Model")
            local isChar = model and model:FindFirstChildOfClass("Humanoid")
            if not isChar then
                table.insert(parts, p)
            end
        end
    end

    if #parts == 0 then return end
    table.sort(parts, function(a, b)
        return (a.Position - myRoot.Position).Magnitude < (b.Position - myRoot.Position).Magnitude
    end)
    if #parts > MAX_PER_TICK then
        for i = #parts, MAX_PER_TICK + 1, -1 do
            parts[i] = nil
        end
    end

    -- 轮流分给每个目标，保证公平
    local n = #targets
    for i, part in ipairs(parts) do
        local target = targets[(i - 1) % n + 1]
        local limbs = limbCache[target]
        if limbs and #limbs > 0 then
            local limb = limbs[math.random(1, #limbs)]
            local tinyOffset = Vector3.new(
                math.random(-2, 2),
                math.random(-2, 2),
                math.random(-2, 2)
            )
            local targetPos = limb.Position + tinyOffset
            local rot = CFrame.Angles(
                math.random() * math.pi * 2,
                math.random() * math.pi * 2,
                math.random() * math.pi * 2
            )
            pcall(function()
                part.CFrame = CFrame.new(targetPos) * rot
                part.AssemblyLinearVelocity = Vector3.new(
                    math.random(-5, 5),
                    math.random(-3, 3),
                    math.random(-5, 5)
                )
            end)
        end
    end
end

-- ===== 主循环 =====
task.spawn(function()
    while true do
        task.wait(TICK_INTERVAL)
        if active then
            local targets = {}
            for p in pairs(selectedPlayers) do
                if p.Parent and p.Character then
                    table.insert(targets, p)
                end
            end
            if #targets == 0 then
                local t = getRandomTarget()
                if t then table.insert(targets, t) end
            end
            if #targets > 0 then
                distributeParts(targets)
            end
        end
    end
end)

-- ===== UI 命中 =====
local function pointInGui(pos, gui, pad)
    pad = pad or 0
    local ap = gui.AbsolutePosition
    local as = gui.AbsoluteSize
    return pos.X >= ap.X - pad and pos.X <= ap.X + as.X + pad
       and pos.Y >= ap.Y - pad and pos.Y <= ap.Y + as.Y + pad
end

local function toggle()
    active = not active
    updateButton()
end

local function togglePanel()
    playerPanel.Visible = not playerPanel.Visible
    if playerPanel.Visible then
        refreshPlayerList()
    end
end

closeBtn.Activated:Connect(function()
    playerPanel.Visible = false
end)

-- ===== 拖动状态 =====
local draggingBtn = nil
local dragMoved = false
local dragStart, dragStartPos

local draggingPanel = false
local panelDragStart, panelStartPos

UserInputService.InputBegan:Connect(function(input, processed)
    if input.UserInputType ~= Enum.UserInputType.Touch
       and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    if pointInGui(input.Position, toggleBtn, 6) then
        draggingBtn = toggleBtn
        dragMoved = false
        dragStart = input.Position
        dragStartPos = toggleBtn.Position
        return
    end
    if pointInGui(input.Position, listToggleBtn, 6) then
        draggingBtn = listToggleBtn
        dragMoved = false
        dragStart = input.Position
        dragStartPos = listToggleBtn.Position
        return
    end

    -- 面板标题栏拖动（排除关闭按钮/全选/清空）
    if playerPanel.Visible
       and pointInGui(input.Position, panelHeader)
       and not pointInGui(input.Position, closeBtn, 2)
       and not pointInGui(input.Position, selectAllBtn, 2)
       and not pointInGui(input.Position, clearBtn, 2) then
        draggingPanel = true
        panelDragStart = input.Position
        panelStartPos = playerPanel.Position
        return
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch
       and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

    if draggingBtn then
        local delta = input.Position - dragStart
        if delta.Magnitude > 10 then dragMoved = true end
        draggingBtn.Position = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
        return
    end

    if draggingPanel then
        local delta = input.Position - panelDragStart
        playerPanel.Position = UDim2.new(
            panelStartPos.X.Scale, panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale, panelStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.Touch
       and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

    if draggingBtn then
        local btn = draggingBtn
        draggingBtn = nil
        if not dragMoved then
            if btn == toggleBtn then
                toggle()
            elseif btn == listToggleBtn then
                togglePanel()
            end
        end
        return
    end

    if draggingPanel then
        draggingPanel = false
    end
end)

-- ===== PC 端 F 键 =====
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggle()
    end
end)
