--// ZIN PVP
--// Enemy Tracker - Roblox Studio
--// LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local enabled = false
local markers = {}

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ZIN PVP"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Nút nhỏ
local button = Instance.new("TextButton")
button.Name = "TrackerButton"
button.Size = UDim2.new(0, 100, 0, 32)
button.Position = UDim2.new(0, 12, 0.5, -16)
button.Text = "📍 OFF"
button.TextScaled = true
button.BackgroundTransparency = 0.2
button.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 7)
corner.Parent = button

--// Tạo marker
local function createMarker(target)
    if markers[target] then return end

    local character = target.Character
    if not character then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZIN_PVP_Marker"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 70, 70)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Parent = billboard

    markers[target] = {
        gui = billboard,
        label = label
    }
end

--// Xóa marker
local function removeMarker(target)
    if markers[target] then
        markers[target].gui:Destroy()
        markers[target] = nil
    end
end

--// Chỉ lấy người khác team
local function isEnemy(target)
    return target ~= player
        and target.Team ~= player.Team
        and target.Character
        and target.Character:FindFirstChild("Humanoid")
        and target.Character.Humanoid.Health > 0
end

--// Cập nhật
RunService.RenderStepped:Connect(function()
    if not enabled then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if isEnemy(target) then
            createMarker(target)

            local data = markers[target]

            if data and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = player.Character
                    and player.Character:FindFirstChild("HumanoidRootPart")

                if root and myRoot then
                    local distance = math.floor(
                        (root.Position - myRoot.Position).Magnitude
                    )

                    data.label.Text =
                        "⚔ " .. target.Name .. "\n" ..
                        distance .. " studs"
                end
            end
        else
            removeMarker(target)
        end
    end
end)

--// Nút ON/OFF
button.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        button.Text = "📍 ON"
    else
        button.Text = "📍 OFF"

        for target in pairs(markers) do
            removeMarker(target)
        end
    end
end)

Players.PlayerRemoving:Connect(function(target)
    removeMarker(target)
end)
