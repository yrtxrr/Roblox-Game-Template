local Players = game:GetService("Players")

local Local = {}
local Shared = {}

local MIN_PLAYERS = 2
local INTERMISSION_TIME = 10
local ROUND_TIME = 120

local roundActive = false

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

local function WaitForPlayers()
    while #Players:GetPlayers() < MIN_PLAYERS do
        task.wait(1)
    end
end

local function RunRound()
    roundActive = true

    print("ROUND STARTED")

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
