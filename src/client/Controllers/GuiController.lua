local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = {}

function Shared.OnStart()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local remotes = ReplicatedStorage:WaitForChild("SurvivalRemotes")
    local eventRemote = remotes:WaitForChild("Event")

    local oldGui = playerGui:FindFirstChild("SurvivalUI")
    if oldGui then
        oldGui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SurvivalUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.AnchorPoint = Vector2.new(0.5, 0)
    status.Position = UDim2.fromScale(0.5, 0.035)
    status.Size = UDim2.fromScale(0.55, 0.07)
    status.BackgroundTransparency = 0.2
    status.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    status.TextColor3 = Color3.new(1, 1, 1)
    status.TextScaled = true
    status.Font = Enum.Font.GothamBold
    status.Text = "SURVIVAL ARENA"
    status.Parent = gui

    local eventLabel = Instance.new("TextLabel")
    eventLabel.Name = "Event"
    eventLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    eventLabel.Position = UDim2.fromScale(0.5, 0.18)
    eventLabel.Size = UDim2.fromScale(0.65, 0.09)
    eventLabel.BackgroundTransparency = 1
    eventLabel.TextColor3 = Color3.fromRGB(255, 205, 60)
    eventLabel.TextScaled = true
    eventLabel.Font = Enum.Font.GothamBlack
    eventLabel.Text = ""
    eventLabel.Parent = gui

    local timer = Instance.new("TextLabel")
    timer.Name = "Timer"
    timer.AnchorPoint = Vector2.new(1, 1)
    timer.Position = UDim2.fromScale(0.97, 0.95)
    timer.Size = UDim2.fromScale(0.14, 0.06)
    timer.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    timer.BackgroundTransparency = 0.2
    timer.TextColor3 = Color3.new(1, 1, 1)
    timer.TextScaled = true
    timer.Font = Enum.Font.GothamBold
    timer.Text = ""
    timer.Parent = gui

    eventRemote.OnClientEvent:Connect(function(kind, name, value)
        if kind == "phase" then
            status.Text = tostring(name)
            timer.Text = tostring(value or "")
        elseif kind == "timer" then
            timer.Text = tostring(value)
        elseif kind == "start" then
            local text = "⚠ " .. tostring(name)
            eventLabel.Text = text
            task.delay(2, function()
                if eventLabel.Text == text then
                    eventLabel.Text = ""
                end
            end)
        elseif kind == "end" then
            eventLabel.Text = ""
        elseif kind == "winner" then
            status.Text = tostring(name)
            timer.Text = ""
        end
    end)
end

return Shared
