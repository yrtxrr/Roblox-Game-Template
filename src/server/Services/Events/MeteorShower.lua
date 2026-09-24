local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local Event = {}
Event.Name = "Метеоритный дождь"

local function makeMeteor(position)
    local meteor = Instance.new("Part")
    meteor.Name = "Meteor"
    meteor.Shape = Enum.PartType.Ball
    meteor.Size = Vector3.new(5, 5, 5)
    meteor.Material = Enum.Material.Neon
    meteor.Color = Color3.fromRGB(255, 100, 35)
    meteor.CanCollide = true
    meteor.Anchored = false
    meteor.Position = position
    meteor.Parent = workspace

    local fire = Instance.new("Fire")
    fire.Size = 10
    fire.Heat = 8
    fire.Parent = meteor

    local velocity = Instance.new("BodyVelocity")
    velocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    velocity.Velocity = Vector3.new(0, -65, 0)
    velocity.Parent = meteor

    local touched = false
    meteor.Touched:Connect(function(hit)
        if touched then return end
        touched = true

        local model = hit:FindFirstAncestorOfClass("Model")
        local humanoid = model and model:FindFirstChildOfClass("Humanoid")
        if humanoid and Players:GetPlayerFromCharacter(model) then
            humanoid:TakeDamage(45)
        end

        local explosion = Instance.new("Explosion")
        explosion.Position = meteor.Position
        explosion.BlastRadius = 8
        explosion.BlastPressure = 0
        explosion.DestroyJointRadiusPercent = 0
        explosion.Parent = workspace

        meteor:Destroy()
    end)

    Debris:AddItem(meteor, 5)
end

function Event.Run(arena, duration, rng)
    local stopAt = os.clock() + duration
    local bounds = 50

    while os.clock() < stopAt do
        local x = rng:NextNumber(-bounds, bounds)
        local z = rng:NextNumber(-bounds, bounds)
        makeMeteor(Vector3.new(x, 65, z))
        task.wait(0.45)
    end
end

return Event
