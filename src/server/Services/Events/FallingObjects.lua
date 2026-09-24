local Debris = game:GetService("Debris")

local Event = {}
Event.Name = "Падающие контейнеры"

function Event.Run(arena, duration, rng)
    local stopAt = os.clock() + duration

    while os.clock() < stopAt do
        local object = Instance.new("Part")
        object.Name = "FallingContainer"
        object.Size = Vector3.new(rng:NextNumber(3, 7), rng:NextNumber(3, 7), rng:NextNumber(3, 7))
        object.Material = Enum.Material.Metal
        object.Color = Color3.fromRGB(100, 105, 115)
        object.Anchored = false
        object.Position = Vector3.new(
            rng:NextNumber(-50, 50),
            55,
            rng:NextNumber(-50, 50)
        )
        object.Parent = workspace

        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        velocity.Velocity = Vector3.new(0, -30, 0)
        velocity.Parent = object

        Debris:AddItem(object, 7)
        task.wait(0.6)
    end
end

return Event
