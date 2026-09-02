-- main.lua
-- MM2 PvP - Player Position Marker
-- Dùng trong Roblox Studio của game bạn

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Markers = {}

local COLORS = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(70, 170, 255),
    Color3.fromRGB(255, 220, 70),
    Color3.fromRGB(180, 80, 255),
    Color3.fromRGB(70, 255, 150),
}

local function createMarker(player)
    if player == LocalPlayer or Markers[player] then
        return
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "EnemyMarker"
    gui.Size = UDim2.fromOffset(110, 45)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 1000
    gui.Parent = workspace

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Text = player.DisplayName
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.2
    label.TextColor3 = COLORS[(player.UserId % #COLORS) + 1]
    label.Parent = gui

    Markers[player] = gui
end

local function removeMarker(player)
    if Markers[player] then
        Markers[player]:Destroy()
        Markers[player] = nil
    end
end

local function updateMarker(player)
    local marker = Markers[player]
    if not marker then return end

    local character = player.Character
    if not character then
        marker.Adornee = nil
        return
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        marker.Adornee = root
    else
        marker.Adornee = nil
    end
end

-- Người chơi đang có trong server
for _, player in ipairs(Players:GetPlayers()) do
    createMarker(player)
end

-- Người chơi mới vào
Players.PlayerAdded:Connect(function(player)
    createMarker(player)
end)

-- Người chơi rời server
Players.PlayerRemoving:Connect(function(player)
    removeMarker(player)
end)

-- Cập nhật vị trí realtime
RunService.RenderStepped:Connect(function()
    for player in pairs(Markers) do
        updateMarker(player)
    end
end)
