local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local EVENT_FOLDER = ServerScriptService.Services:WaitForChild("Events")
local Arena = workspace:WaitForChild("Arena")

local remotesFolder = ReplicatedStorage:FindFirstChild("SurvivalRemotes") or Instance.new("Folder")
remotesFolder.Name = "SurvivalRemotes"
remotesFolder.Parent = ReplicatedStorage

local eventRemote = remotesFolder:FindFirstChild("Event") or Instance.new("RemoteEvent")
eventRemote.Name = "Event"
eventRemote.Parent = remotesFolder

local events = {}
for _, module in EVENT_FOLDER:GetChildren() do
    if module:IsA("ModuleScript") then
        local event = require(module)
        if type(event.Run) == "function" then
            table.insert(events, event)
        end
    end
end

local Shared = {}
local rng = Random.new()

function Shared.OnStart()
    -- EventService is driven by RoundService.
end

function Shared.RunRandomEvent(duration: number?)
    if #events == 0 then
        warn("EventService: no events found")
        return nil
    end

    local event = events[rng:NextInteger(1, #events)]
    local eventDuration = duration or rng:NextInteger(8, 14)

    eventRemote:FireAllClients("start", event.Name, eventDuration)

    local ok, cleanup = pcall(function()
        return event.Run(Arena, eventDuration, rng)
    end)

    if not ok then
        warn("EventService failed: " .. tostring(cleanup))
        eventRemote:FireAllClients("end", event.Name)
        return nil
    end

    if type(cleanup) == "function" then
        cleanup()
    end

    eventRemote:FireAllClients("end", event.Name)
    return event.Name
end

function Shared.Broadcast(kind: string, ...)
    eventRemote:FireAllClients(kind, ...)
end

return Shared
