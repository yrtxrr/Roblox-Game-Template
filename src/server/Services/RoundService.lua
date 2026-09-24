local Players = game:GetService("Players")

local Arena = workspace:WaitForChild("Arena")
local SpawnPoints = Arena:WaitForChild("SpawnPoints")

local MIN_PLAYERS = 1
local INTERMISSION_TIME = 10
local ROUND_TIME = 120

local roundActive = false

local function GetSpawnPoints()
    local points = {}

    for _, object in SpawnPoints:GetChildren() do
        if object:IsA("BasePart") then
            table.insert(points, object)
        end
    end

    table.sort(points, function(a, b)
        return a.Name < b.Name
    end)

    return points
end

local function GetAlivePlayers()
    local alivePlayers = {}

    for _, player in Players:GetPlayers() do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.Health > 0 then
            table.insert(alivePlayers, player)
        end
    end

    return alivePlayers
end

local function TeleportPlayers()
    local players = Players:GetPlayers()
    local points = GetSpawnPoints()

    if #points == 0 then
        warn("RoundService: Arena.SpawnPoints contains no spawn points")
        return
    end

    for index, player in players do
        local character = player.Character

        if character and character:FindFirstChild("HumanoidRootPart") then
            local point = points[((index - 1) % #points) + 1]
            character:PivotTo(point.CFrame + Vector3.new(0, 3, 0))
        end
    end
end

local function WaitForPlayers()
    while #Players:GetPlayers() < MIN_PLAYERS do
        task.wait(1)
    end
end

local function RunRound()
    roundActive = true
    TeleportPlayers()

    print("SURVIVAL ROUND STARTED")

    for _ = ROUND_TIME, 1, -1 do
        task.wait(1)

        local alivePlayers = GetAlivePlayers()

        if #alivePlayers <= 1 then
            break
        end
    end

    local survivors = GetAlivePlayers()

    if #survivors == 1 then
        print("WINNER: " .. survivors[1].Name)
    elseif #survivors == 0 then
        print("NO WINNER")
    else
        print("ROUND ENDED: " .. #survivors .. " SURVIVORS")
    end

    roundActive = false
end

function Shared.OnStart()
    task.spawn(function()
        while true do
            WaitForPlayers()

            task.wait(INTERMISSION_TIME)

            if #Players:GetPlayers() >= MIN_PLAYERS then
                RunRound()
            end

            task.wait(3)
        end
    end)
end

function Shared.IsRoundActive()
    return roundActive
end

return Shared
