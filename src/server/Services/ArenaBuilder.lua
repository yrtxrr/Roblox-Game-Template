local Workspace = game:GetService("Workspace")

local ARENA_NAME = "Arena"

local function makePart(parent, name, size, cframe, material, transparency, color, canCollide)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.CFrame = cframe
    part.Anchored = true
    part.CanCollide = canCollide ~= false
    part.CanTouch = true
    part.CanQuery = true
    part.Material = material or Enum.Material.Concrete
    part.Transparency = transparency or 0
    part.Color = color or Color3.fromRGB(90, 90, 90)
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = parent
    return part
end

local function buildArena()
    local oldArena = Workspace:FindFirstChild(ARENA_NAME)
    if oldArena then
        oldArena:Destroy()
    end

    local arena = Instance.new("Folder")
    arena.Name = ARENA_NAME
    arena.Parent = Workspace

    local floor = Instance.new("Model")
    floor.Name = "Floor"
    floor.Parent = arena

    makePart(
        floor,
        "Main",
        Vector3.new(120, 2, 120),
        CFrame.new(0, 0, 0),
        Enum.Material.Concrete,
        0,
        Color3.fromRGB(70, 72, 78)
    )

    local center = Instance.new("Part")
    center.Name = "Center"
    center.Size = Vector3.new(38, 0.25, 38)
    center.CFrame = CFrame.new(0, 1.12, 0)
    center.Anchored = true
    center.CanCollide = false
    center.Material = Enum.Material.Metal
    center.Color = Color3.fromRGB(48, 50, 56)
    center.Parent = floor

    local boundaries = Instance.new("Folder")
    boundaries.Name = "Boundaries"
    boundaries.Parent = arena

    local wallHeight = 14
    local wallThickness = 2
    local halfSize = 61

    makePart(boundaries, "Wall1", Vector3.new(124, wallHeight, wallThickness), CFrame.new(0, wallHeight / 2, -halfSize), Enum.Material.Metal, 0.35, Color3.fromRGB(35, 38, 44))
    makePart(boundaries, "Wall2", Vector3.new(124, wallHeight, wallThickness), CFrame.new(0, wallHeight / 2, halfSize), Enum.Material.Metal, 0.35, Color3.fromRGB(35, 38, 44))
    makePart(boundaries, "Wall3", Vector3.new(wallThickness, wallHeight, 124), CFrame.new(-halfSize, wallHeight / 2, 0), Enum.Material.Metal, 0.35, Color3.fromRGB(35, 38, 44))
    makePart(boundaries, "Wall4", Vector3.new(wallThickness, wallHeight, 124), CFrame.new(halfSize, wallHeight / 2, 0), Enum.Material.Metal, 0.35, Color3.fromRGB(35, 38, 44))

    local spawnFolder = Instance.new("Folder")
    spawnFolder.Name = "SpawnPoints"
    spawnFolder.Parent = arena

    local spawnRadius = 45
    local spawnCount = 8

    for i = 1, spawnCount do
        local angle = math.rad((i - 1) * (360 / spawnCount))
        local position = Vector3.new(
            math.cos(angle) * spawnRadius,
            2,
            math.sin(angle) * spawnRadius
        )

        local spawn = Instance.new("Part")
        spawn.Name = "Spawn" .. i
        spawn.Size = Vector3.new(6, 0.5, 6)
        spawn.CFrame = CFrame.new(position)
        spawn.Anchored = true
        spawn.CanCollide = false
        spawn.CanTouch = false
        spawn.Transparency = 1
        spawn.Parent = spawnFolder
    end

    local obstacles = Instance.new("Folder")
    obstacles.Name = "Obstacles"
    obstacles.Parent = arena

    local obstacleData = {
        {Vector3.new(12, 8, 5), CFrame.new(-25, 5, -18)},
        {Vector3.new(12, 8, 5), CFrame.new(25, 5, 18)},
        {Vector3.new(5, 8, 12), CFrame.new(-18, 5, 25)},
        {Vector3.new(5, 8, 12), CFrame.new(18, 5, -25)},
        {Vector3.new(8, 5, 8), CFrame.new(-30, 3.5, 18)},
        {Vector3.new(8, 5, 8), CFrame.new(30, 3.5, -18)},
    }

    for i, data in ipairs(obstacleData) do
        makePart(
            obstacles,
            "Obstacle" .. i,
            data[1],
            data[2],
            Enum.Material.Metal,
            0,
            Color3.fromRGB(95, 98, 105)
        )
    end

    local eventPoints = Instance.new("Folder")
    eventPoints.Name = "EventPoints"
    eventPoints.Parent = arena

    for i = 1, 12 do
        local angle = math.rad((i - 1) * 30)
        local radius = 24 + ((i % 3) * 7)
        local position = Vector3.new(
            math.cos(angle) * radius,
            1.2,
            math.sin(angle) * radius
        )

        local point = Instance.new("Part")
        point.Name = "EventPoint" .. i
        point.Size = Vector3.new(2, 0.2, 2)
        point.CFrame = CFrame.new(position)
        point.Anchored = true
        point.CanCollide = false
        point.CanTouch = false
        point.Transparency = 1
        point.Parent = eventPoints
    end

    return arena
end

local Shared = {}

function Shared.OnStart()
    buildArena()
end

return Shared
