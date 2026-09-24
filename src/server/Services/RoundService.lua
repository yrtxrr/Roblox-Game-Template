local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local EventService = require(ServerScriptService.Services:WaitForChild("EventService"))

local MIN_PLAYERS = 1
local INTERMISSION_TIME = 10
local ROUND_TIME = 120
local EVENT_INTERVAL_MIN = 14
local EVENT_INTERVAL_MAX = 24

local roundActive = false
local roundNumber = 0
local eliminated = {}
local deathConnections = {}

local Shared = {}

local function getArena()
    return workspace:WaitForChild("Arena")
end

local function getSpawnPoints()
    local folder = getArena():WaitForChild("SpawnPoints")
    local points = {}

    for _, object in folder:GetChildren() do
        if object:IsA("BasePart") then
            table.insert(points, object)
        end
    end

    table.sort(points, function(a, b)
        return a.Name < b.Name
    end)

    return points
end

local function getActivePlayers()
    local active = {}

    for _, player in Players:GetPlayers() do
        if not eliminated[player] then
            table.insert(active, player)
        end
    end

    return active
end

local function disconnectDeathConnections()
    for player, connection in pairs(deathConnections) do
        connection:Disconnect()
        deathConnections[player] = nil
    end
end

local function setupDeathTracking(player)
    local function connectCharacter(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then
            return
        end

        if deathConnections[player] then
            deathConnections[player]:Disconnect()
        end

        deathConnections[player] = humanoid.Died:Connect(function()
            if roundActive and not eliminated[player] then
                eliminated[player] = true
                player:SetAttribute("AliveInRound", false)
            end
        end)
    end

    if player.Character then
        connectCharacter(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        if roundActive and eliminated[player] then
            player:SetAttribute("AliveInRound", false)
        elseif roundActive then
            connectCharacter(character)
        end
    end)
end

local function preparePlayers()
    local players = Players:GetPlayers()
    local points = getSpawnPoints()

    if #points == 0 then
        warn("RoundService: no spawn points")
        return
    end

    table.clear(eliminated)
    disconnectDeathConnections()

    for index, player in ipairs(players) do
        eliminated[player] = false
        player:SetAttribute("AliveInRound", true)

        if not player.Character or not player.Character:FindFirstChildOfClass("Humanoid") then
            player:LoadCharacter()
        end

        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:WaitForChild("HumanoidRootPart", 5)

        if root then
            local point = points[((index - 1) % #points) + 1]
            character:PivotTo(point.CFrame + Vector3.new(0, 4, 0))
        end

        setupDeathTracking(player)
    end
end

local function finishRound()
    local survivors = getActivePlayers()

    if #survivors == 1 then
        local winner = survivors[1]
        print("WINNER: " .. winner.Name)
        EventService.Broadcast("winner", "ПОБЕДИТЕЛЬ: " .. winner.DisplayName)
    elseif #survivors == 0 then
        print("NO WINNER")
        EventService.Broadcast("winner", "НИКТО НЕ ВЫЖИЛ")
    else
        print("ROUND ENDED: " .. #survivors .. " SURVIVORS")
        EventService.Broadcast("winner", "ВЫЖИЛИ: " .. #survivors)
    end

    for _, player in Players:GetPlayers() do
        player:SetAttribute("AliveInRound", false)
    end

    disconnectDeathConnections()
    eliminated = {}
end

local function runRound()
    roundActive = true
    roundNumber += 1

    preparePlayers()

    EventService.Broadcast("phase", "РАУНД " .. roundNumber, ROUND_TIME)
    print("SURVIVAL ROUND " .. roundNumber .. " STARTED")

    local initialPlayers = #Players:GetPlayers()
    local nextEventAt = os.clock() + math.random(EVENT_INTERVAL_MIN, EVENT_INTERVAL_MAX)

    for remaining = ROUND_TIME, 1, -1 do
        if #Players:GetPlayers() == 0 then
            break
        end

        EventService.Broadcast("timer", remaining)

        local activeCount = #getActivePlayers()

        -- A solo test round is allowed to run for the full duration.
        if initialPlayers > 1 and activeCount <= 1 then
            break
        end

        if os.clock() >= nextEventAt then
            EventService.RunRandomEvent()
            nextEventAt = os.clock() + math.random(EVENT_INTERVAL_MIN, EVENT_INTERVAL_MAX)
        end

        task.wait(1)
    end

    finishRound()
    roundActive = false
end

local function waitForPlayers()
    while #Players:GetPlayers() < MIN_PLAYERS do
        EventService.Broadcast("phase", "ОЖИДАНИЕ ИГРОКОВ", "")
        task.wait(1)
    end
end

function Shared.OnStart()
    task.spawn(function()
        while true do
            waitForPlayers()

            for remaining = INTERMISSION_TIME, 1, -1 do
                EventService.Broadcast("phase", "РАУНД НАЧНЁТСЯ", remaining)
                task.wait(1)
            end

            if #Players:GetPlayers() >= MIN_PLAYERS then
                runRound()
            end

            task.wait(4)
        end
    end)
end

function Shared.IsRoundActive()
    return roundActive
end

Players.PlayerRemoving:Connect(function(player)
    eliminated[player] = nil

    if deathConnections[player] then
        deathConnections[player]:Disconnect()
        deathConnections[player] = nil
    end
end)

return Shared
