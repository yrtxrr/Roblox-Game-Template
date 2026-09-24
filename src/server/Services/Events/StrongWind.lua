local Players = game:GetService("Players")

local Event = {}
Event.Name = "Сильный ветер"

function Event.Run(arena, duration, rng)
    local stopAt = os.clock() + duration

    while os.clock() < stopAt do
        for _, player in Players:GetPlayers() do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then
                local direction = Vector3.new(
                    rng:NextNumber(-1, 1),
                    rng:NextNumber(0, 0.25),
                    rng:NextNumber(-1, 1)
                )

                if direction.Magnitude > 0 then
                    root:ApplyImpulse(direction.Unit * rng:NextNumber(45, 75) * root.AssemblyMass)
                end
            end
        end
        task.wait(0.8)
    end
end

return Event
