local Players = game:GetService("Players")

local Event = {}
Event.Name = "Опасная зона"

function Event.Run(arena, duration, rng)
    local center = Vector3.new(rng:NextNumber(-20, 20), 1.2, rng:NextNumber(-20, 20))
    local radius = 18

    local zone = Instance.new("Part")
    zone.Name = "DangerZone"
    zone.Shape = Enum.PartType.Cylinder
    zone.Size = Vector3.new(1, radius * 2, radius * 2)
    zone.CFrame = CFrame.new(center) * CFrame.Angles(0, 0, math.rad(90))
    zone.Anchored = true
    zone.CanCollide = false
    zone.Material = Enum.Material.Neon
    zone.Color = Color3.fromRGB(255, 45, 45)
    zone.Transparency = 0.55
    zone.Parent = arena

    local stopAt = os.clock() + duration
    while os.clock() < stopAt do
        for _, player in Players:GetPlayers() do
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if root and humanoid and humanoid.Health > 0 then
                local flat = Vector3.new(root.Position.X, center.Y, root.Position.Z)
                if (flat - center).Magnitude <= radius then
                    humanoid:TakeDamage(12)
                end
            end
        end
        task.wait(0.5)
    end

    zone:Destroy()
end

return Event
