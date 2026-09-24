local Players = game:GetService("Players")

local Event = {}
Event.Name = "Землетрясение"

function Event.Run(arena, duration, rng)
    local stopAt = os.clock() + duration

    while os.clock() < stopAt do
        for _, player in Players:GetPlayers() do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if humanoid and root and humanoid.Health > 0 then
                local impulse = Vector3.new(
                    rng:NextNumber(-1, 1),
                    rng:NextNumber(0.3, 0.8),
                    rng:NextNumber(-1, 1)
                ).Unit * rng:NextNumber(35, 60)

                root:ApplyImpulse(impulse * root.AssemblyMass)
            end
        end
        task.wait(1.2)
    end
end

return Event
